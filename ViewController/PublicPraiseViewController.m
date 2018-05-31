//
//  PublicPraiseViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicPraiseViewController.h"
#import "PublicPraiseViewModel.h"
#import "PublicPraiseTableViewCell.h"

#import "PublicPraiseCheXingTableView.h"
#import "PublicPraiseTableView.h"
#import "PublicPariseCarNameTableViewCell.h"
#import "PublicPraiseCarsViewModel.h"
#import "KouBeiCarsModel.h"


#import "AskForPriceNewViewController.h"
#import "PopUpView.h"
#import "LineView.h"
#import "TitleView.h"

static NSString *cell = @"PublicPariseCarNameTableViewCell";
@interface PublicPraiseViewController ()<UITableViewDelegate,UITableViewDataSource,PopUpViewDeleagte>

@property(nonatomic,strong)NSArray *listArray;
@property(nonnull,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *scrollViewContentView;
@property(nonatomic,strong)NSMutableArray *tabelViewList;
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;

@property(nonatomic,strong)PublicPraiseCarsViewModel *carmodel;


@property(nonatomic,strong)UITableView *popTableView;
//@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UIView *popdownView;

@property(nonatomic,strong)NSMutableArray<KouBeiCarsModel> *cars;

@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UIView*askForPriceContentView;
///箭头图片
@property(nonatomic,strong) UIImageView *jiantouImageView;
//头部对象 车型名称
@property(nonatomic,strong)UILabel *carTypeNameLabel;
//头部对象 车系名称
@property(nonatomic,strong)UILabel *carSeriesNameLabel;
//当前页面
@property(nonatomic,assign)NSInteger currentpage;

@property(nonatomic,strong)PopUpView *popUpView;

//@property(nonatomic,strong)UIView *viewHead;
//
//@property(nonatomic,strong)UITableView *topParentTableView;
//
//@property(nonatomic,assign)NSInteger childScrollHeight;
@end

//static NSInteger VIEWHEAD = 300;
//static NSInteger PLACEHOLDER = 40;

@implementation PublicPraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cars = [[NSMutableArray<KouBeiCarsModel> alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self initViewHead];
    [self initSelectionLis];
    [self initScrollView];
    [self initTableView];
 
//    [self initXunView];
    
    
    if ([self.catTypeId isNotEmpty]) {
        [self initPopTable];
       
    }
     [self initTitleView];
    
    self.currentpage = 0;
//    self.childScrollHeight = 0;
    //[self setNavigationButtontitle:@"车系名口碑" textColor:[UIColor blackColor]];
//    [self.topParentTableView reloadData];
}

//-(void)initViewHead{
//    self.topParentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.topParentTableView.delegate =self;
//    self.topParentTableView.dataSource =self;
//    self.topParentTableView.estimatedSectionFooterHeight=0;
//    self.topParentTableView.estimatedSectionHeaderHeight=0;
//    self.topParentTableView.estimatedRowHeight=0;
//
//    [self.view addSubview:self.topParentTableView];
//    [self.topParentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//
//    self.viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, VIEWHEAD)];
//    [self.viewHead setBackgroundColor:[UIColor redColor]];
//
//    self.topParentTableView.tableHeaderView = self.viewHead;
//
//}

////询价按钮的初始化
//-(void)initXunView{
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:BlackColorF8F8F8];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kwidth);
//        make.height.mas_equalTo(65);
//        make.bottom.equalTo(self.view);
//    }];
//    
//    UIButton *button = [[UIButton alloc] init];
//    [button.layer setCornerRadius:4.0];
//    [button.layer setMasksToBounds:YES];
//    
//    [button setTitle:@"询底价" forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"buttonBlueNormal"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"buttonBlueSelected"] forState:UIControlStateSelected];
//    button.titleLabel.font = FontOfSize(17);
//    button.titleLabel.textColor = [UIColor whiteColor];
//    
//    
//    [view addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_top).offset(10);
//        make.left.equalTo(view.mas_left).offset(10);
//        make.right.equalTo(view.mas_right).offset(-10);
//        make.bottom.equalTo(view.mas_bottom).offset(-10);
//    }];
//    
//    [button addTarget:self action:@selector(askForPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
//}
//


