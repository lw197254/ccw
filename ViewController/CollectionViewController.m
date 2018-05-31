//
//  CollectionViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CollectionViewController.h"
#import "FavouriteTableView.h"

#import "KouBeiCarDeptModel.h"
#import "KouBeiCarTypeModel.h"
#import "KouBeiDBModel.h"
#import "KouBeiArtModel.h"

#import "SubjectAndSaveObject.h"


@interface CollectionViewController ()
@property(nonnull,strong)UIScrollView *scrollView;
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property(nonatomic,strong)NSArray *arryList;

@property(nonatomic,strong)NSMutableArray *tabelViewList;

@property(strong,nonatomic)UIButton*rightButton;
@property(strong,nonatomic)UIButton*leftButton;

@property(nonatomic,strong)FavouriteTableView *currentTableView;

@property(nonatomic,strong)UIButton *deleteButton;

@property(nonatomic,strong)NSMutableDictionary *currentListArray;

///屏幕高宽
@property(nonatomic,assign)CGRect rx;
//当前页面的current
@property(nonatomic,assign)NSInteger currentpage;

@property(nonatomic,strong)SubjectAndSaveObject *subjectTool;
@property(nonatomic,assign)BOOL isEdit;
@end

@implementation CollectionViewController

-(SubjectAndSaveObject *)subjectTool{
    if (!_subjectTool) {
        _subjectTool = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.currentListArray = [NSMutableDictionary dictionaryWithCapacity:5];
    self.rx = [ UIScreen mainScreen ].bounds;
    self.currentpage = 0;
    
    [self initBaseView];
    
    [self initSelection];
    [self initScrollView];
    [self initTableView];
    
    [self setTitle:@"我的收藏"];

}

-(void)initBaseView{
    if (!_rightButton) {
        
        _rightButton = [Tool createButtonWithTitle:@"编辑" titleColor:BlackColor666666 target:self        action:@selector(rightButtonClicked:)];
          [_rightButton setTitleColor:BlackColor666666 forState:UIControlStateSelected];
        _rightButton.frame = CGRectMake(0, 0, 60, 30);
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
       
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
    
    [self.deleteButton setBackgroundColor:RedColorFE5050 ];
    
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
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.selectionList.mas_bottom);
    }];
    //设置滚动视图的位置
    [self.scrollView setContentSize:CGSizeMake(4*kwidth, self.scrollView.bounds.size.height)];
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


//初始化 SelectionList
-(void)initSelection{
    self.selectionList = [[HTHorizontalSelectionList alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.selectionList];
    
    self.selectionList.delegate = self;
    [self.selectionList setTitleColor:BlackColor999999 forState:UIControlStateNormal];
    self.selectionList.maxShowCount = 4;
    self.selectionList.minShowCount = 4;
    
    self.selectionList.selectionIndicatorColor = BlueColor447FF5;
    self.selectionList.backgroundColor = BlackColorF8F8F8;
    self.selectionList.dataSource = self;
    
    //初始化数据
    [self initSelectionList];
    
    //加入seclection
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.view);
    }];
    
    self.selectionList.backgroundColor =BlackColorF8F8F8 ;
    
    
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


-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    self.currentpage = index;
    [self chooseTableView:index];
}

//选择正确的按钮
-(void)chooseTableView:(NSInteger) index{
    FavouriteTableView *view  = self.tabelViewList[index];
    [self.currentListArray removeAllObjects];
    self.currentTableView = view;
    self.currentTableView.type = index;
 
    
    
    NSInteger currentcout = [self.currentTableView numberOfRowsInSection:0];
    
    
    if(currentcout > 0 ){
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }
    
    [self.scrollView setContentOffset:view.frame.origin animated:YES];
}
-(void)updateRightButton{
    
    if([self.currentTableView numberOfRowsInSection:0]>0){
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }
    
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
    
    
    FavouriteTableView *tableView = [[FavouriteTableView alloc] initWithFrame:CGRectMake(count*kwidth,0,kwidth,kheight-40-64) style:UITableViewStylePlain];
    
    tableView.type = count;
    
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if([tableView numberOfRowsInSection:0]>0){
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }
    
    tableView.block = ^(NSMutableDictionary *array){
        self.currentListArray = array;
    };
    
    [self.scrollView addSubview:tableView];
    
    [self.tabelViewList addObject:tableView];
}


