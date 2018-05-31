//
//  HomeViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/2/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "HomeViewController.h"
#import "HTHorizontalSelectionList.h"
#import "Utils.h"
#import "HomeMenuModel.h"
#import "HomeMenuViewModel.h"
#import "HomeChildUICollectionView.h"
#import "Location.h"
#import "CustomAlertView.h"
#import "CityViewController.h"
#import "DialogView.h"
#import "TabBarViewController.h"
#import "UIScrollView+ScrollToTopView.h"
#import "HeadTopView.h"
#import "CompareViewController.h"
#import "PYSearchViewController.h"

#import "CustomNavigationController.h"
#import "JustOnceClickTool.h"



@interface HomeViewController ()<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource,UIScrollViewDelegate,HomeChildUICollectionViewDelegate>
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
//item的数值
@property(nonatomic,strong)NSMutableArray<MenuModel*> *itemDataArray;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *scrollContentView;


//banner
@property(nonatomic,strong)UICollectionView* currentcollectionView;
//collectionview array
@property(nonatomic,strong)NSMutableArray*collectionListArray;
//当前页面
@property(nonatomic,assign)NSInteger currentpage;
@property(nonatomic,assign)BOOL searchBarShow;
//数据
@property(nonatomic,strong)HomeMenuViewModel *homeMenuViewModel;
///头部布局
@property(nonatomic,strong)HeadTopView *headTopView;
@property(nonatomic,strong)UIView *topBackground;
@property(nonatomic,copy)NSString *locationErrorString;

///第一次打开不需要刷新头部
@property(nonatomic,assign)bool isFristOpen;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBarShow = YES;
    self.isFristOpen = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor  = [UIColor whiteColor];
    [self initData];
  
    @weakify(self);
    
    
    [RACObserve(((TabBarViewController*)self.tabBarController), oldViewContoller)subscribeNext:^(id x) {
        @strongify(self);
        if (((TabBarViewController*)self.tabBarController).oldViewContoller == self.rt_navigationController&&self.rt_navigationController==self.tabBarController.selectedViewController&&!self.isFristOpen) {
            [[self currentcollectionView].mj_header beginRefreshing];
        }
        self.isFristOpen =NO;

    }];
    [[RACSignal combineLatest:@[RACObserve(self, adFinished),RACObserve(self, guideFinished),RACObserve(self, locationFinished)] reduce:^(NSNumber*adFinished,NSNumber*guideFinished,NSNumber*locationFinished){
        return @([adFinished boolValue]&&[guideFinished boolValue]&&[locationFinished boolValue]);
    }]subscribeNext:^(NSNumber* x) {
        if ([x boolValue]) {
            
            if (self.locationErrorString.isNotEmpty) {
                if ([self.locationErrorString isEqual: @"检测地理位置信息失败，\n请到权限管理中进行修改!"]) {
                    [[CustomAlertView alertView]showWithTitle:nil message:self.locationErrorString cancelButtonTitle:@"取消" confirmButtonTitle:@"前往修改" cancel:^{
                        
                    } confirm:^{
                        [[Location shareInstance] editPermission];
                    }];
                    
                    
                }else if (self.locationErrorString){
                    [[DialogView sharedInstance]showDlg:self.view textOnly:self.locationErrorString delayTime:3];
                }
  
            }
        }else{
            [self showCityAlert];
        }
    }];
    
    ///
    ///1.用户第一次打开，不需要提示，直接定位，换定位位置，如果没有打开定位，就改成全国
    ///2.定位与当前城市不符合，提示不符合是否切换，如果点击取消，则下次遇到这个城市便不再提示切换
    ///
    
   [[Location shareInstance]startLocationNeedCityIDSuccess:^(CLLocationCoordinate2D coordinate, NSString *cityName, NSString *address) {
      
       self.locationFinished = YES;
       
             } failed:^(NSString *errorMessage) {
                 
                 if (!errorMessage) {
                     self.locationErrorString =@"检测地理位置信息失败，\n请到权限管理中进行修改!";
                 }else{
                       self.locationErrorString = errorMessage;
                 }
               self.locationFinished = YES;
                 
       } loactionPermissionErrorAlertShow:NO];
    
          // Do any additional setup after loading the view.
}