-(void)initTitleView{
    
    self.titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, kwidth/2, 40)];
    self.navigationItem.titleView = self.titleView;
   
    ///车系名字
    self.carSeriesNameLabel = [Tool createLabelWithTitle:self.carSeriesName textColor:BlackColor333333 tag:0];
    self.carSeriesNameLabel.font = FontOfSize(17);
    self.carSeriesNameLabel.lineBreakMode =NSLineBreakByTruncatingMiddle;
    self.carSeriesNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.carSeriesNameLabel];
    
    [self.carSeriesNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.centerX.equalTo(self.titleView);
        
        make.width.mas_lessThanOrEqualTo(200);
    }];    
    ///车型名字
  
    self.carTypeNameLabel = [Tool createLabelWithTitle:self.carTypeName textColor:BlackColor999999 tag:0];
    if (self.carTypeName.length ==0) {
        self.carTypeNameLabel.text = @"全部车型";
    }
    self.carTypeNameLabel.font = FontOfSize(13);
    self.carTypeNameLabel.textAlignment = NSTextAlignmentCenter;
    self.carTypeNameLabel.lineBreakMode =NSLineBreakByTruncatingMiddle;
    [self.titleView addSubview:self.carTypeNameLabel];
    
    [self.carTypeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carSeriesNameLabel.mas_bottom);
        make.centerX.bottom.equalTo(self.titleView);
        make.width.mas_lessThanOrEqualTo(200);
    }];
   
    
   
    
    if(self.carTypeName.length == 0){
        self.jiantouImageView = [[UIImageView alloc] init];
        self.jiantouImageView.image = [UIImage imageNamed:@"箭头向下"];
        [self.titleView addSubview:self.jiantouImageView];
        
        [self.jiantouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carSeriesNameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.carSeriesNameLabel);
            
        }];
        
    
         self.titleView.userInteractionEnabled = YES;
        
    }else{
        self.titleView.userInteractionEnabled = NO;
    }
    
    self.navigationItem.titleView = self.titleView;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topclick:)];
 
    [self.titleView addGestureRecognizer:tapRecognizer];
    
}

-(void)initPopTable{
    
    self.popUpView = [[PopUpView alloc] init];
    self.popUpView.deleagate = self;
    [self.view addSubview:self.popUpView];
    [self.popUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.popTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
   
    
    self.popTableView.delegate = self;
    self.popTableView.dataSource = self;
    self.popTableView.backgroundColor = [UIColor whiteColor];
    self.popTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.popTableView registerNib:[UINib nibWithNibName:cell bundle:nil] forCellReuseIdentifier:cell];
    
    self.carmodel = [PublicPraiseCarsViewModel SceneModel];
    self.carmodel.request.chexiId =self.catTypeId;
    self.carmodel.request.startRequest = YES;
    
    [[RACObserve(self.carmodel, data)
     filter:^BOOL(id value) {
         return self.carmodel.data.isNotEmpty;
     }]subscribeNext:^(id x) {
         self.cars = [self.carmodel.data.cars copy];
         [self changeCarsList];
         [self.popTableView reloadData];
     }];
    
    self.popUpView.targetView = self.popTableView;
    [self.popUpView builderView];
    self.popUpView.hidden = YES;
    
    
    __weak PublicPraiseViewController *weakself = self;
    self.popUpView.block = ^{
        __strong PublicPraiseViewController *strongself = weakself;
        if (strongself) {
             strongself.jiantouImageView.image = [UIImage imageNamed:@"箭头向下"];
        }
    };
}
#pragma PopUpViewDeleagte
-(void)buildTargetView:(UIView *)targetView
{
    self.popUpView.targetViewHeight = 350;
    [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(self.view);
        make.height.mas_equalTo(350);
    }];
}


//初始化 ScrollView
-(void)initScrollView{
    [self.view addSubview:self.askForPriceContentView];
    [self.askForPriceContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottom);
    }];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled =YES;
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.scrollView setScrollEnabled:YES];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.askForPriceContentView.mas_top);
        make.top.equalTo(self.selectionList.mas_bottom);

    }];
    self.scrollViewContentView = [[UIView alloc]init];
    [self.scrollView addSubview:self.scrollViewContentView];
    [self.scrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.centerY.equalTo(self.scrollView);
    }];
    
