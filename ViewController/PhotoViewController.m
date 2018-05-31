//
//  PhotoViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionView.h"
#import "PhotoSelectCarTypeViewController.h"
#import "PhotoMenuViewModel.h"
#import "PicMenuModel.h"

#import "ColorPickViewController.h"



@interface PhotoViewController ()
@property(nonatomic,strong)PhotoSelectCarAndColorViewModel*carTypeAndColorviewModel;
@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) NSMutableArray<PicMenuModel*> *selectionArray;
@property(nonatomic,strong)PhotoMenuViewModel *model;
@property(nonatomic,strong)PhotoCollectionView *currentConllectionView;

@property (nonatomic, strong)PhotoSelectCarTypeViewController*carTypeVC;

@property (nonatomic, strong) ColorPickViewController *controller;

@property(nonnull,strong)UIScrollView *scrollView;
//collectionview array
@property(nonatomic,strong)NSMutableArray*collectionListArray;

//选择默认的颜色
@property(nonatomic,strong)NSString *default_color;
//默认选中的栏目
@property(nonatomic,strong)PicMenuModel *default_model;
//初始化的图片列表
@property (nonatomic,strong)NSMutableDictionary* forestalllDict;

@property (nonatomic,assign)NSInteger pathCount;

@property(nonatomic,strong)UILabel *allPicsLabel;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forestalllDict =[NSMutableDictionary dictionary];
    
     [self showNavigationTitle:@"图片"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.default_color = @"0";
    
    [self initSelection];
    [self initScrollView];
    //初始化数据
    [self initSelectionList];    
    
    if([self.typeId isNotEmpty]){
        self.carTypeAndColorviewModel = [PhotoSelectCarAndColorViewModel SceneModel];
        self.carTypeAndColorviewModel.request.typeId = self.typeId;
        [self addRightButtonWithTitle:@[@"颜色",@"车型"]];
    }else{
        self.carTypeAndColorviewModel = [PhotoSelectCarAndColorViewModel SceneModel];
        self.carTypeAndColorviewModel.request.carId = self.carId;
        [self addRightButtonWithTitle:@[@"颜色"]];
    }

    
}
-(void)addRightButtonWithTitle:(NSArray*)titleArray{
    NSMutableArray*array = [NSMutableArray array];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton*button = [[UIButton alloc]initNavigationButtonWithTitle:obj color:BlueColor447FF5];
        button.tag = idx;
        [button addTarget:self action:@selector(carTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = nil;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
       
        [array addObject:[[UIBarButtonItem alloc] initWithCustomView:button]];

         }];
    self.navigationItem.rightBarButtonItems =   array;
    
    
}
-(void)carTypeClicked:(UIButton*)button{
    //颜色
    if (button.tag == 0) {
        //颜色的具体入口
       if(self.controller==nil){
       self.controller = [[ColorPickViewController alloc] init];
       }
        
        //选中的颜色值
        self.controller.viewModel = self.carTypeAndColorviewModel;
        @weakify(self);
        self.controller.block =^(CarColorTypeModel*model){
        @strongify(self);
            
        self.default_color = model.color_id;
            [self refreshControllerView];
        [self.currentConllectionView.mj_header beginRefreshing];

        };
        
        //选中的位置
   
        self.controller.index =^(NSIndexPath*IndexPath){
        @strongify(self);
            self.controller.clickIndexPath = IndexPath;
        };
        
        [self.rt_navigationController pushViewController:self.controller animated:YES];
        
        return ;
    }
    if (!self.carTypeVC) {
         self.carTypeVC = [[PhotoSelectCarTypeViewController alloc]init];
    }
   
    self.carTypeVC.viewModel = self.carTypeAndColorviewModel;
     @weakify(self);
    self.carTypeVC.selectedBlock = ^(CarTypeModel*model){
       @strongify(self);
        if (model==nil) {
            
            ///为空，使用typeid
            ///加载最原始的数据
            self.carId = @"";
            [self refreshAllControllerView];
            
        }else{
            //使用carId
            self.carId = model.car_id;
            [self refreshAllControllerView];
           
        }
    };
    [self.rt_navigationController pushViewController:self.carTypeVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初始化 ScrollView
-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled =YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.selectionList.mas_bottom);
    }];
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
    self.selectionList.rightSpace = 5;
    
    self.selectionList.minShowCount= 4;
    self.selectionList.maxShowCount = 5;

    
    //加入seclection
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.view);
    }];
    
    self.selectionList.backgroundColor = BlackColorF8F8F8;
        
    self.selectionList.maxShowCount = 5;
    
}

///初始化collectonview
-(void)initCollectionView{
    self.collectionListArray = [[NSMutableArray alloc]init];
    
    [self.scrollView setContentSize:CGSizeMake(self.selectionArray.count*kwidth, self.scrollView.bounds.size.height)];
    
    for (NSInteger i=0; i< self.selectionArray.count; i++) {
        [self collectonView:i];
        
    }
}

