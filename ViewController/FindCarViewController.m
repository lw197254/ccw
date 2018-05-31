//
//  FindCarViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/23.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FindCarViewController.h"
#import "HTHorizontalSelectionList.h"
#import "HotBrandTableViewCell.h"
#import "BrandTableViewCell.h"

//#import "CustomTableViewHeaderSectionView.h"

#import "ConditionSelectedCarViewController.h"
#import "CarSeriesViewController.h"
//#import "FindCarHeaderView.h"
#import "FindCarHeaderWithButton.h"
#import "FindCarViewModel.h"
#import "UITableView+CustomTableViewIndexView.h"
#import "NewCarForSaleViewController.h"
#import "DealerViewController.h"
#import "FindCarByGroupViewController.h"
#import "CollectionViewController.h"
#import "BrowseViewController.h"
#import "CompareListViewController.h"
#import "CustomTableViewHeaderSectionView.h"
#import "CustomNavigationController.h"
#import "PYSearchViewController.h"
#import "UIViewController+HalfLeftSlider.h"
#import "DivideHeaderView.h"
#import "RankinglistControllerViewController.h"
#import "ReducePriceListViewController.h"

@interface FindCarViewController ()<UITableViewDelegate,UITableViewDataSource,DivideHeaderViewDataSourceDelegate,DivideHeaderViewDelegate,FindCarHeaderWithButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UILabel *carSeariesNumberLabel;
@property (weak, nonatomic) IBOutlet DivideHeaderView *headerView;


@property(nonatomic,strong)NSArray*bannerArray;
@property(nonatomic,strong)NSArray*titleArray;
@property(nonatomic,strong)FindCarViewModel*viewModel;
@property(nonatomic,strong)FindCarBrandListModel*model;
@property(nonatomic,strong)CarSeriesViewController*carSeriesVC;
@property (weak, nonatomic) IBOutlet UIView *seperateLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLineHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *conditionSelectedCarContentView;

@property (weak, nonatomic) IBOutlet UIView *hotBrandContentView;

//@property(nonatomic,strong)NSArray*conditionSelectedCarPriceArray;
//@property(nonatomic,strong)NSArray*conditionSelectedCarTypeArray;
@property(nonatomic,strong)NSArray*hotBrandArray;

//#define hotBrandSection 0

@end