//    self.topParentTableView.tableFooterView = self.scrollView;
//    [self.topParentTableView.tableFooterView setUserInteractionEnabled:NO];
   
}

//初始化 SelectionList
-(void)initSelectionLis{
    self.selectionList = [[HTHorizontalSelectionList alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.selectionList];
    
    self.selectionList.delegate = self;
    [self.selectionList setTitleColor:BlackColor888888 forState:UIControlStateNormal];
    
    [self.selectionList setTitleColor:BlackColor333333 forState:UIControlStateSelected];
    self.selectionList.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
    self.selectionList.titleFont = FontOfSize(14);
    self.selectionList.dataSource = self;
    
    self.selectionList.backgroundColor =[UIColor whiteColor];
    
    //初始化数据
    [self initSelectionList];
    
    //加入seclection
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kwidth);
    }];
    self.selectionList.showRightMaskView = YES;
    
    
//    UIView *view = [[UIView alloc] init];
//    [self.selectionList addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(self.view);
//        make.height.mas_equalTo(1);
//    }];
//    view.backgroundColor= seperateLineColor;
//    view.alpha =0.1;
    
    self.selectionList.maxShowCount = 5;
}


///初始化首页按钮数据
-(void)initSelectionList{
    self.listArray = @[@{@"name":@"综合",@"value":@"11"},@{@"name":@"最满意",@"value":@"9"},@{@"name":@"最不满意",@"value":@"10"},@{@"name":@"空间",@"value":@"1"}
                       ,@{@"name":@"动力",@"value":@"2"}
                       ,@{@"name":@"操控",@"value":@"3"}
                       ,@{@"name":@"油耗",@"value":@"4"}
                       ,@{@"name":@"舒适性",@"value":@"5"}
                       ,@{@"name":@"外观",@"value":@"6"}
                       ,@{@"name":@"内饰",@"value":@"7"}
                       ,@{@"name":@"性价比",@"value":@"8"}];
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.listArray.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return self.listArray[index][@"name"];
}

-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    PublicPraiseTableView *view  = self.tabelViewList[index];
    self.currentpage = index;
    [self.scrollView setContentOffset:view.frame.origin animated:YES];
}

///初始化collectonview
-(void)initTableView{
    
    self.tabelViewList = [[NSMutableArray alloc]init];
    
    if ([self.catTypeId isNotEmpty]) {
        for (NSInteger i=0; i< self.listArray.count; i++) {
            [self tableView:i];
            
        }
    }else{
        for (NSInteger i=0; i< self.listArray.count; i++) {
            [self tableViewCXing:i];
        }
    }
    
    
}

//初始化 车系tableview
-(void)tableView:(NSInteger) count{
    
    PublicPraiseTableView *tableView= [[PublicPraiseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
//    __weak PublicPraiseViewController *weakself = self;
//    tableView.block = ^(UIScrollView *scroll) {
//        __strong PublicPraiseViewController *strongself = weakself;
//        if (strongself) {
//            [strongself scrollViewDidScroll:scroll];
//        }
//    };
    
    [self.scrollViewContentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollViewContentView);
        make.width.mas_equalTo(kwidth);
        if (count==0) {
            make.left.equalTo(self.scrollViewContentView);
        }else{
            UITableView*leftView = self.tabelViewList[count-1];
            make.left.equalTo(leftView.mas_right);
        }
        if (count==self.listArray.count-1) {
            make.right.equalTo(self.scrollViewContentView);
        }
    }];

    [self.tabelViewList addObject:tableView];
    

    
    
    [self initDate:count];
   
    
    
}


//初始化 车型tableview
-(void)tableViewCXing:(NSInteger) count{
    
    PublicPraiseCheXingTableView *tableView= [[PublicPraiseCheXingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.scrollViewContentView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollViewContentView);
        make.width.mas_equalTo(kwidth);
        if (count==0) {
            make.left.equalTo(self.scrollViewContentView);
        }else{
            UITableView*leftView = self.tabelViewList[count-1];
            make.left.equalTo(leftView.mas_right);
        }
        if (count==self.listArray.count-1) {
            make.right.equalTo(self.scrollViewContentView);
        }
    }];
    
    [self.tabelViewList addObject:tableView];
    
    [self initDate:count];
}



