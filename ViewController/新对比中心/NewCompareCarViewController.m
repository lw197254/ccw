//
//  NewCompareCarViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NewCompareCarViewController.h"
#import "CompareTopView.h"
#import "CompareTableView.h"
#import "CompareContentView.h"
#import "NewCompareCarViewModel.h"
#import "ParameterConfigViewController.h"
//测试
#import "FindCarByGroupByCarTypeGetCarModel.h"
#import "CompareDict.h"
#import "CompareListViewController.h"



#define topViewheight 180

#define kItemheight 65

@interface NewCompareCarViewController ()<UIScrollViewDelegate,CompareTopViewDelegate,CompareTableViewDelegate>


@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CompareContentView *compareBackView;

@property (strong, nonatomic) CompareTopView *compareTopView;
@property (strong, nonatomic) CompareTableView *compareView;

@property (strong, nonatomic) NewCompareCarViewModel *viewModel;

//之后的比较数据
@property (strong, nonatomic) NSMutableDictionary *compareSelectedDict;
//之间的比较数据
@property (strong, nonatomic) NSMutableDictionary *originCompareSelectedDict;

@end

@implementation NewCompareCarViewController

- (void)loadView
{
    [super loadView];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.compareBackView = [[CompareContentView alloc] initWithFrame:self.view.bounds];
//    self.compareBackView.topView = self.compareTopView;
//    self.compareBackView.scrollView = self.scrollView;
//    self.compareBackView.contentView = self.compareView;
//    
//    self.view = self.compareBackView;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"综合对比"];
    [self configUI];
  
    [self showbackButtonwithTitle:nil];
    UIButton*button = [[UIButton alloc]initNavigationButtonWithTitle:@"参数对比" color:BlackColor333333 font:FontOfSize(14)];
    [self showBarButton:NAV_RIGHT button:button];
}

-(void)rightButtonTouch{
    ParameterConfigViewController *vc= [[ParameterConfigViewController alloc] init];
    vc.carIds = self.compareSelectedDict.allKeys;
    vc.isCompare = YES;
    [[Tool currentNavigationController].rt_navigationController pushViewController:vc animated:YES];
}


-(void)configUI{

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.compareView];
    [self.compareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
   
    }];
    
    [self.compareView loadView];
    
    [self.view addSubview:self.compareTopView];
    
    [self.compareTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.mas_equalTo(topViewheight);
    }];

    self.scrollView.showsVerticalScrollIndicator = YES;
    self.compareView.topView = self.compareTopView;
    self.compareView.parentScrollView  = self.scrollView;
 
//    self.compareView.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.compareTopView.height,0,0,0);
}


-(void)initData{
    
    self.carIds = [self.compareSelectedDict.allKeys componentsJoinedByString:@","];
    self.viewModel.request.ids = self.carIds;

    self.viewModel.request.startRequest = YES;
    self.compareView.carIds = [self.carIds copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
    }
    return _scrollView;
}

-(CompareTopView *)compareTopView{
    if (!_compareTopView) {
        _compareTopView = [[CompareTopView alloc] init];
        _compareTopView.swDelegate = self;
        _compareTopView.parentView = self.view;
    }
    return _compareTopView;
}

-(CompareTableView *)compareView{
    if (!_compareView) {
        _compareView = [[CompareTableView alloc] init];
        _compareView.tbDelegate = self;
    }
    return _compareView;
}

-(NewCompareCarViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [NewCompareCarViewModel SceneModel];
        @weakify(self);
        @weakify(_viewModel);
        [[RACObserve(_viewModel, data)
          filter:^BOOL(id value) {
              @strongify(_viewModel);
              return _viewModel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
              @strongify(self);
               @strongify(_viewModel);
              if (x) {
                  self.compareTopView.cars = _viewModel.data;
                  [self.compareTopView reloadCollection];
                  self.compareView.data = _viewModel.data;
                  [self.compareView loadTableView];
              }
          }];
    }
    return _viewModel;
}


#pragma mark 测试数据
//
//-(NSString*)compareSelectedDictPath{
//    NSString*path =[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@compareSelectedDict",@"CompareListViewController"];
//    return path;
//}

//-(NSMutableDictionary*)compareSelectedDict{
//    
//    if (!_compareSelectedDict) {
//        _compareSelectedDict = [NSMutableDictionary dictionary];
//        NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
//        [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
//            [_compareSelectedDict setObject:model forKey:obj];
//            
//        }];
//        
//    }
//    return _compareSelectedDict;
//    
//}