-(UIView *)topBackground{
     if (!_topBackground) {
         _topBackground = [[UIView alloc] initWithFrame:CGRectZero];
         [_topBackground setBackgroundColor:BlueColor447FF5];
         [self.view addSubview:_topBackground];
         
         [_topBackground mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.view.mas_top).offset(-1);
             make.width.mas_equalTo(kwidth);
               make.bottom.equalTo(self.selectionList.mas_bottom);
         }];
     }
    return _topBackground;
}
-(HeadTopView*)headTopView{
    if (!_headTopView) {
        _headTopView = [[HeadTopView alloc] initWithFrame:CGRectZero];
        [_headTopView setBackgroundColor:BlackColorF1F1F1];
        [self.view insertSubview:_headTopView belowSubview:self.selectionList];;
        [_headTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectionList.mas_bottom);
            make.width.mas_equalTo(kwidth);
            make.height.mas_equalTo(44);
        }];
       
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionDo:)];
        
        [_headTopView.infoView setUserInteractionEnabled:YES];
        [_headTopView.infoView addGestureRecognizer:tapGesture];
    
    }
    return _headTopView;


}

// 3. 在此方法中设置点击label后要触发的操作
-(void)actionDo:(UITapGestureRecognizer *) gesture {
    
//    CompareViewController*vc = [[CompareViewController alloc]init];

           ///搜索跳转
        NSLog(@"汽车");
        // 1.创建热门搜索
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // 开始搜索执行以下代码
            // 如：跳转到指定控制器
            //        [searchViewController.rt_navigationController pushViewController:[[PYTempViewController alloc] init] animated:YES];
        }] ;

        searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag; // 热门搜索风格根据选择
  searchViewController.searchHistoryStyle = PYSearchHistoryStyleBorderTag; // 搜索历史风格为default
    [searchViewController.searchBar becomeFirstResponder];
        searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    searchViewController.searchBarBackgroundColor = BlackColorF1F1F1;
    

        // 5. 跳转到搜索控制器
   
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:searchViewController];
    
//    
////    UIModalPresentationFullScreen = 0,
////    UIModalPresentationPageSheet NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
////    UIModalPresentationFormSheet NS_ENUM_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED,
////    UIModalPresentationCurrentContext NS_ENUM_AVAILABLE_IOS(3_2),
////    UIModalPresentationCustom NS_ENUM_AVAILABLE_IOS(7_0),
////    UIModalPresentationOverFullScreen NS_ENUM_AVAILABLE_IOS(8_0),
////    UIModalPresentationOverCurrentContext NS_ENUM_AVAILABLE_IOS(8_0),
////    UIModalPresentationPopover NS_ENUM_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED,
////    UIModalPresentationNone NS_ENUM_AVAILABLE_IOS(7_0) = -1,
//    
//    
//    nav.modalTransitionStyle = UIModalPresentationOverFullScreen;
    
        [self presentViewController:nav animated:YES completion:^{
            

        }];
//    self.navigationItem.hidesBackButton=YES;
    NSLog(@"%ld",self.rt_navigationController.rt_viewControllers.count);
}

-(void)goToCity{
    CityViewController*vc = [[CityViewController alloc]init];
    [self.rt_navigationController pushViewController:vc animated:YES];
}