//初始化 CollectionView
-(void)collectonView:(NSInteger ) count{
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    CGRect rx = [UIScreen mainScreen ].bounds;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    PhotoCollectionView *collectionView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(count*rx.size.width,0,kwidth,kheight-self.selectionList.size.height-64-44) collectionViewLayout:layout];
    
      PicMenuModel *model =self.selectionArray[count];
    if(count ==0 ){
        collectionView.labelCurrentNumber = count;
        collectionView.labelCurrentName = model.category_name;
        self.currentConllectionView = collectionView;
    }
   
    collectionView.catgoryId = model.category_id;
    
    collectionView.model.request.categoryId = model.category_id;
  
    collectionView.menu = self.model.data.data;
    collectionView.typeId = self.typeId;
    collectionView.carName = self.carName;
    collectionView.carType = self.carType;
    collectionView.carPrice = self.carPrice;
    collectionView.carId = self.carId;
    collectionView.colorId  = self.default_color;
    collectionView.model.request.carId =self.carId;
    collectionView.model.request.typeId = self.typeId;
    collectionView.model.request.color = self.default_color;
    
    collectionView.block = ^(NSMutableArray<PicModel*> *pic,NSString *catgoryId){
        [self.forestalllDict setObject:pic forKey:catgoryId];
        self.currentConllectionView.forestalllDict = self.forestalllDict;
    };
    
    collectionView.blockNum = ^(NSInteger count) {
        [self.allPicsLabel setHidden:NO];
        self.allPicsLabel.text = [NSString stringWithFormat:@"总共%ld张图片",count];
    };
    
    //只加载第一页数据
    if (0 == count) {
        [collectionView.mj_header beginRefreshing];
    }
    
 
    [self.scrollView addSubview:collectionView];
    
    [self.collectionListArray addObject:collectionView];

}

///初始化首页按钮数据
-(void)initSelectionList{
    self.model = [PhotoMenuViewModel SceneModel];
    self.model.request.carId = self.carId;
    self.model.request.typeId = self.typeId;
    self.model.request.color =self.default_color;
    self.model.request.startRequest = YES;
    [[RACObserve(self.model, data)
     filter:^BOOL(id value) {
         return self.model.data.isNotEmpty;
     }]subscribeNext:^(id x) {
 
         if (x && self.pathCount != self.model.data.data.count) {
             
             self.selectionArray  = [[NSMutableArray alloc]init];
             [self.selectionArray addObjectsFromArray:self.model.data.data];
             
             self.pathCount = self.selectionArray.count;
             
             if (self.selectionArray.count>0) {
                 self.default_model = self.model.data.data[0];
                 
                 [self initCollectionView];
                 [self.selectionList reloadData];
             }else{
                 //无数据展示
                 [self.selectionList setHidden:YES];
             }
         }
     }];
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    PicMenuModel *model =self.selectionArray[index];
    return model.category_name;
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.selectionArray.count;
}

-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
   
    PhotoCollectionView *view  = self.collectionListArray[index];
    self.currentConllectionView = view;
    self.currentConllectionView.labelCurrentNumber = index;
    self.currentConllectionView.forestalllDict = self.forestalllDict;
    self.currentConllectionView.labelCurrentName = self.selectionArray[index].category_name;
    [self.currentConllectionView changeView];
    [self.scrollView setContentOffset:self.currentConllectionView.frame.origin animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        PhotoCollectionView *view  = self.collectionListArray[current];
        self.currentConllectionView = view;
        
        self.currentConllectionView.labelCurrentNumber = current;
        self.currentConllectionView.forestalllDict = self.forestalllDict;
        self.currentConllectionView.labelCurrentName = self.selectionArray[current].category_name;
        [self.currentConllectionView changeView];
        [self.selectionList setSelectedButtonIndex:current];
    }
    
}

//根据颜色的值切换所有的view的值
-(void)refreshControllerView{
    
   
          for (PhotoCollectionView *view in self.collectionListArray) {
              view.model.request.color = self.default_color;
              //初始化页面数据
              view.carId =  self.carId;
              view.page = 1;
              view.menu = self.model.data.data;
              view.colorId = self.default_color;
              if (view==self.currentConllectionView) {
                  [view.mj_header beginRefreshing];
              }else{
                  view.model.request.startRequest = YES;
              }
              
              view.block = ^(NSMutableArray<PicModel*> *pic,NSString *catgoryId){
                  [self.forestalllDict setObject:pic forKey:catgoryId];
                  self.currentConllectionView.forestalllDict = self.forestalllDict;
              };
          }
    
}

//根据车型切换所有的view的值
-(void)refreshAllControllerView{
          
          for (PhotoCollectionView *view in self.collectionListArray) {
              view.model.request.color = self.default_color;
              //初始化页面数据
              view.carId =  self.carId;
              view.page = 1;
              view.menu = self.model.data.data;
              view.colorId = self.default_color;
             
              if (view==self.currentConllectionView) {
                  [view.mj_header beginRefreshing];
              }else{
                  view.model.request.startRequest = YES;
              }
              view.block = ^(NSMutableArray<PicModel*> *pic,NSString *catgoryId){
                  [self.forestalllDict setObject:pic forKey:catgoryId];
                  self.currentConllectionView.forestalllDict = self.forestalllDict;
              };
          }
    
   }


//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}


//-(UILabel *)allPicsLabel{
//    if (!_allPicsLabel) {
//        _allPicsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.view addSubview:_allPicsLabel];
//        
//        [_allPicsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.left.bottom.equalTo(self.view);
//            make.height.mas_equalTo(30);
//        }];
//        
//        _allPicsLabel.textColor = BlackColor333333;
//        _allPicsLabel.textAlignment = NSTextAlignmentCenter;
//        [_allPicsLabel setBackgroundColor:[UIColor redColor]];
//        
//    }
//    return _allPicsLabel;
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