-(void)initDate:(NSInteger )index{
    /// 车系
    if([self.catTypeId isNotEmpty]){
        //车系中的车型
        if ([self.chexingId isNotEmpty]) {
            if (index==0) {
                PublicPraiseTableView *view  = self.tabelViewList[index];
                //加载更多从第二页开始
                view.page = 1;
                view.isFirstTab  = YES;
                view.isChexingTab  = YES;
                
                [view cheXingKouBei];
                view.cxingmodel.request.s = self.listArray[index][@"value"];
                view.cxingmodel.request.chexingId = self.chexingId;
                
             
               
                view.topcxingViewModel.request.chexingId = self.chexingId;
                [view.mj_header beginRefreshing];
                
            }else{
                PublicPraiseTableView *view  = self.tabelViewList[index];
             
                view.page = 1;
                view.isFirstTab  = NO;
                view.isChexingTab  = YES;
                
                [view cheXingKouBei];
                
                view.cxingmodel.request.s = self.listArray[index][@"value"];
                view.cxingmodel.request.chexingId = self.chexingId;
                
                [view.mj_header beginRefreshing];
            }
        }else{
            //车系
            if (index==0) {
                PublicPraiseTableView *view  = self.tabelViewList[index];
                //加载更多从第二页开始
                view.page = 1;
                view.isFirstTab  = YES;
                view.isChexingTab  = NO;
                view.s = self.listArray[index][@"value"];
                
                [view cheXiKouBei];
                
                view.model.request.s = self.listArray[index][@"value"];
                view.model.request.chexiId = self.catTypeId;
                
                
                view.topViewModel.request.chexiId = self.catTypeId;
                 [view.mj_header beginRefreshing];
            }else{
                PublicPraiseTableView *view  = self.tabelViewList[index];
                [view cheXiKouBei];
                view.page = 1;
                view.isFirstTab  = NO;
                view.isChexingTab  = NO;
                view.model.request.s = self.listArray[index][@"value"];
                view.model.request.chexiId = self.catTypeId;
                view.model.request.page = 1;
      
                [view.mj_header beginRefreshing];
            }

        }
    }
    //车型
    else{
        if (index==0) {
            PublicPraiseCheXingTableView *view  = self.tabelViewList[index];
            view.page = 1;
            view.isFirstTab  = YES;
            
            view.model.request.s = self.listArray[index][@"value"];
            view.model.request.chexingId = self.chexingId;
            
            view.topViewModel.request.chexingId = self.chexingId;
            view.topViewModel.request.startRequest =YES;
            
        }else{
            PublicPraiseCheXingTableView *view  = self.tabelViewList[index];
            view.page = 1;
            view.isFirstTab  = NO;
            view.model.request.s = self.listArray[index][@"value"];
            view.model.request.chexingId = self.chexingId;
             [view.mj_header beginRefreshing];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cars.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicPariseCarNameTableViewCell *tablecell = [tableView dequeueReusableCellWithIdentifier:cell forIndexPath:indexPath];
    KouBeiCarsModel *car = (KouBeiCarsModel *)self.cars[indexPath.row];
    
    tablecell.selectionStyle = UITableViewCellSelectionStyleNone;
    tablecell.carname.text = car.car_name;
    if([car.koubei_num isNotEmpty]){
    NSString *s=@"共";
    s = [s stringByAppendingString:car.koubei_num];
    s = [s stringByAppendingString:@"篇口碑"];
    tablecell.carpage.text = s;
    }else{
        tablecell.carpage.text =@"";
    }
    return tablecell;
}

//选中某个列表之后的数据请求
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KouBeiCarsModel *car = (KouBeiCarsModel *)self.cars[indexPath.row];
    self.chexingId = car.car_id;
    
    
    //选择原始车系，那么chexingid为空
    if([car.car_name isEqualToString:self.carSeriesName]){
        self.chexingId = @"";
        self.carTypeNameLabel.text = @"全部车型";
    }else{
        self.carTypeNameLabel.text = car.car_name;
        self.carTypeName = car.car_name;
    }
    
    for (NSInteger i=0; i< self.listArray.count; i++) {
        [self initDate:i];
    }

    
    
    [self topclick:nil];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;

}
-(void)askForPriceClicked:(UIButton*)button{
    AskForPriceNewViewController*vc = [[AskForPriceNewViewController alloc]init];
    [ClueIdObject setClueId:xunjia_118];
   
    if (self.chexingId) {
        vc.carTypeId = self.chexingId;
        vc.carTypeName = self.carTypeName;
    }else{
         vc.carSerieasId = self.catTypeId;
        
    }
    
    

    [self.rt_navigationController pushViewController:vc animated:YES];
}
-(void)topclick:(UIButton *)click{
    if( self.popUpView.isHidden){
        self.jiantouImageView.image = [UIImage imageNamed:@"箭头向上"];
        [self.popUpView showPopUpView];
    }else{
        self.jiantouImageView.image = [UIImage imageNamed:@"箭头向下"];
        [self.popUpView dismissPopUpView];
    }
}

//滑动 ScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating&&self.currentpage != current){
            self.currentpage  = current;
            [self.selectionList setSelectedButtonIndex:current];
            [self selectionList:self.selectionList didSelectButtonWithIndex:current];

            NSLog(@"正常切换");
        }
        return;
    }
   