-(UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    
        [self.view addSubview:_scrollView];
//        [self.view insertSubview:self.headTopView belowSubview:self.selectionList];
//        [self.view insertSubview:_scrollView belowSubview:self.headTopView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.topBackground.mas_bottom);
        }];
    }
    return _scrollView;
}
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.itemDataArray.count;
}
-(NSString*)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    MenuModel*model = self.itemDataArray[index];
    return model.typename;
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    
    //视频红色提示
    if (index == 1) {
        [JustOnceClickTool setRightClickTimes:NO];
        if ([selectionList.redUiView isNotEmpty]) {
              [selectionList.redUiView removeFromSuperview];
        }
    }
    
    self.currentpage = index;
    [self tongJiEvents:index];
    [self jump2CollectionView:self.currentpage];
}
-(UICollectionView*)currentcollectionView{
    return self.collectionListArray[self.currentpage];
}
///跳转到对应的colletionview
-(void)jump2CollectionView:(NSInteger)count{
    
    HomeChildUICollectionView* currentcollectionView = self.collectionListArray[count];
    
    [self.scrollView setContentOffset:currentcollectionView.frame.origin animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating&&self.currentpage!=current){
            self.currentpage = current;
            
//            if (self.currentpage==0) {
//                [self searchBarShow:YES];
//            }else{
//                [self searchBarShow:NO];
//            }
//
//            NSLog(@"正常切换");
            [self.selectionList setSelectedButtonIndex:self.currentpage];
            [self jump2CollectionView:self.currentpage];
//            //为首页的时候才展示，其余都隐藏
//            if (self.currentpage == 0 ) {
//                [self searchBarShow:NO];
//            }else{
//                [self searchBarShow:YES];
//            }
        }
    }
    
}
-(HTHorizontalSelectionList*)selectionList{
    if (!_selectionList) {
        _selectionList = [[HTHorizontalSelectionList alloc]init];
       
        _selectionList.showRightMaskView = YES;
        [_selectionList.searchImageView setHighlighted:NO];
        
        _selectionList.buttonInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _selectionList.leftSpace = 0;
        _selectionList.rightSpace = 10;
        _selectionList.titleFont = FontOfSize(16);
  
        [_selectionList setTitleColor:BlackColor999999 forState:UIControlStateNormal];

        _selectionList.selectionIndicatorColor = BlackColor333333;
        _selectionList.dataSource = self;
         _selectionList.delegate = self;
       
         [self.view addSubview:self.selectionList];
        //加入seclection
        
        [_selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.left.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(StatusHeight);
            make.height.mas_equalTo(44);
            
        }];
        
//        _selectionList.backgroundColor = [UIColor colorWithString:@"0xF8F8F8F"];
        _selectionList.backgroundColor = [UIColor whiteColor];
        
        [_selectionList.searchImageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionDo:)];
        [_selectionList.searchView addGestureRecognizer:tapGesture];
         [_selectionList.searchImageView addGestureRecognizer:tapGesture];
        
        if ([JustOnceClickTool geRightClickTimes]) {
            _selectionList.isShowColorRight = YES;
            _selectionList.isShowColorRightCount = 1;
        }
    
    }
    return _selectionList;
}


-(HomeMenuViewModel*)homeMenuViewModel{
    if (!_homeMenuViewModel) {
        _homeMenuViewModel = [HomeMenuViewModel SceneModel];
    }
    return _homeMenuViewModel;
}
-(void)initData{
    
    self.homeMenuViewModel.request.startRequest = YES;
    self.homeMenuViewModel.launchSreenRequest.startRequest = YES;
    __block BOOL valueChanged = NO;
    @weakify(self);
    [[RACObserve(self.homeMenuViewModel, data)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.homeMenuViewModel.data.isNotEmpty;
      }]subscribeNext:^(id x) {
          @strongify(self);
          valueChanged = NO;
          if (self.itemDataArray.count -1 != self.homeMenuViewModel.data.menu.count) {
              
              [self.itemDataArray removeAllObjects];
              MenuModel*model = [[MenuModel alloc]init];
              model.typename = @"推荐";
              [self.itemDataArray addObject:model];
              
              MenuModel*model1 = [[MenuModel alloc]init];
              model1.typename = @"视频";
              [self.itemDataArray addObject:model1];
              
              [self.itemDataArray addObjectsFromArray:self.homeMenuViewModel.data.menu];
              valueChanged = YES;
              
          }else{
              [self.homeMenuViewModel.data.menu enumerateObjectsUsingBlock:^(MenuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   @strongify(self);
                  MenuModel*model = self.itemDataArray[idx+1];
                  if ([obj.typename isEqualToString:model.typename]&&[obj.id isEqualToString:model.id]&&[obj.catdir isEqualToString:model.catdir]) {
                      
                  }else{
                      valueChanged = YES;
                      [self.itemDataArray replaceObjectAtIndex:idx+1 withObject:obj];
                  }
            }];
          }
          if (valueChanged) {
//              数据记载页面
              NSLog(@" 数据记载页面");
            [self.selectionList reloadData];
            [self initCollectionView];
          }
      }];
    
    

}

