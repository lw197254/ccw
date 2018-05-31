//
//  BrowseViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/18.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BrowseViewController.h"

#import "BrowseUITableView.h"

#import "BrowseKouBeiCarDeptModel.h"
#import "BrowseKouBeiCarTypeModel.h"
#import "BrowseKouBeiDBModel.h"
#import "BrowseKouBeiArtModel.h"

@interface BrowseViewController ()
@property(nonnull,strong)UIScrollView *scrollView;
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property(nonatomic,strong)NSArray *arryList;

@property(nonatomic,strong)NSMutableArray *tabelViewList;

@property(strong,nonatomic)UIButton*rightButton;
@property(strong,nonatomic)UIButton*leftButton;

@property(nonatomic,strong)BrowseUITableView *currentTableView;

@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,strong)NSMutableDictionary *currentListArray;
@property(nonatomic,assign)BOOL isEdit;
///屏幕高宽
@property(nonatomic,assign)CGRect rx;
//当前页面的current
@property(nonatomic,assign)NSInteger currentpage;
@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.currentListArray = [NSMutableDictionary dictionaryWithCapacity:5];
     self.view.backgroundColor = [UIColor whiteColor];
    self.rx = [ UIScreen mainScreen ].bounds;
    self.currentpage = 0;
    [self initBaseView];
    
    [self initSelection];
    [self initScrollView];
    [self initTableView];
    
    [self showNavigationTitle:@"浏览记录"];
    
}

-(void)initBaseView{
    if (!_rightButton) {
        _rightButton = [Tool createButtonWithTitle:@"编辑" titleColor:BlackColor666666 target:self        action:@selector(rightButtonClicked:)];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
       
        [_rightButton setTitleColor:BlackColor666666 forState:UIControlStateSelected];
        [_rightButton setTintColor:[UIColor clearColor]];
        
    }
    
    [self showBarButton:NAV_RIGHT button:_rightButton];
    [self showBarButton:NAV_LEFT imageName:@"ic_back"];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview: self.deleteButton];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(49);
        make.width.mas_offset(kwidth);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.deleteButton setBackgroundColor:RedColorFE5050];
    
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font =FontOfSize(17);
    self.deleteButton.titleLabel.textColor = [UIColor whiteColor];
    
    //处理按钮点击事件
    [self.deleteButton  addTarget:self action:@selector(deleteList:)forControlEvents: UIControlEventTouchUpInside];
    
    self.deleteButton.hidden =YES;
}

//初始化 ScrollView
-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled =YES;
    
    [self.scrollView setScrollEnabled:YES];
    
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.selectionList.mas_bottom);
        make.height.mas_equalTo(kheight);
    }];
    
    //设置滚动视图的位置
    [self.scrollView setContentSize:CGSizeMake(4*kwidth, self.scrollView.bounds.size.height)];
}


//初始化 SelectionList
-(void)initSelection{
    self.selectionList = [[HTHorizontalSelectionList alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.selectionList];
    
    self.selectionList.delegate = self;
    [self.selectionList setTitleColor:BlackColor999999 forState:UIControlStateNormal];
    
    self.selectionList.selectionIndicatorColor = BlueColor447FF5;
    self.selectionList.dataSource = self;
    
    self.selectionList.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
    [self initSelectionList];
    
    //加入seclection
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.view);
    }];
    
    self.selectionList.backgroundColor = BlackColorF8F8F8;
    
    self.selectionList.maxShowCount = 5;
}

///初始化首页按钮数据
-(void)initSelectionList{
    self.arryList =  @[@{@"name":@"车系"},@{@"name":@"车型"},@{@"name":@"口碑"},@{@"name":@"文章"}];
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.arryList.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return self.arryList[index][@"name"];
}

//滑动 ScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+self.rx.size.width/2)/self.rx.size.width;
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating&&self.currentpage != current){
            self.currentpage  = current;
            [self.selectionList setSelectedButtonIndex:current];
            [self selectionList:self.selectionList didSelectButtonWithIndex:current];
           
            NSLog(@"正常切换");
        }
    }
    
}



-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    BrowseUITableView *view  = self.tabelViewList[index];
    [self.currentListArray removeAllObjects];
    self.currentTableView = view;
    self.currentTableView.type = index;
    
    if([self.currentTableView numberOfRowsInSection:0]>0){
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }

    
    [self.scrollView setContentOffset:view.frame.origin animated:YES];
}

///初始化collectonview
-(void)initTableView{
    self.tabelViewList = [[NSMutableArray alloc]init];
    
    for (NSInteger i=0; i< self.arryList.count; i++) {
        [self tableView:i];
    }
    
    self.currentTableView  = self.tabelViewList[0];
}

