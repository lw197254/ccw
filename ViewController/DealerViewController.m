//
//  DealerViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerViewController.h"
#import "DealerTableView.h"
#import "InformationTypeTableViewCell.h"
#import "BrandViewController.h"
#import "CityViewController.h"

#import "Location.h"

@interface DealerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic)NSString *areaName;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (copy, nonatomic)NSString *brandId;

@property (weak, nonatomic) IBOutlet UILabel *delearTypeLabel;
@property (assign, nonatomic)CarTypeDetailDealerScope dealerScope;
@property (copy, nonatomic)NSString *cityId;

@property (weak, nonatomic) IBOutlet UIButton *nearestSortTypeButton;

@property (weak, nonatomic) IBOutlet UIButton *normalSortTypeButton;
@property (strong, nonatomic)UIButton *currentSelectedDelearTypeSortButton;
@property (strong, nonatomic)NSArray *storeListArray;
//@property (strong, nonatomic) DealerTableView *currentTableView;
///默认排序与离我最近下面的蓝色view
@property (weak, nonatomic) IBOutlet UIView *bottomTrimView;
@property (weak, nonatomic) IBOutlet UIView *delearTypeBackgroundView;
@property (strong, nonatomic) UITableView *delearTypeTableView;

@property (strong, nonatomic) DealerTableView*normalTableView;

@property (assign, nonatomic)NSInteger currentpage;
@end

@implementation DealerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dealerScope = CarTypeDetailDealerScopeAll;
    
    [self showNavigationTitle:@"附近经销商"];
    self.currentSelectedDelearTypeSortButton = self.normalSortTypeButton;
    self.storeListArray = @[@"全部",@"4S店",@"综合店"];
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
           
             [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
        }
    }];
    
    
    
    

   

    // Do any additional setup after loading the view from its nib.
}
-(void)configScrollView{
    self.normalTableView = [[DealerTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain dealerSortType:DealerSortTypeNearest];
    [self.view addSubview:self.normalTableView];
    [self.view sendSubviewToBack:self.normalTableView];
    [self.normalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.view).offset(40);
    }];
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
        return 0;
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
 
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
        NSString*title =self.storeListArray[indexPath.row] ;
        
        [cell.titleButton setTitle:title forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([title isEqual:self.delearTypeLabel.text]) {
            cell.selected = YES;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        return cell;

    
   }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        
        NSString*title =self.storeListArray[indexPath.row] ;
        self.delearTypeLabel.text = title;
        
        
        self.delearTypeBackgroundView.hidden = YES;
    if ([title isEqual: @"4S店"] ) {
         self.dealerScope = CarTypeDetailDealerScope4s;
         [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:CarTypeDetailDealerScope4s cityId:self.cityId];
    }else if ([title isEqual: @"4S店"] ){
         self.dealerScope = CarTypeDetailDealerScopeUnix;
         [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:CarTypeDetailDealerScopeUnix cityId:self.cityId];
    }else{
        self.dealerScope = CarTypeDetailDealerScopeAll;
        [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
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
//     if (self.currentSelectedDelearTypeSortButton!=sender) {
//         self.currentSelectedDelearTypeSortButton.selected = NO;
//         self.currentSelectedDelearTypeSortButton = sender;
//         sender.selected = YES;
//         [UIView animateWithDuration:0.25 animations:^{
//             self.bottomTrimView.transform = CGAffineTransformMakeTranslation(sender.centerX - self.bottomTrimView.centerX, 0);
//         }];
//         [self.scrollView setContentOffset:CGPointMake(kwidth, self.scrollView.contentOffset.y) animated:YES];
//         [self.nearestTableView refreshWithArea:self.areaLabel.text brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
//     }
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
//         [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
//       [self.normalTableView refreshWithArea:self.areaLabel.text brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
//
//    }
//   
//}
- (IBAction)delearTypeBackgroundViewHide:(UITapGestureRecognizer *)sender {
    self.delearTypeBackgroundView.hidden = YES;
}
//经销商类型切换
- (IBAction)dealerTypeButtonClicked:(UIButton *)button{
    if (!self.delearTypeBackgroundView.hidden) {
        [UIView animateWithDuration:0.25 animations:^{
          self.delearTypeTableView.height = 0;
        }completion:^(BOOL finished) {
            self.delearTypeBackgroundView.hidden = YES;
        }];
    }else{
        self.delearTypeBackgroundView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 88/2*3;
        }completion:^(BOOL finished) {
           
        }];
    }
}
//地区
-(void)rightButtonTouch{
    CityViewController*province = [[CityViewController alloc]init];
    [self.rt_navigationController pushViewController:province animated:YES];
}

////品牌
- (IBAction)brandButtonClicked:(UIButton *)sender {
    BrandViewController*vc = [[BrandViewController alloc]init];
    vc.carSeriesType = CarSeriesTypeDelear;
    vc.brandSelectedBlock = ^(BrandModel*model){
        NSString*name;
        NSString*id;
        if (model==nil) {
            name = @"车系";
            id = 0;
        }else{
            name = model.name ;
            id = model.id;
        }
        
        if (![self.brandId isEqualToString:id]) {
            self.brandLabel.text = name ;
            self.brandId = id;
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
            
        }

    };
    
    vc.carSeriesSelectedBlock = ^(CarSeriesModel*model){
        NSString*name;
        NSString*id;
        if (model==nil) {
            name = @"车系";
            id = 0;
        }else{
             name = model.name ;
            id = model.id;
        }
       
        if (![self.brandId isEqualToString:id]) {
            self.brandLabel.text = name ;
            self.brandId = id;
            [self.normalTableView refreshWithArea:self.areaName brand:self.brandId dealerScope:self.dealerScope cityId:self.cityId];
            
        }
       
    };
    [self.rt_navigationController pushViewController:vc animated:YES];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