//初始化collectonview
-(void)initCollectionView{
    
    if (!self.collectionListArray) {
        self.collectionListArray = [[NSMutableArray alloc]init];
    }
    
    
    if (self.collectionListArray.count > 0) {
//        [self.collectionListArray enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            [obj removeFromSuperview];
//
//        }];
//
//        [self.collectionListArray removeAllObjects];

    }else{
        for (NSInteger i=0; i<self.itemDataArray.count; i++) {
            [self collectonView:i];
            
        }
    }
}

//初始化 CollectionView
-(void)collectonView:(NSInteger ) count{
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    CGRect rx = [UIScreen mainScreen ].bounds;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    MenuModel*model = self.itemDataArray[count];
    BOOL isFirstModel = NO;
    if (count==0) {
        isFirstModel = YES;
    }
    
    BOOL isVideoModel = NO;
    if (count==1) {
        isVideoModel = YES;
    }
    HomeChildUICollectionView *collectionView = [[HomeChildUICollectionView alloc]initWithFrame:CGRectMake(count*rx.size.width,0,kwidth,kheight-self.selectionList.size.height-64-44)                                                                      collectionViewLayout:layout catId:model.id isFirstModel:isFirstModel isVideoModel:isVideoModel];
    [self.scrollContentView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView).with.offset(count*rx.size.width);
        make.top.bottom.equalTo(self.scrollContentView);
        make.width.equalTo(self.view);
        if (count==self.itemDataArray.count-1) {
            make.right.equalTo(self.scrollContentView);
        }

    }];
    //防止block循环使用
   if (count==0) {
        @weakify(self);
        collectionView.block = ^(NSInteger num) {
            [self_weak_ topHeadView:num];
        };
       self.currentpage = 0;
    }
   
    collectionView.scorllViewdelegate = self;
   
    //首页推荐和其他页面的请求数据是不一样的
    //collectionView.scrollToTopViewShow  = NO;
   
    [self.collectionListArray addObject:collectionView];
}

-(NSMutableArray<MenuModel*>*)itemDataArray{
    if (!_itemDataArray) {
        _itemDataArray = [[NSMutableArray<MenuModel*> alloc ]init];
    }
    return _itemDataArray;
}
//统计
-(void)tongJiEvents:(NSInteger) count{
    switch (count) {
        case 0:{
//            [UMSAgent postEvent:home_tuijian label:home_tuijian];
            [MobClick event:home_tuijian];
                  }
            break;
        case 1:
//            [UMSAgent postEvent:home_xinwen label:home_xinwen];
            [MobClick event:home_xinwen];
            break;
        case 2:
//            [UMSAgent postEvent:home_shijia label:home_shijia];
            [MobClick event:home_shijia];
            break;
        case 3:
//            [UMSAgent postEvent:home_daogou label:home_daogou];
            [MobClick event:home_daogou];
            break;
        case 4:
//            [UMSAgent postEvent:home_yongche label:home_yongche];
            [MobClick event:home_yongche];
            break;
        case 5:
//            [UMSAgent postEvent:home_wenhua label:home_wenhua];
            [MobClick event:home_wenhua];
            break;
        case 6:
//            [UMSAgent postEvent:home_gaizhuang label:home_gaizhuang];
            [MobClick event:home_gaizhuang];
            break;
        case 7:
//            [UMSAgent postEvent:home_youji label:home_youji];
            [MobClick event:home_youji];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];

   
   
    if (!self.homeMenuViewModel.data) {
        self.homeMenuViewModel.request.startRequest = YES;
    }else{
        [self.collectionListArray enumerateObjectsUsingBlock:^(HomeChildUICollectionView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [obj viewWillAppear];
        }];
    }
    
//    [self.headTopView.cityButton setTitle:[AreaNewModel shareInstanceSelectedInstance].name forState:UIControlStateNormal];
//    [self.headTopView.cityButton exchangeImageAndTitleWithSpace:4];
    [self.topBackground setHidden:YES];

    
}



