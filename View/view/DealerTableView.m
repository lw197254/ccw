//
//  DealerViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerTableView.h"
#import "DealerTableViewCell.h"

#import "BrandViewController.h"

#import "InformationTypeTableViewCell.h"
#import "Location.h"
#import "AskForPriceViewController.h"
#import "PhoneCallWebView.h"
#import "DealerDetailViewController.h"
@interface DealerTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *brandId;
@property (copy, nonatomic) NSString *cityId;


@property (strong, nonatomic)DealerViewModel *viewModel;
@property(nonatomic,assign)CarTypeDetailDealerScope dealerScope;
@property (assign, nonatomic)DealerSortType dealerSortType;
@end

@implementation DealerTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dealerSortType:(DealerSortType)dealerSortType{
    if (self = [super initWithFrame:frame style:style]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.dealerSortType = dealerSortType;
         [self viewDidLoad];
    }
    return self;
}
-(void)refreshWithArea:(NSString*)area brand:(NSString*)brand dealerScope:(CarTypeDetailDealerScope)dealerScope cityId:(NSString*)cityId{
    BOOL needRfresh = NO;
    if (![area isEqual:self.area]) {
        self.area = area;
        needRfresh = YES;
    }
    if (![brand isEqual:self.brandId]) {
        self.brandId = brand;
        needRfresh = YES;
    }
    if (dealerScope !=self.dealerScope) {
        self.dealerScope = dealerScope;
        needRfresh = YES;
    }
    if (![cityId isEqual:self.cityId]) {
        self.cityId = cityId;
        needRfresh = YES;
    }
    if (needRfresh) {
        [self.mj_header beginRefreshing];
        
    }
}
- (void)viewDidLoad {
   
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:nibFromClass(DealerTableViewCell) forCellReuseIdentifier:classNameFromClass(DealerTableViewCell)];
    self.viewModel = [DealerViewModel SceneModel];
    
   
    @weakify(self);
    self.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRefresh];
    }];
    
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
//    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
//        @strongify(self);
//        return !self.viewModel.model.isNotEmpty;
//    }]subscribeNext:^(id x) {
//        [self.mj_header endRefreshing];
//        [self showWithOutDataViewWithTitle:@"没有找到满足当前条件的经销商～\n您可以变更当前选择条件再次尝试～"];
//        [self.mj_footer setState:MJRefreshStateNoMoreData];
//        [self reloadData];
//    }];
    
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        if (self.viewModel.request.page ==1) {
            [self.viewModel.list removeAllObjects];
        }
        self.viewModel.model.currentPage = self.viewModel.request.page;
        
        self.viewModel.list =  [self.viewModel.model success:self.viewModel.list newArray:self.viewModel.model.list];
        
        
        
        
        if (self.viewModel.list.count == 0) {
            [self showWithOutDataViewWithTitle:@"没有找到满足当前条件的经销商～\n您可以变更当前选择条件再次尝试～"];
        }else{
            if (self.mj_footer==nil && (self.viewModel.model.page_count > self.viewModel.model.list.count)) {
                
                self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                    @strongify(self);
                    self.viewModel.request.startRequest  = YES;
                }];

            }else if(self.viewModel.model.page_count > self.viewModel.model.list.count){
                self.viewModel.request.page++;
            }else{
                [self.mj_footer setState:MJRefreshStateNoMoreData];
                ((MJRefreshAutoNormalFooter*)self.mj_footer).stateLabel.text = @"";
            }
            
            [self dismissWithOutDataView];
        }
        
        [self reloadData];
    }];
    
    