//初始化 CollectionView
-(void)tableView:(NSInteger) count{
//    // 状态栏(statusbar)
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//    NSLog(@"status width - %f", rectStatus.size.width); // 宽度
//    NSLog(@"status height - %f", rectStatus.size.height);   // 高度
//    
//    // 导航栏（navigationbar）
//    CGRect rectNav = self.rt_navigationController.navigationBar.frame;
    
    BrowseUITableView *tableView = [[BrowseUITableView alloc] initWithFrame:CGRectMake(count*kwidth,0,kwidth,kheight-40-64) style:UITableViewStylePlain];
    
   
    tableView.type = count;
    tableView.tag = count;
    tableView.block = ^(NSMutableDictionary *array){
        self.currentListArray = array;
    };
    
//    UIView*view = [[UIView alloc]init];
//    [self.scrollView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.scrollView);
//        make.centerY.equalTo(self.scrollView);
//    }];
    [self.scrollView addSubview:tableView];
    
    [self.tabelViewList addObject:tableView];
}

-(void)updateRightButton{
    
    if([self.currentTableView numberOfRowsInSection:0]>0){
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }

}
-(void)rightButtonClicked:(UIButton*)button{
   
    if (!self.isEdit) {
        //点击编辑之后
        self.currentTableView.edited = YES;
        self.scrollView.scrollEnabled = NO;
        self.fd_interactivePopDisabled = YES;
        self.currentTableView.allowsMultipleSelection = YES;
        self.deleteButton.hidden =NO;
        [self bianji];
        self.isEdit = YES;
        [self.currentTableView reloadData];
        NSLog(@"%f",self.scrollView.contentOffset.x);
    }else {
        //点击全选之后
        button.selected = !button.selected;
        if (button.selected ) {
            ///进行全选
            self.currentTableView.selectedAll =YES;
            self.currentTableView.edited = YES;
            self.currentTableView.allowsMultipleSelection = YES;
            [self.currentTableView selectStatus];
        }else{
            ///取消全选
            self.currentTableView.selectedAll =NO;
            self.currentTableView.edited = YES;
            self.currentTableView.allowsMultipleSelection = YES;
            [self.currentTableView selectStatus];
        }

        
    }
    
}

-(void)leftButtonClicked{
    [self.selectionList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.scrollView setContentOffset:self.currentTableView.frame.origin animated:NO];
    self.isEdit = NO;
    self.rightButton.selected = NO;
    self.scrollView.scrollEnabled = YES;
    self.fd_interactivePopDisabled = NO;
    self.currentTableView.edited = NO;
    self.currentTableView.allowsMultipleSelection = NO;
    self.deleteButton.hidden =YES;
//    [self.currentTableView selectStatus];
    [self.currentTableView reloadData];
    
    [self showBarButton:NAV_LEFT imageName:@"ic_back"];
}

//点击编辑的时候界面的变化
-(void)bianji{
    [self.selectionList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.scrollView setContentOffset:self.currentTableView.frame.origin animated:NO];
    
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _leftButton.frame = CGRectMake(0, 0, 60, 30);
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [self showBarButton:NAV_LEFT button:_leftButton];
}

-(void)leftButtonTouch{
    
    if(!self.isEdit){
        
        [super leftButtonTouch];
    }else{
        [self leftButtonClicked];
    }
}


//删除list
-(void)deleteList:(UIButton *)button{
    bool clear = false;
    switch (self.currentTableView.type) {
        case 0:{
            for (NSString *s in [self.currentListArray allValues]) {
                [[[BrowseKouBeiCarDeptModel Model] where:@{@"id":s}] delete ];
            }
            if ([BrowseKouBeiCarDeptModel findAll].count==0) {
                clear = true;
            }
        }
            break;
        case 1:
        {
            for (NSString *s in [self.currentListArray allValues]) {
                [[[BrowseKouBeiCarTypeModel Model] where:@{@"id":s}] delete ];
            }
            if ([BrowseKouBeiCarTypeModel findAll].count==0) {
                clear = true;
            }
        }
            break;
        case 2:
        {
            for (NSString *s in [self.currentListArray allValues]) {
                [[[BrowseKouBeiDBModel Model] where:@{@"id":s}] delete ];
            }
            if ([BrowseKouBeiDBModel findAll].count==0) {
                clear = true;
            }
        }
            break;
        case 3:
        {
            for (NSString *s in [self.currentListArray allValues]) {
                [[[BrowseKouBeiArtModel Model] where:@{@"id":s}] delete ];
            }
            if ([BrowseKouBeiArtModel findAll].count==0) {
                clear = true;
            }
        }
            break;
        default:
            break;
    };
    
    [self rebuildView:clear];
}
-(void)setIsEdit:(BOOL)isEdit{
    if (_isEdit!=isEdit) {
        _isEdit = isEdit;
    }
    if (!isEdit) {
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        [self.rightButton setTitle:@"全选" forState:UIControlStateNormal];
        [self.rightButton setTitle:@"取消全选" forState:UIControlStateSelected];
    }
}
-(void)rebuildView:(bool) clear{
    //清除干净
//    if(clear){
         [self leftButtonClicked];
//    }
    [self.currentTableView reloadData];
    [self updateRightButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.scrollView setContentOffset:self.currentTableView.frame.origin animated:NO];
    [self.currentTableView reloadData];
    [self updateRightButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
