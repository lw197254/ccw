//
//  ReduceBrandSelectViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/25.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ReduceBrandSelectViewController.h"

#import "BrandTableViewCell.h"
#import "BrandViewModel.h"
#import "UIViewController+HalfLeftSlider.h"
#import "CarSeriesViewController.h"
#import "CarSeriesModel.h"
#import "UITableView+CustomTableViewIndexView.h"
#import "FactoryListViewController.h"


@interface ReduceBrandSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIView *customNavigationView;

@property(nonatomic,strong)BrandViewModel*viewModel;
@property(nonatomic,strong)CarSeriesViewController*carSeriesVC;
@property (strong, nonatomic)FactoryListViewController *carTypeVC;

@end

@implementation ReduceBrandSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initConfig];
    [self initData];
}


-(void)initConfig{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerNib:nibFromClass(BrandTableViewCell) forCellReuseIdentifier:classNameFromClass(BrandTableViewCell)];
}

-(void)initData{
    self.viewModel = [BrandViewModel SceneModel];
    self.viewModel.request.startRequest = YES;
    
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        self.tableview.customIndexViewEdgeInsets = UIEdgeInsetsMake(44, 0, 0, 0);
        @weakify(self);
        [self.tableview reloadViewWithArray:self.viewModel.model.sectionHeaderTitleArray select:^(NSString *title, NSInteger index) {
            @strongify(self);
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
        }];
        
        [self.tableview reloadData];
        //        [self.tableview reloadViewWithArray:self.viewModel.model.sectionIndexTitleArray select:nil];
        
    }];
    
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

#pragma mark uitableviewDelagate

///头部banner配置数据

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FontOfSize(14);
    header.textLabel.textColor = BlackColor333333;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.viewModel.model.sectionHeaderTitleArray[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.model.sectionIndexTitleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FindCarBrandSectionListModel*model = self.viewModel.model.list[section];
    
    return model.array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    if (section == self.viewModel.model.sectionIndexTitleArray.count-1) {
    //        return 55;
    //    }
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:classNameFromClass(BrandTableViewCell) forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 15+15+35, 0, 0);
    FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
    
    BrandModel*model = sectionModel.array[indexPath.row];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"默认汽车品牌"]];
    cell.titleLabel.text =model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    self.carTypeVC = [[FactoryListViewController alloc] init];
    
    @weakify(self);
    self.carTypeVC.childBlock = ^(NSString *carID, NSString *carTypeID) {
        @strongify(self);
        if (self.parentBlock) {
            self.parentBlock(self.brandID,carID,carTypeID);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    self.carTypeVC.controllerType = UIControllerCarType;
    
    FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
    BrandModel*model = sectionModel.array[indexPath.row];

    self.brandID = model.id;
    self.carTypeVC.carModel = model;
    [self presentViewController:self.carTypeVC animated:YES completion:nil];
    
    
//    if (self.carSeriesVC) {
//
//        self.carSeriesVC.brandModel = model;
//        [self resetHalfLeftSliderViewController:self.carSeriesVC edgeInsets:UIEdgeInsetsMake(64, 62, 0, 0)];
//        [self.carSeriesVC refreshViewController];
//    }else{
//        self.carSeriesVC= [[CarSeriesViewController alloc]init];
////        self.carSeriesVC.carSeriesType = CarSeriesTypeReduceSingleSelect;
//        self.carSeriesVC.brandModel = model;
//
//
//        @weakify(self);
//        self.carSeriesVC.carSeriesSelectedBlock = ^(CarSeriesModel *model) {
//            @strongify(self);
//            if (self.block) {
//                self.block(model.id,model.name);
//            }
//
//        };
//        [self addHalfLeftSliderViewController:self.carSeriesVC viewEdgeInsets:UIEdgeInsetsMake(64, 62, 0, 0) removeBlock:^{
//
//        }] ;
//
//
//    }
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