- (void)viewWillDisappear:(BOOL)animated {
    
     [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];

    [super viewWillDisappear:animated];
    
    [self.collectionListArray enumerateObjectsUsingBlock:^(HomeChildUICollectionView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj viewWilldisAppear];
    }];
  
}

//隐藏的图片
-(void)topHeadView:(NSInteger) num{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = BlueColorBDD3FF;
  
    [self.view addSubview:label];
    
//    if ([self.headTopView isHidden]) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(29);
            make.width.mas_equalTo(kwidth);
            make.top.equalTo(self.currentcollectionView.mas_top);
        }];
//    }else{
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(29);
//            make.width.mas_equalTo(kwidth);
//            make.top.equalTo(self.headTopView.mas_bottom);
//        }];
//    }
   
    
    
    label.textAlignment = NSTextAlignmentCenter;
    
    if (num>0) {
        label.text =[NSString stringWithFormat:@"为您更新了%ld条新内容" ,(long)num];
    }else{
        label.text = @"暂无新内容";
    }
    
    label.font = FontOfSize(13);
    label.textColor = BlueColor447FF5;
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //执行动画
        label.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:2.0 animations:^{
                label.alpha = 0.0;
            }];
        }
    }];
}

-(void)showCityAlert{
    if (![[Location shareInstance].cityId isEqual:[AreaNewModel shareInstanceSelectedInstance].id]) {
        
        NSString* obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfristopen"];
        //没有定位成功不操作
        if (![[Location shareInstance].city isNotEmpty]) {
            return ;
        }
        
        //第一次打开是为空的
        if (![obj isNotEmpty]) {
            [AreaNewModel shareInstanceSelectedInstance].name = [Location shareInstance].city;
            [AreaNewModel shareInstanceSelectedInstance].id = [Location shareInstance].cityId;
            [[AreaNewModel shareInstanceSelectedInstance] saveToFile];
            [_headTopView.cityButton setTitle:[Location shareInstance].city forState:UIControlStateNormal];
            [_headTopView.cityButton exchangeImageAndTitleWithSpace:4];
            [[NSUserDefaults standardUserDefaults]setObject:@"isfristopen" forKey:[NSString stringWithFormat:@"isfristopen"] ];
            return ;
        }
        else if ([[Location shareInstance].cityId isNotEmpty] && ![[Location shareInstance].cityId isEqual:[Location shareInstance].historyLocationModel.cityId]){
            [[CustomAlertView alertView]showWithTitle:[ NSString stringWithFormat:@"检测到您当前所在的城市是【%@】是否自动切换到【%@】？",[Location shareInstance].city,[Location shareInstance].city] message:nil cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" cancel:^{
                [Location shareInstance].historyLocationModel.cityId = [Location shareInstance].cityId;
                [Location shareInstance].historyLocationModel.city =[Location shareInstance].city;
                [Location shareInstance].historyLocationModel.address = [Location shareInstance].address;
                [Location shareInstance].historyLocationModel.lon = [Location shareInstance].coordinate.longitude;
                [Location shareInstance].historyLocationModel.lat = [Location shareInstance].coordinate.latitude;
                [[Location shareInstance].historyLocationModel updateToUserdefault];
            } confirm:^{
                
                [AreaNewModel shareInstanceSelectedInstance].name = [Location shareInstance].city;
                [AreaNewModel shareInstanceSelectedInstance].id = [Location shareInstance].cityId;
                [[AreaNewModel shareInstanceSelectedInstance] saveToFile];
                [_headTopView.cityButton setTitle:[Location shareInstance].city forState:UIControlStateNormal];
                [_headTopView.cityButton exchangeImageAndTitleWithSpace:4];
            }];
            
            
        }
    }

}