//    CGFloat placeHolderHeight = VIEWHEAD - PLACEHOLDER;
//
//    if (scrollView == self.topParentTableView) {
//        NSLog(@"滑动了几次");
//        CGFloat offsetY = scrollView.contentOffset.y;
//
//        if (offsetY>=0 && offsetY < placeHolderHeight) {
//            [self.topParentTableView.tableFooterView setUserInteractionEnabled:NO];
//        }else if(offsetY > placeHolderHeight){
//            [self.topParentTableView.tableFooterView setUserInteractionEnabled:YES];
//            PublicPraiseTableView *view  = self.tabelViewList[self.currentpage];
//            view.scrollEnabled = YES;
//            [self.topParentTableView setContentOffset:CGPointMake(0, placeHolderHeight) animated:NO];
//        }else{
//
//        }
//    }else{
//        if (scrollView.contentOffset.y<=0) {
//            [self.topParentTableView.tableFooterView setUserInteractionEnabled:NO];
//            [self.topParentTableView setContentOffset:CGPointMake(0,100 + (arc4random() % 101)) animated:YES];
//        }
//    }
//
}

//添加头部的信息
-(KouBeiCarsModel *)addTopCar{
    KouBeiCarsModel *car = [[KouBeiCarsModel alloc] init];
    car.car_id = self.catTypeId;
    car.car_name= self.carSeriesName;
    car.koubei_num = @"";
    return car;
}
-(UIView*)askForPriceContentView{
    if (!_askForPriceContentView) {
        _askForPriceContentView = [[UIView alloc]init];
        _askForPriceContentView.backgroundColor = BlackColorF8F8F8;
        LineView*line = [[LineView alloc]init];
        [_askForPriceContentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_askForPriceContentView);
            make.height.mas_equalTo(lineHeight);
        }];
        UIButton*askForPriceButton = [Tool createButtonWithTitle:@"询底价" titleColor:[UIColor whiteColor] target:self action:@selector(askForPriceClicked:) backgroundImage:[UIImage imageNamed:@"buttonBlueNormal.png"] highLightedBackgroundImage:[UIImage imageNamed:@"buttonBlueSelected.png"]];
        askForPriceButton.layer.cornerRadius = 3;
        askForPriceButton.layer.masksToBounds = YES;
        [_askForPriceContentView addSubview:askForPriceButton];
        [askForPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_askForPriceContentView).with.offset(10);
            make.right.equalTo(_askForPriceContentView).with.offset(-10);
            make.height.mas_equalTo(44);
            make.top.equalTo(_askForPriceContentView).with.offset(10);
            make.bottom.equalTo(_askForPriceContentView).with.offset(-10);

        }];
        
    }
    return _askForPriceContentView;
}
//改变数据结构
-(void)changeCarsList{
     self.cars = [[self.cars reverseObjectEnumerator] allObjects];
    [self.cars addObject:[self addTopCar]];
    self.cars = [[self.cars reverseObjectEnumerator] allObjects];
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