@implementation FindCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seperateLineView.backgroundColor = BlackColorE3E3E3;
    self.seperateLineHeightConstraint.constant = lineHeight;
    [self showNavigationTitle:@"选车"];
    [self showBarButton:NAV_RIGHT imageName:@"搜索大"];
    [self configBannerData];
   
    
    
    [self configUI];
    self.viewModel = [FindCarViewModel SceneModel];
   
    self.model = self.viewModel.model;

    @weakify(self);
    self.tableView.mj_header  = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
         @strongify(self);
        self.viewModel.brandListRequest.startRequest = YES;
       
    }];
    if (!self.model.isNotEmpty) {
        [self.tableView.mj_header beginRefreshing];
        
    }else{
        
    
        self.viewModel.refreshImmediately = YES;
        self.viewModel.brandListRequest.startRequest = YES;
        [self handleModel];

    }
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.refreshImmediately = YES;
        self.model = self.viewModel.model;
        
        [self.model reChangeLevel];
        
        NSInteger itemCount=   self.model.condtionList.count/4 + (self.model.condtionList.count%4==0?0:1);
        UIView*view = self.tableView.tableHeaderView;
        if (itemCount > 0) {
            
             view.frame = CGRectMake(0, 0, kwidth, 380-85+ itemCount*20+(itemCount-1)*17+15+19);
        }else{
            
              view.frame = CGRectMake(0, 0, kwidth, 380-85);
        }
        
        self.tableView.tableHeaderView = view;
        [self handleModel];
    }];
    [[RACObserve(self.viewModel.brandListRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.brandListRequest.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        self.model = nil;
        [self.tableView reloadData];
        [self.tableView reloadViewWithArray:nil select:nil];
        [self.tableView showNetLost];
    }];
    
      //[self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)configUI{
    self.headerView.delegate = self;
    self.headerView.dataDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerClass:[HotBrandTableViewCell class] forCellReuseIdentifier:classNameFromClass(HotBrandTableViewCell)];
    [self.tableView registerNib:nibFromClass(BrandTableViewCell) forCellReuseIdentifier:classNameFromClass(BrandTableViewCell)];
    self.tableView.customIndexViewTextColor = BlueColor447FF5;
    [self.tableView reloadViewWithArray:self.model.sectionIndexTitleArray select:^(NSString *title, NSInteger index) {
        if (index ==0) {
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            
        }else{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }];
    self.tableView.customIndexView.hidden = YES;
    
    [self.headerView reloadData];
}
///头部banner配置数据
-(void)configBannerData{
  
  self.bannerArray = @[@{@"title":@"新车上市",@"image":@"新车上市_n",@"imageclick":@"新车上市_p"},
                       @{@"title":@"优惠降价",@"image":@"降价_n",@"imageclick":@"降价_p"},
                       @{@"title":@"附近经销商",@"image":@"附近经销商_n",@"imageclick":@"附近经销商_p"},
                       @{@"title":@"热销排行",@"image":@"销售排行_n",@"imageclick":@"销售排行_p"}];
    
}
///获取数据后重新加载tableview
-(void)handleModel{
//    self.carSeariesNumberLabel.text =[NSString stringWithFormat:@"%ld",(long) self.viewModel.model.carSeriesNumber];
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView dismissWithOutDataView];
    [self.tableView reloadViewWithArray:self.model.sectionIndexTitleArray select:^(NSString *title, NSInteger index) {
        if (index ==0) {
            [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            
        }else{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }];
    [self configConditionSelectCarContentView];
    [self configHotBrandContentView];

//    self.tableView.customIndexView.hidden  = YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger number = self.model.sectionHeaderTitleArray.count;
    return number;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FindCarBrandSectionListModel*model = self.model.list[section];
//    if (section==hotBrandSection) {
//        return model.array.count/itemCountInRow + (model.array.count%itemCountInRow==0?0:1);
//    }
    
    return model.array.count;
}

-(NSInteger)numOfViews{
    return self.bannerArray.count;
}


-(UIView *)buildViewbuildViewForItemWithIndex:(NSInteger)i{
    FindCarHeaderWithButton *cell = [[FindCarHeaderWithButton alloc] init];
    cell.delegate = self;
    NSDictionary*dict = self.bannerArray[i];
    [cell buildSingleView:dict position:i];
    return cell;
}


-(void)handleButtonClick:(NSInteger)position{
    
        [self tongJiEvents:position];
    
        switch (position) {
            case 0:{
                NewCarForSaleViewController*vc = [[NewCarForSaleViewController alloc]init];
                [self.rt_navigationController pushViewController:vc animated:YES];
            }
    
                break;
            case 1:{
                ReducePriceListViewController*vc = [[ReducePriceListViewController alloc]init];
                [self.rt_navigationController pushViewController:vc animated:YES];
//                FindCarByGroupViewController*favourite = [[FindCarByGroupViewController alloc]init];
//                [self.rt_navigationController pushViewController:favourite animated:YES];
            }
    
                break;
            case 2:{
                DealerViewController*favourite = [[DealerViewController alloc]init];
                [self.rt_navigationController pushViewController:favourite animated:YES];
            }
    
                break;
            case 3:{
                RankinglistControllerViewController*favourite = [[RankinglistControllerViewController alloc]init];
                [self.rt_navigationController pushViewController:favourite animated:YES];
                
//                if (![[UserModel shareInstance].uid isNotEmpty]) {
//                    LoginViewController *controller = [[LoginViewController alloc] init];
//                    [URLNavigation pushViewController:controller animated:YES];
//    
//                    controller.loginSuccessBlock = ^{
//    
//                        CollectionViewController *controller = [[CollectionViewController alloc] init];
//                        [URLNavigation pushViewController:controller animated:YES];
//                    };
//                    return ;
//                }
//    
//                ///我的收藏
//                CollectionViewController*favourite = [[CollectionViewController alloc]init];
//                [self.rt_navigationController pushViewController:favourite animated:YES];
            }
    
                break;
            case 4:{
                //浏览记录
                BrowseViewController*favourite = [[BrowseViewController alloc]init];
                [self.rt_navigationController pushViewController:favourite animated:YES];
            }
                
                break;
                
            default:
                break;
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//     if (indexPath.section == hotBrandSection) {
//         return UITableViewAutomaticDimension;
//     }else{
         return 60;
//     }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CustomTableViewHeaderSectionView*view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
//    [view setTitle:@"条件选车" subTitle:@"共11个" section:section SelectedBlock:^(NSInteger section) {
//        if (section==0) {
//            ConditionSelectCarViewController*condition = [[ConditionSelectCarViewController alloc]init];
//            [self.rt_navigationController pushViewController:condition animated:YES];
//        }
//    }];
//    return view;
//                                                                                                                       
//}
//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.font = FontOfSize14;
//    header.textLabel.textColor = BlackColor333333;
//}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.viewModel.model.sectionHeaderTitleArray[section];
//}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    if (section==hotBrandSection) {
//        header.textLabel.font = FontBlackOfSize(15);
//         header.textLabel.textColor = BlackColor333333;
//        header.contentView.backgroundColor = [UIColor whiteColor];
//    }else{
        header.textLabel.font = FontOfSize(14);
        header.textLabel.textColor = BlackColor666666;
        header.contentView.backgroundColor = BlackColorF1F1F1;
//    }
   
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.model.sectionHeaderTitleArray[section];
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CustomTableViewHeaderSectionView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    if (!view) {
//        view = [[CustomTableViewHeaderSectionView alloc]initWithReuseIdentifier:@"header"];
//        view.topLine.hidden = YES;
//        view.middleLine.hidden = YES;
//        view.bottomLine.hidden = YES;
//       
//        view.titleLabel.font = FontOfSize14;
//        view.titleLabel.textColor = BlackColor333333;
//    }
//    NSString*title = self.viewModel.model.sectionHeaderTitleArray[section];
//    [view setTitle:title subTitle:nil section:section SelectedBlock:nil];
//    return view;
//    
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == hotBrandSection) {
//        
//        HotBrandTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(HotBrandTableViewCell) forIndexPath:indexPath];
//        [cell.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.equalTo(cell.contentView);
//            make.right.equalTo(cell.contentView).with.offset(-10);
//        }];
//       //        cell.userInteractionEnabled = NO;
//        FindCarBrandSectionListModel*model = self.viewModel.model.list[indexPath.section];
//        NSInteger i = indexPath.row*itemCountInRow;
//        NSInteger j = (indexPath.row+1)*itemCountInRow;
//        NSMutableArray<BrandModel*>*array = [NSMutableArray<BrandModel*> array];
//        for (NSInteger m = i ; m < j; m++) {
//            BrandModel*model1 = model.array[m];
//            [array addObject:model1];
//        }
//        
//        [cell.view setCellWithArray:array itemClickBlock:^(HotBrandItem *item, NSInteger index) {
//          
//            BrandModel*model = array[index];
//            
//            if (self.carSeriesVC) {
//                
//                self.carSeriesVC.brandModel = model;
//                 [self resetHalfLeftSliderViewController:self.carSeriesVC edgeInsets:UIEdgeInsetsMake(0, 62, -48, 0)];
//                [self.carSeriesVC refreshViewController];
//            }else{
//                self.carSeriesVC= [[CarSeriesViewController alloc]init];
//
//                self.carSeriesVC.brandModel = model;
//               
//                [self addHalfLeftSliderViewController:self.carSeriesVC viewEdgeInsets:UIEdgeInsetsMake(0, 62, -48, 0) removeBlock:^{
//                   
//                }] ;
//            }
//
//        }];
//        return cell;
//    }else{
        BrandTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:classNameFromClass(BrandTableViewCell) forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 15+15+35, 0, 0);
        FindCarBrandSectionListModel*sectionModel = self.model.list[indexPath.section];
       
        BrandModel*model = sectionModel.array[indexPath.row];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"默认汽车品牌"]];
        cell.titleLabel.text =model.name;
        return cell;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section==hotBrandSection) {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
////        CompareListViewController*VC = [[CompareListViewController alloc]init];
////        [self.rt_navigationController pushViewController:VC animated:YES];
//        return;
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
    
    FindCarBrandSectionListModel*sectionModel = self.model.list[indexPath.section];
    BrandModel*model = sectionModel.array[indexPath.row];
   

    if (!self.carSeriesVC) {
         self.carSeriesVC= [[CarSeriesViewController alloc]init];
    }
    self.carSeriesVC.brandModel = model;
    if (self.carSeriesVC.parentViewController) {
        [self resetHalfLeftSliderViewController:self.carSeriesVC edgeInsets:UIEdgeInsetsMake(0, 62, -48, 0)];
        [self.carSeriesVC refreshViewController];
    }else{
        
        [self addHalfLeftSliderViewController:self.carSeriesVC viewEdgeInsets:UIEdgeInsetsMake(0, 62, -48, 0) removeBlock:^{
           
        }] ;
    }

    
    
   
//    [self.rt_navigationController pushViewController:vc animated:YES];
}
#pragma mark 条件选车点击
- (IBAction)conditionSelectCarTouchDown:(id)sender {
    [MobClick event:car_tiaojian];
//    [UMSAgent postEvent:car_tiaojian label:car_tiaojian];
    ConditionSelectedCarViewController*condition = [[ConditionSelectedCarViewController alloc]init];
    [self.rt_navigationController pushViewController:condition animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//统计
-(void)tongJiEvents:(NSInteger) count{
    switch (count) {
        case 0:
//            [UMSAgent postEvent:car_xinche label:car_xinche];
            [MobClick event:car_xinche];
            break;
        case 1:
//            [UMSAgent postEvent:car_renqun label:car_renqun];
            [MobClick event:car_renqun];
            break;
        case 2:
//            [UMSAgent postEvent:car_jxs label:car_jxs];
            [MobClick event:car_jxs];
            break;
        case 3:
//            [UMSAgent postEvent:car_shouchang label:car_shouchang];
            [MobClick event:car_paihangbang];
            break;
        case 4:
//            [UMSAgent postEvent:car_liulanjilu label:car_liulanjilu];
            [MobClick event:car_liulanjilu];
            break;
        default:
            break;
    }
}
///搜索
-(void)rightButtonTouch{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        //        [searchViewController.rt_navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
    }] ;
    
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag; // 热门搜索风格根据选择
   
    [searchViewController.searchBar becomeFirstResponder];
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    searchViewController.searchBarBackgroundColor = BlackColorF1F1F1;
    
    //        // 4. 设置代理
    //        searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:searchViewController];
    [[Tool currentViewController]presentViewController:nav animated:YES completion:^{
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag; // 搜索历史风格为default
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillAppear:animated];
//    [self.rt_navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y >= self.headerView.height){
        self.tableView.customIndexView.hidden = NO;
    }else{
        self.tableView.customIndexView.hidden = YES;
    }
    if (self.carSeriesVC) {
        
        [self.carSeriesVC removeHalfLeftSliderFromParentViewControllerWithAnimated:YES];
        
        
    }
}