#pragma mark - 底部的scrollViuew的代理方法scrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
}

-(void)setUpNewCarsArrayWithLeftCar:(NewCompareCarModel *)leftcar RightCar:(NewCompareCarModel *)rightCar{
    NSArray *data = [NSArray arrayWithObjects:leftcar,rightCar,nil];
    NewCompareCarListModel *model = [[NewCompareCarListModel alloc] init];
    model.data = [data copy];
    self.compareView.data = model;
    [self.compareView loadTableView];
}

-(void)rebuildArray:(NSMutableArray *)newarray withDelateNumber:(NSInteger)count{
    
    NewCompareCarModel *temp_delate_car = [newarray objectAtIndex:count];
    [self editCompareSlectedDictWithCarId:temp_delate_car.cars.car_id];
    
    
    NSMutableArray *temparry = [[NSMutableArray alloc] initWithArray:newarray];
    [temparry removeObjectAtIndex:count];
    self.compareTopView.cars.data = [temparry copy];
    [self.compareTopView reloadCollection];
    self.compareView.data.data = [temparry copy];
    
    NSArray *data;
    
    if (count == 0) {
       data = [NSArray arrayWithObjects:temparry[0],temparry[1],nil];
    }else{
        if (temparry.count >count) {
            data = [NSArray arrayWithObjects:temparry[count-1],temparry[count],nil];
        }else{
            data = [NSArray arrayWithObjects:temparry[count-1],nil,nil];
        }
       
    }
    
    NewCompareCarListModel *model = [[NewCompareCarListModel alloc] init];
    model.data = [data copy];
    self.compareView.data = model;
    
    [self.compareView loadTableView];
}

-(void)setSwipeWay:(bool)swpie{
    self.compareBackView.isNeedparent = swpie;
}


-(void)setTableWay:(bool)swpie{
    self.compareBackView.isNeedparent = swpie;
}


-(NSString*)compareSelectedDictPath{
    NSString*path =[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@compareSelectedDict",classNameFromClass([CompareListViewController class])];
    return path;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.compareSelectedDict removeAllObjects];
    NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
    
    if([self isNeedLoadData:keyArray]){
        @weakify(self);
        [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
            [self.compareSelectedDict setObject:model forKey:obj];
        }];
        self.originCompareSelectedDict = [self.compareSelectedDict copy];
        [self initData];
    }else{
        @weakify(self);
        [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
            [self.compareSelectedDict setObject:model forKey:obj];
        }];
    }
   
}

//新老数据对比
-(bool)isNeedLoadData:(NSArray*)keyArray{
    
    if (keyArray.count != self.originCompareSelectedDict.count) {
        return YES;
    }else{
        //默认都是相同的
        bool isNotNeed = NO;
        
        NSArray*originkeys = self.originCompareSelectedDict.allKeys;
        
        NSMutableSet *set1 = [NSMutableSet setWithArray:originkeys];
        NSMutableSet *set2 = [NSMutableSet setWithArray:keyArray];
        [set2 minusSet:set1];
        NSMutableSet *set3 = [NSMutableSet setWithArray:keyArray];
        [set1 minusSet:set3];
        [set2 unionSet:set1];
        
        if (set2.count>0) {
            isNotNeed = YES;
        }
        
        return isNotNeed;
        
    }
}

//记录删除对比的车型
-(void)editCompareSlectedDictWithCarId:(NSString *)car_id{
    
    [self.compareSelectedDict removeObjectForKey:car_id ];
    [self.compareSelectedDict.allKeys writeToFile:[self compareSelectedDictPath] atomically:YES];
    //删除之后立马恢复数据
    self.originCompareSelectedDict = [self.compareSelectedDict copy];
    
}

-(NSMutableDictionary*)compareSelectedDict{
    
    if (!_compareSelectedDict) {
        _compareSelectedDict = [NSMutableDictionary dictionary];
        NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
        [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
            [_compareSelectedDict setObject:model forKey:obj];
            
        }];
    }
    return _compareSelectedDict;
    
}

-(NSMutableDictionary *)originCompareSelectedDict{
    if (!_originCompareSelectedDict) {
        _originCompareSelectedDict = [NSMutableDictionary dictionary];
    }
    return _originCompareSelectedDict;
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
