//
//  FactoryListViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FactoryListViewController.h"

#import "ReduceTypeTableViewCell.h"

#import "CarSeriesViewModel.h"
#import "PublicPraiseCarsViewModel.h"
#import "CarAllCheXingViewModel.h"





@interface FactoryListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,copy) NSArray *data;
@property(nonatomic,copy)NSMutableArray *carTypeArray;

@property (weak, nonatomic) IBOutlet UIView *customNavigationView;
@property (strong, nonatomic) FactoryListViewController *carCheXingViewController;

//车系选择
@property(nonatomic,strong)CarSeriesViewModel*viewModel;
@property(nonatomic,strong)NSMutableArray<CarSeriesModel> *carCheXiArray;
//车型选择
@property(nonatomic,strong)CarAllCheXingViewModel *carViewModel;
@property(nonatomic,strong)NSMutableArray<KouBeiCarsModel> *cars;
@end
#define levelseation 0

@implementation FactoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

-(void)initData{
    
    if (self.controllerType == UIControllerCarLevel) {
        self.titleLabel.text = @"选车级别";
        NSArray *array = self.data[levelseation][@"list"];
        
//        NSDictionary *first = [NSDictionary dictionaryWithObject:@"全部" forKey:@"value"];
        NSDictionary *first = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"全部", @"value",
                              @"9999", @"key",
                              nil];
        self.selectLevel = @"9999";
        [self.carTypeArray addObject:first];
        for (int i =0; i<array.count; i++) {
            NSArray *rowsarray = array[i][@"list"];
            [self.carTypeArray addObjectsFromArray:rowsarray];
        }
        
        
    }else if(self.controllerType == UIControllerCarType){
        self.titleLabel.text = @"选择车系";
        self.viewModel.request.pinpaiId = self.carModel.id;
        self.viewModel.request.startRequest = YES;
        @weakify(self);
        [[RACObserve(self.viewModel, model) filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            if(self.viewModel.model.data.count > 0){
                [self reBuildCarTypeName];
                [self.tableView dismissWithOutDataView];
                [self.tableView reloadData];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }else{
                [self.tableView showWithOutDataViewWithTitle:@"暂无"];
            }
        }];
        [[RACObserve(self.viewModel.request, state) filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.request.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            [self.tableView showNetLost];
        }];
    }else{
        self.titleLabel.text = @"选车车型";
        self.carViewModel.request.chexiId =self.carCheXingModel.id;
        self.carViewModel.request.startRequest = YES;
        
        
        @weakify(self);
        [[RACObserve(self.carViewModel, data)
          filter:^BOOL(id value) {
              @strongify(self);
              return self.carViewModel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
              @strongify(self);
              self.cars = [self.carViewModel.data.data copy];
              [self changeCarsList];
              [self.tableView reloadData];
              [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
          }];
    }
   
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.tableView registerNib:nibFromClass(ReduceTypeTableViewCell) forCellReuseIdentifier:classNameFromClass(ReduceTypeTableViewCell)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IOS_11_OR_LATER) {
        
    }else{
        [self.customNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(StatusHeight);
        }];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.controllerType == UIControllerCarLevel) {
         return self.carTypeArray.count;
    }else if(self.controllerType == UIControllerCarType){
        return self.carCheXiArray.count;
    }else{
        return self.cars.count;
    }
   
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReduceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ReduceTypeTableViewCell) forIndexPath:indexPath];
    
    if (self.controllerType == UIControllerCarLevel) {
        NSString *value = self.carTypeArray[indexPath.row][@"value"];
        [cell.titleButton setTitle:value forState: UIControlStateNormal];
        NSString *key = self.carTypeArray[indexPath.row][@"key"];
        if ([self.selectLevel intValue] == [key intValue]) {
            cell.selected = YES;
            cell.titleButton.selected =YES;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }else if(self.controllerType == UIControllerCarType){
        CarSeriesModel *model = self.carCheXiArray[indexPath.row];
        
        if ([model.id isEqualToString:self.carID]) {
            cell.titleButton.selected = YES;
        }
        
        [cell.titleButton setTitle:model.name forState:UIControlStateNormal];
    }else{
        CarCheXingModel *model = self.cars[indexPath.row];
        
        if ([model.id isEqualToString:self.carTypeID]) {
            cell.titleButton.selected = YES;
        }
        
        [cell.titleButton setTitle:model.name forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.controllerType == UIControllerCarType) {
        CarSeriesModel *model = self.carCheXiArray[indexPath.row];
        
        if ([model.name isEqualToString:@"全部车系"]) {
 
            if (self.childBlock) {
                self.childBlock(@"", @"");
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            self.carCheXingViewController = [[FactoryListViewController alloc] init];
            self.carCheXingViewController.controllerType = UIControllerCarCheXingType;
            self.carCheXingViewController.carCheXingModel = model;
            self.carCheXingViewController.carTypeID = self.carTypeID;
        
            @weakify(self);
            self_weak_.carCheXingViewController.childBlock = ^(NSString *carID, NSString *carTypeID) {
                @strongify(self);
                if (self.childBlock) {
                    self.childBlock(carID, carTypeID);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:self.carCheXingViewController animated:YES completion:nil];
        }
    }else if(self.controllerType == UIControllerCarLevel){
        NSString *value = self.carTypeArray[indexPath.row][@"value"];
        if ([value isEqualToString:@"全部"]) {
            if (self.levelBlock) {
                self.levelBlock(@"0");
            }
        }else{
            self.levelBlock(self.carTypeArray[indexPath.row][@"key"]);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        CarCheXingModel *temp = self.cars[indexPath.row];
        
        if (self.childBlock) {
            self.childBlock(self.carCheXingModel.id,temp.id);
        }
    }
}

#pragma 功能
//添加头部的信息
-(CarCheXingModel *)addTopCar{
    CarCheXingModel *car = [[CarCheXingModel alloc] init];
    car.id = @"";
    car.name= @"全部车型";
    return car;
}

//改变数据结构
-(void)changeCarsList{
    self.cars = [[self.cars reverseObjectEnumerator] allObjects];
    [self.cars addObject:[self addTopCar]];
    self.cars = [[self.cars reverseObjectEnumerator] allObjects];
}

-(void)reBuildCarTypeName{
    CarSeriesModel *temp = [[CarSeriesModel alloc] init];
    temp.name = @"全部车系";
    temp.id = self.carModel.id;
    [self.carCheXiArray addObject:temp];
    
    for (int i=0; i<self.viewModel.model.data.count; i++) {
        CarSeriesSectionModel *model = self.viewModel.model.data[i];
        [self.carCheXiArray addObjectsFromArray:model.list];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma 懒加载

-(NSMutableArray<KouBeiCarsModel> *)cars{
    if (!_cars) {
        _cars = [NSMutableArray<KouBeiCarsModel> arrayWithCapacity:1];
    }
    return _cars;
}

-(NSMutableArray<CarSeriesModel> *)carCheXiArray{
    if (!_carTypeArray) {
        _carTypeArray = [NSMutableArray<CarSeriesModel*> arrayWithCapacity:1];
    }
    return _carTypeArray;
}

-(CarAllCheXingViewModel *)carViewModel{
    if (!_carViewModel) {
        _carViewModel = [CarAllCheXingViewModel SceneModel];
    }
    return _carViewModel;
}

-(CarSeriesViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CarSeriesViewModel SceneModel];
    }
    return _viewModel;
}

-(NSMutableArray *)carTypeArray{
    if (!_carTypeArray) {
        _carTypeArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _carTypeArray;
}


-(NSArray*)data{
    if (!_data) {
        NSString*path = [[NSBundle mainBundle]pathForResource:@"conditionSelectCarConfig" ofType:@"json"];
        NSMutableData*data = [[NSMutableData alloc]initWithContentsOfFile:path];
        NSError*error;
        _data =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    return _data;
    
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
