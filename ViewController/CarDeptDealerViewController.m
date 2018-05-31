//
//  CarDeptDealerViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CarDeptDealerViewController.h"
#import "CarDeptDealerTableView.h"
#import "InformationTypeTableViewCell.h"
#import "BrandViewController.h"
#import "CityViewController.h"
#import "CarTypeDetailDealerModel.h"

#import "Location.h"

@interface CarDeptDealerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) NSString *areaName;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;


@property (weak, nonatomic) IBOutlet UILabel *delearTypeLabel;

@property (copy, nonatomic)NSString *cityId;

@property (strong, nonatomic)UIButton *currentSelectedDelearTypeSortButton;
@property (strong, nonatomic)NSArray *storeListArray;
@property (strong, nonatomic)NSArray *sortListArray;
@property (assign, nonatomic)CarTypeDetailDealerScope dealerScope;
@property (assign, nonatomic)DealerSortType dealerSortType;
///默认排序与离我最近下面的蓝色view
@property (weak, nonatomic) IBOutlet UIView *delearTypeBackgroundView;
@property (strong, nonatomic)UITableView *delearTypeTableView;

@property (strong, nonatomic) CarDeptDealerTableView*normalTableView;

@property (assign, nonatomic)NSInteger currentpage;
//是否是打开的排序
@property (assign,nonatomic) bool isSort;
//是否是打开的授权
@property (assign,nonatomic) bool isShopType;


@end

@implementation CarDeptDealerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isSort = false;
    self.isShopType = false;
    
    self.dealerSortType = DealerSortTypeNormal;
    self.dealerScope = CarTypeDetailDealerScope4s;
    
    [self showNavigationTitle:@"经销商"];
 
    self.storeListArray = @[@"4S店",@"综合店"];
    
    self.sortListArray = @[@"综合排序",@"离我最近"];
    
    [self.delearTypeTableView registerNib:nibFromClass(InformationTypeTableViewCell) forCellReuseIdentifier:classNameFromClass(InformationTypeTableViewCell)];
    [self configScrollView];
    
    
    @weakify(self);
    
    [[RACSignal combineLatest:@[RACObserve([AreaNewModel shareInstanceSelectedInstance],id),RACObserve([AreaNewModel shareInstanceSelectedInstance],name)]reduce:^(NSString*cityId,NSString*name){
        @strongify(self);
        BOOL cityIdEqual = NO;
        if ([cityId isEqual:self.cityId]) {
            cityIdEqual = YES;
            
        }else{
            self.cityId = [AreaNewModel shareInstanceSelectedInstance].id;
        }
        BOOL cityNameEqual = NO;
        if ([self.areaName isEqual:name]) {
            
            cityNameEqual = NO;
        }else{
            self.areaName = [AreaNewModel shareInstanceSelectedInstance].name;
        }
        
        return @((!cityIdEqual)||(!cityNameEqual));
    }]subscribeNext:^(NSNumber* x) {
        @strongify(self);
        if ([x boolValue]) {
            UIButton*button = [Tool createButtonWithTitle:self.areaName titleColor:BlueColor447FF5 target:self action:@selector(rightButtonTouch)];
            button.titleLabel.font = FontOfSize(14);
            CGSize size = [button systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            button.frame = CGRectMake(0, 0, size.width, size.height);
            UIBarButtonItem*item = [[UIBarButtonItem alloc]initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = item;
            
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId  dealerScope:self.dealerScope cityId:self.cityId styletype:self.dealerSortType];
        }
    }];
    
   
}