//-(void)rightButtonClicked:(UIButton*)button{
//    
//    if ([button.titleLabel.text isEqualToString:@"编辑"]) {
//        //点击编辑之后
//        self.currentTableView.edited = YES;
//        self.scrollView.scrollEnabled = NO;
//        self.fd_interactivePopDisabled = YES;
//        self.currentTableView.allowsMultipleSelection = YES;
//        self.deleteButton.hidden =NO;
//        [self bianji];
//        _rightButton.selected =YES;
//        [self.currentTableView reloadData];
//        NSLog(@"%f",self.scrollView.contentOffset.x);
//    }else if([button.titleLabel.text isEqualToString:@"全选"]){
//        //点击全选之后
//        self.currentTableView.edited = YES;
//        self.currentTableView.selectedAll =YES;
//        self.currentTableView.allowsMultipleSelection = YES;
//        [self.currentTableView selectStatus];
//    }
//}
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
    _rightButton.selected = NO;
    self.currentTableView.edited = NO;
    ///
    self.fd_interactivePopDisabled = NO;
    self.currentTableView.allowsMultipleSelection = NO;
    self.deleteButton.hidden =YES;
    self.currentTableView.selectedAll = NO;
    [self.currentTableView selectStatus];
    [self.currentTableView buildReload];
    self.scrollView.scrollEnabled = YES;
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
        [_leftButton setTitleColor:BlackColor666666 forState:UIControlStateNormal];
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
//                for (NSString *s in [self.currentListArray allValues]) {
//                    [[[KouBeiCarDeptModel Model] where:@{@"id":s}] delete ];
//                }
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSString *s in [self.currentListArray allValues]) {
                    [array addObject:s];
                }
                
                [self.subjectTool InfoMoveObjects:array typeid:chexi];
                if ([KouBeiCarDeptModel findAll].count==0) {
                    clear = true;
                }
              }
                break;
            case 1:
            {
//                for (NSString *s in [self.currentListArray allValues]) {
//                    [[[KouBeiCarTypeModel Model] where:@{@"id":s}] delete ];
//                }
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSString *s in [self.currentListArray allValues]) {
                    [array addObject:s];
                }
                
                [self.subjectTool InfoMoveObjects:array typeid:chexing];
                if ([KouBeiCarTypeModel findAll].count==0) {
                    clear = true;
                }
            }
                break;
            case 2:
            {
//                for (NSString *s in [self.currentListArray allValues]) {
//                    [[[KouBeiDBModel Model] where:@{@"id":s}] delete ];
//                }
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSString *s in [self.currentListArray allValues]) {
                    [array addObject:s];
                }
                
                [self.subjectTool InfoMoveObjects:array typeid:koubeiInfo];
                if ([KouBeiDBModel findAll].count==0) {
                    clear = true;
                }
            }
                break;
            case 3:
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSString *s in [self.currentListArray allValues]) {
                    [array addObject:s];
                }
                
                [self.subjectTool InfoMoveObjects:array typeid:artInfo];
                
                if ([KouBeiArtModel findAll].count==0) {
                    clear = true;
                }
            }
                break;
            default:
                break;
    };
    @weakify(self)
    _subjectTool.infoBlock = ^(bool isok) {
        [self_weak_ rebuildView:clear];
    };
    
}

-(void)rebuildView:(bool) clear{
    //清除干净
//    if(clear){
        [self leftButtonClicked];
//    }
     [self.currentTableView reloadData];
     [self chooseTableView:self.currentTableView.type];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.scrollView setContentOffset:self.currentTableView.frame.origin animated:NO];
    [self.currentTableView buildReload];
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