-(void)searchBarShow:(BOOL)show{
    
//    if (show&&self.searchBarShow==NO) {
//       self.searchBarShow = show;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.headTopView.transform = CGAffineTransformMakeTranslation(0, 0);
//           // self.headTopView.alpha = 1;
////            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
////                make.top.equalTo(self.headTopView.mas_bottom);
////            }];
////            [self.scrollView layoutIfNeeded];
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//    }else if(show==NO&&self.searchBarShow==YES){
//        self.searchBarShow = show;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.headTopView.transform = CGAffineTransformMakeTranslation(0, -44);
////            [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
////                make.top.equalTo(self.headTopView.mas_bottom).with.offset(-44);
////            }];
////            [self.scrollView layoutIfNeeded];
//           // self.headTopView.alpha = 0;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//   self.searchBarShow = show;
//    [self.collectionListArray enumerateObjectsUsingBlock:^(HomeChildUICollectionView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj!=self.currentcollectionView) {
//            obj.searchBarShow = show;
//        }
//    }];
}
//-(void)scrollViewScrolledValue:(CGFloat)value{
//    if (value>0) {
//        [UIView animateWithDuration:0.25 // 动画时长
//                         animations:^{
//                             // code...
//                             CGPoint point = self.headTopView.center;
//                             point.y -= 20;
//                             [self.headTopView setCenter:point];
////
////                             CGPoint point = self.headTopView.center;
////                             point.y -= 20;
////                             [self.headTopView setCenter:point];
////
////                             
////                             self.headTopView.infoView.height = 1;
//                             self.headTopView.alpha = 0.1;
//                         }
//                         completion:^(BOOL finished) {
//                             // 动画完成后执行
//                             // code...
//                             [self.headTopView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                 make.height.mas_equalTo(1);
//                             }];
//                             [self.headTopView.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                 make.height.mas_equalTo(1);
//                             }];
//                             self.headTopView.alpha = 1;
//                         }];
//    }else{
//        
//        [UIView animateWithDuration:0.5 // 动画时长
//                         animations:^{
//                             // code...
//                             CGPoint point = self.headTopView.center;
//                             point.y += 20;
//                             [self.headTopView setCenter:point];
//                             self.headTopView.alpha = 0.1;
//                         }
//                         completion:^(BOOL finished) {
//                             // 动画完成后执行
//                             // code...
//                             [self.headTopView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                 make.height.mas_equalTo(45);
//                             }];
//                             
//                             [self.headTopView.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
//                                 make.height.mas_equalTo(29);
//                             }];
//                             self.headTopView.alpha = 1;
//                         }];
//        
//    }
//}
-(UIView*)scrollContentView{
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc]init];
        [self.scrollView addSubview:_scrollContentView];
        [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.centerY.equalTo(self.scrollView);
        }];
    }
    return _scrollContentView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    ///更改首页图标，先放在这
//    UITabBarItem*tabbar = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
//    self.rt_navigationController.tabBarItem = tabbar;
    // Dispose of any resources that can be recreated.
}

-(void)refreshCurrentViewController{
    if (self.currentpage == 0) {
       HomeChildUICollectionView *view =  (HomeChildUICollectionView *)self.currentcollectionView;
        [view reloadCurrentData];
    }
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