-(void)configScrollView{
    self.normalTableView = [[CarDeptDealerTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.normalTableView];
    [self.view sendSubviewToBack:self.normalTableView];
    [self.normalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
        make.width.equalTo(self.view);
    }];
    
    
}
 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.isSort){
        return self.sortListArray.count;
    }
    return self.storeListArray.count;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationTypeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(InformationTypeTableViewCell) forIndexPath:indexPath];
    NSString*title;
    
    if(self.isSort){
        title =  self.sortListArray[indexPath.row];
        
        [cell.titleButton setTitle:title forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([title isEqual:self.brandLabel.text]) {
            cell.selected = YES;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }

    }else{
        title = self.storeListArray[indexPath.row] ;
        
        [cell.titleButton setTitle:title forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([title isEqual:self.delearTypeLabel.text]) {
            cell.selected = YES;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }

    }

    
     return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///排序的点击
    if (self.isSort) {
        
        NSString*title =self.sortListArray[indexPath.row] ;
        self.brandLabel.text = title;
        self.delearTypeBackgroundView.hidden = YES;
        
        if ([title isEqual: @"综合排序"] ) {
            self.dealerSortType = DealerSortTypeNormal;
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId styletype:DealerSortTypeNormal];
        }else{
            self.dealerSortType = DealerSortTypeNearest;
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId styletype:DealerSortTypeNearest];
        }
        
    }else{
        
        NSString*title =self.storeListArray[indexPath.row] ;
        self.delearTypeLabel.text = title;
        self.delearTypeBackgroundView.hidden = YES;
        self.dealerScope = CarTypeDetailDealerScopeUnix;
        if ([title isEqual: @"综合店"] ) {
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:CarTypeDetailDealerScopeUnix cityId:self.cityId styletype:self.dealerSortType];
        }else{
            self.dealerScope = CarTypeDetailDealerScope4s;
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:CarTypeDetailDealerScope4s cityId:self.cityId styletype:self.dealerSortType];
        }

    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////离我最近
//- (IBAction)nearestClicked:(UIButton *)sender {
//    
//    
//    if (self.currentSelectedDelearTypeSortButton!=sender) {
//        self.currentSelectedDelearTypeSortButton.selected = NO;
//        self.currentSelectedDelearTypeSortButton = sender;
//        sender.selected = YES;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bottomTrimView.transform = CGAffineTransformMakeTranslation(sender.centerX - self.bottomTrimView.centerX, 0);
//        }];
//        [self.scrollView setContentOffset:CGPointMake(kwidth, self.scrollView.contentOffset.y) animated:YES];
//        [self.nearestTableView refreshWithArea:self.areaLabel.text brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
//    }
//    
//    
//}
////默认排序
//- (IBAction)normalSortClicked:(UIButton *)sender {
//    
//    if (self.currentSelectedDelearTypeSortButton!=sender) {
//        self.currentSelectedDelearTypeSortButton.selected = NO;
//        self.currentSelectedDelearTypeSortButton = sender;
//        sender.selected = YES;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bottomTrimView.transform =CGAffineTransformIdentity;
//        }];
//        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
//        [self.normalTableView refreshWithArea:self.areaLabel.text brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
//        
//    }
//    
//}
- (IBAction)delearTypeBackgroundViewHide:(UITapGestureRecognizer *)sender {
    self.delearTypeBackgroundView.hidden = YES;
}
//经销商类型切换
- (IBAction)dealerTypeButtonClicked:(UIButton *)button{
    // 如果授权店已经打开了
    if (self.isSort && !self.delearTypeBackgroundView.hidden ) {
        self.isSort = false;
        self.isShopType =  !self.isSort;
        [self.delearTypeTableView reloadData];
        return ;
    }
    
    if (self.delearTypeBackgroundView.hidden) {
          self.delearTypeBackgroundView.hidden = NO;
        self.isShopType = true;
        self.isSort = false;
        [self.delearTypeTableView reloadData];
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 88;
        }completion:^(BOOL finished) {
          
        }];
    }else{
        self.isShopType = false;
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 0;
        }completion:^(BOOL finished) {
            self.delearTypeBackgroundView.hidden = YES;
        }];

    }
}
//地区
-(void)rightButtonTouch{
    CityViewController*province = [[CityViewController alloc]init];
    [self.rt_navigationController pushViewController:province animated:YES];
}
//综合排序
- (IBAction)brandButtonClicked:(UIButton *)sender {
   
    // 如果授权店已经打开了
    if (self.isShopType && !self.delearTypeBackgroundView.hidden) {
        self.isShopType = false;
        self.isSort =  !self.isShopType;
        [self.delearTypeTableView reloadData];
        return ;
    }
    
    if (self.delearTypeBackgroundView.hidden) {
        self.delearTypeBackgroundView.hidden = NO;
        self.isSort = true;
        [self.delearTypeTableView reloadData];
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 88;
        }completion:^(BOOL finished) {
            
        }];

    }else{
        self.isSort = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 0;
        }completion:^(BOOL finished) {
            self.delearTypeBackgroundView.hidden = YES;
        }];
    }

}

-(UITableView *)delearTypeTableView{
    if(!_delearTypeTableView){
        _delearTypeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _delearTypeTableView.delegate = self;
        _delearTypeTableView.dataSource = self;
        [self.delearTypeBackgroundView addSubview:_delearTypeTableView];
        [_delearTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.delearTypeBackgroundView);
        }];
    }
    return _delearTypeTableView;
}


@end