-(void)configConditionSelectCarContentView{
    if (self.conditionSelectedCarContentView.subviews.count > 0) {
        
        [self.conditionSelectedCarContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    NSMutableArray*condionPriceButtonArray = [NSMutableArray array];
    [self.model.condtionList  enumerateObjectsUsingBlock:^(FindCarCondtionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton*button = [Tool createButtonWithTitle:obj.value titleColor:BlackColor333333 target:self action:@selector(conditionSelectCarButtonClicked:)];
        button.titleLabel.font = FontOfSize(14);
        button.tag = idx;
        [self.conditionSelectedCarContentView addSubview:button];
        
        if (idx < 4) {
            [condionPriceButtonArray addObject:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.conditionSelectedCarContentView).with.offset(15);
            }];
        }else{
          UIButton*topButton=  self.conditionSelectedCarContentView.subviews[idx%4];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topButton.mas_bottom).with.offset(17);
                make.left.equalTo(topButton);
            }];
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
          
        }];

        if ((self.model.condtionList.count-1)/4 *4 <idx ) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.bottom.equalTo(self.conditionSelectedCarContentView).with.offset(-19);
                
            }];
 
        }
       
       
        
    }];
    [self.conditionSelectedCarContentView distributeSpacingHorizontallySpaceEqualWith:condionPriceButtonArray withLeftSpaceBaifenbi:5.0/8];
    
    
    
}
-(void)configHotBrandContentView{
    
    if (self.hotBrandContentView .subviews.count > 0) {
        for (UIView*view in self.hotBrandContentView.subviews) {
            [view removeFromSuperview];
        }
    }
    HotBrandView*view1 = [[HotBrandView alloc]init];
    [self.hotBrandContentView addSubview:view1];
   
  
    NSMutableArray<BrandModel*>*array1 = [NSMutableArray<BrandModel*> array];
   
    for (NSInteger i = 0 ; i < itemCountInRow&&i <self.model.hotBrandList.count; i++) {
        BrandModel*model = self.model.hotBrandList[i];
        [array1 addObject:model];
    }
    
    [view1 setCellWithArray:array1 itemClickBlock:^(HotBrandItem *item, NSInteger index) {
        
        BrandModel*model = array1[index];
        
        if (!self.carSeriesVC) {
            self.carSeriesVC= [[CarSeriesViewController alloc]init];
        }
        self.carSeriesVC.brandModel = model;
        if (self.carSeriesVC.parentViewController) {
            [self resetHalfLeftSliderViewController:self.carSeriesVC edgeInsets:UIEdgeInsetsMake(0, 62, -48, 0)];
            [self.carSeriesVC refreshViewController];
        }else{
            
            [self addHalfLeftSliderViewController:self.carSeriesVC viewEdgeInsets:UIEdgeInsetsMake(0, 62, -48, 0) removeBlock:^{
                
            }] ;
        }
        
    }];

    HotBrandView*view2 = [[HotBrandView alloc]init];
    [self.hotBrandContentView addSubview:view2];
    
    
    NSMutableArray<BrandModel*>*array2 = [NSMutableArray<BrandModel*> array];
    
    for (NSInteger i = itemCountInRow ; i < itemCountInRow*2&&i <self.model.hotBrandList.count; i++) {
        BrandModel*model = self.model.hotBrandList[i];
        [array2 addObject:model];
    }
    
    [view2 setCellWithArray:array2 itemClickBlock:^(HotBrandItem *item, NSInteger index) {
        
        BrandModel*model = array2[index];
        
        if (self.carSeriesVC) {
            
            self.carSeriesVC.brandModel = model;
            [self resetHalfLeftSliderViewController:self.carSeriesVC edgeInsets:UIEdgeInsetsMake(0, 62, -48, 0)];
            [self.carSeriesVC refreshViewController];
        }else{
            self.carSeriesVC= [[CarSeriesViewController alloc]init];
            
            self.carSeriesVC.brandModel = model;
            
            [self addHalfLeftSliderViewController:self.carSeriesVC viewEdgeInsets:UIEdgeInsetsMake(0, 62, -48, 0) removeBlock:^{
                
            }] ;
        }
        
    }];

    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.hotBrandContentView);
        
    }];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.hotBrandContentView);
        make.height.equalTo(view1);
       
    }];
    [self.hotBrandContentView distributeSpacingVerticallyWith:@[view1,view2]];
    
}

-(void)conditionSelectCarButtonClicked:(UIButton*)button{
    ConditionSelectedCarViewController*vc = [[ConditionSelectedCarViewController alloc]init];
    FindCarCondtionModel*mod = self.model.condtionList[button.tag];
    vc.selectedConditionModel = mod;
    [self.rt_navigationController pushViewController:vc animated:YES];
}
//-(NSArray*)conditionSelectedCarTypeArray{
//    if (!_conditionSelectedCarTypeArray) {
//        _conditionSelectedCarTypeArray =@[@"小型车",@"紧凑型",@"中型车",@"SUV"];
//    }
//    return _conditionSelectedCarTypeArray;
//}
//-(NSArray*)conditionSelectedCarPriceArray{
//    if (!_conditionSelectedCarPriceArray) {
//        _conditionSelectedCarPriceArray = @[@"0-5万",@"5-10万",@"10-15万",@"15-20万"];
//    }
//    return _conditionSelectedCarPriceArray;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