//    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
//        @strongify(self);
//        return !self.viewModel.model.isNotEmpty;
//    }]subscribeNext:^(id x) {
//        @strongify(self);
//        [self.mj_header endRefreshing];
//        [self.mj_footer endRefreshing];
//        [self.viewModel.list removeAllObjects];
//        [self reloadData];
//        [self showWithOutDataViewWithTitle:@"没有找到满足当前条件的经销商～\n您可以变更当前选择条件再次尝试～"];
//    }];
    
    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.request.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        [self reloadData];
        
        [self showNetLost];
        
    }];
    
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
       // Do any additional setup after loading the view from its nib.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self) {
        if (section == 0) {
            return 0;
        }else{
            return 5;
        }
    }else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
        return self.viewModel.list.count;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        DealerTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DealerTableViewCell) forIndexPath:indexPath ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DealerModel*model = self.viewModel.list[indexPath.row];
        
        
        cell.titleLabel.text = model.shortname;
        cell.carname.text = model.mainbrand;
    
    
        [cell.carimage setImageWithURL:[NSURL URLWithString:model.brandpic] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    

        if (model.distance.isNotEmpty) {
            cell.distanceLabel.text = model.distance;
            [cell.distanceImage setHidden:NO];
        }else{
            cell.distanceLabel.text = @"";
            [cell.distanceImage setHidden:YES];
        }

    
        cell.location.text = model.address;
        NSString*name = @"4S店";
        if (model.scopestatus == CarTypeDetailDealerScopeUnix) {
            name = @"综合店";
        }
    if (model.orderrange.isNotEmpty) {
         cell.saleAreaLabel.hidden = NO;
        cell.saleAreaLabel.text = model.orderrange;
    }else{
        cell.saleAreaLabel.hidden = YES;
    }
    
    
        cell.askForPriceButton.tag = indexPath.row;
        cell.callButton.tag = indexPath.row;
        [cell.callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.askForPriceButton addTarget:self action:@selector(askForPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
        
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        DealerDetailViewController*vc = [[DealerDetailViewController alloc]init];
        DealerModel*model = self.viewModel.list[indexPath.row];
        vc.dealerId = model.id;
        [[Tool currentNavigationController ] pushViewController:vc animated:YES];
    
    
    
}
///拨打电话
-(void)callButtonClicked:(UIButton*)button{
    DealerModel*model = self.viewModel.list[button.tag];
    if (model.service_phone.isNotEmpty) {
        [PhoneCallWebView showWithTel:model.service_phone];
    }else{
        [UIAlertController showAlertInViewController:[Tool currentViewController] withTitle:@"" message:@"经销商电话为空" cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
    }
    
    
    //    model.phone;
}
- (IBAction)askForPriceClicked:(UIButton *)button {
    [ClueIdObject setClueId:xunjia_12];
    
    AskForPriceViewController*vc = [[AskForPriceViewController alloc]init];
    
    vc.cityId = self.viewModel.request.cityId;
    vc.cityName = self.area;
    
    
    DealerModel*model = self.viewModel.list[button.tag];
    
    
    vc.delearId = model.id;
    
    
    
    [[Tool currentNavigationController ]  pushViewController:vc animated:YES];
}





//品牌


-(void)headerRefresh{
    self.viewModel.request.page = 1;
    
    
    ///int	城市ID 必填
    self.viewModel.request. cityId = self.cityId;
    self.viewModel.request.typeId = self.brandId;
    self.viewModel.request.scopestatus  = self.dealerScope;
    
    
    self.viewModel.request. limit = 10;
    
    if (self.dealerSortType == DealerSortTypeNearest) {
        [[Location shareInstance]startLocationSuccess:^(CLLocationCoordinate2D coordinate, NSString *cityName, NSString *address) {
            self.viewModel.request.lat =[NSNumber numberWithDouble:[Location shareInstance].coordinate.latitude] ;
            self.viewModel.request. lon = [NSNumber numberWithDouble:[Location shareInstance].coordinate.longitude];
            self.viewModel.request.startRequest = YES;
        } failed:^(NSString *errorMessage) {
            //            if (errorMessage) {
            //                if (self.viewModel.list.count==0) {
            //                    [self showWithOutDataViewWithTitle:errorMessage];
            //                }else{
            //                    [[DialogView sharedInstance]showDlg:[UIApplication sharedApplication].keyWindow textOnly:errorMessage];
            //                }
            //
            //            }else{
            ////                [self.viewModel.list removeAllObjects];
            ////                [self reloadData];
            ////                [self showWithOutDataViewWithTitle:nil image:nil buttonTitle:@"去开启定位" buttonClicked:^{
            ////                    [[Location shareInstance] editPermission];
            ////                }];
            //
            //            }
            self.viewModel.request.lat = nil;
            self.viewModel.request. lon = nil;
            self.viewModel.request.startRequest = YES;
            //            [self.mj_header endRefreshing];
            
        } loactionPermissionErrorAlertShow:NO];
        
    }else{
        self.viewModel.request.lat = nil;
        self.viewModel.request. lon = nil;
        self.viewModel.request.startRequest = YES;
    }
    
    //     self.viewModel.request. lat = 0;
    //     self.viewModel.request. lon = 0;
    
    
    
    
    
    
    
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
