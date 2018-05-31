//
//  ReducePriceListViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/20.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ReducePriceListViewController.h"
#import "FactoryListViewController.h"
#import "ReduceBrandSelectViewController.h"
#import "DealerCarInfoViewController.h"

#import "ReduceTypeTableViewCell.h"
#import "ReduceCarTableViewCell.h"

#import "CityViewController.h"

#import "ReduceModel.h"
#import "ConditionModel.h"
#import "ConditionSelectedCarPriceView.h"

#import "ReduceViewModel.h"
#import "Location.h"

@interface ReducePriceListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *brandButton;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UITableView *defaultTableView;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *positionButton;
@property (weak, nonatomic) IBOutlet ConditionSelectedCarPriceView *conditionPriceView;
@property (weak, nonatomic) IBOutlet UIView *blackgroundView;
@property (weak, nonatomic) IBOutlet UIView *toBackBackground;

@property (strong, nonatomic) ReduceViewModel *viewModel;

@property (strong, nonatomic) UITableView*delearTypeTableView;


@property (strong, nonatomic) NSArray *storeListArray;
@property (copy, nonatomic) NSString *areaName;
@property (copy, nonatomic) NSString *cityId;
@property (copy, nonatomic) NSMutableArray<ReduceModel> *list;
@property (copy, nonatomic) NSMutableArray *price;
@property (strong, nonatomic) UIButton *cityButton;


@property (strong, nonatomic)FactoryListViewController *brandVC;
@property (strong, nonatomic)ReduceBrandSelectViewController *redBrandVC;

@property (assign, nonatomic) NSInteger maxPrice;
@property (assign, nonatomic) NSInteger minPrice;

@end

#define _limit 10;
#define _page 1;
#define _order 1;
#define _level 0;

@implementation ReducePriceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitle:@"优惠降价"];
    [self initView];
    
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

-(void)initView{
    
    [self.brandButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
    [self.brandButton setImage:[UIImage imageNamed:@"ic_blue_down"] forState:UIControlStateSelected];
    [self.brandButton exchangeImageAndTitle];
    
    [self.priceButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
    [self.priceButton setImage:[UIImage imageNamed:@"ic_blue_down"] forState:UIControlStateSelected];
    [self.priceButton exchangeImageAndTitle];
    
    [self.typeButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
    [self.typeButton setImage:[UIImage imageNamed:@"ic_blue_down"] forState:UIControlStateSelected];
    [self.typeButton exchangeImageAndTitle];
    
    [self.positionButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
    [self.positionButton setImage:[UIImage imageNamed:@"ic_blue_down"] forState:UIControlStateSelected];
    [self.positionButton exchangeImageAndTitle];
    
    self.defaultTableView.delegate = self;
    self.defaultTableView.dataSource = self;
    self.defaultTableView.estimatedSectionFooterHeight=0;
    self.delearTypeTableView.estimatedSectionHeaderHeight = 0;
    self.delearTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delearTypeTableView.separatorColor = [UIColor whiteColor];
    
    [self.defaultTableView registerNib:nibFromClass(ReduceCarTableViewCell) forCellReuseIdentifier:classNameFromClass(ReduceCarTableViewCell)];
    
    [self.conditionPriceView.confirmButton setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
    [self.conditionPriceView.confirmButton addTarget:self action:@selector(askChangePrice) forControlEvents:UIControlEventTouchUpInside];
    self.conditionPriceView.isReduce = YES;
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap)];    
 
    [self.toBackBackground addGestureRecognizer:tapRecognizer];
    self.toBackBackground.userInteractionEnabled = YES;
    self.blackgroundView.userInteractionEnabled = YES;
   
}


-(void)initData{
    
    if ([self.carID isNotEmpty]) {
        self.viewModel.request.type_id = self.carID;
    }
    
    if ([self.carTypeID isNotEmpty]) {
        self.viewModel.request.son_type_id = self.carTypeID;
    }
    
    self.storeListArray = @[@"按价格排序",@"按降幅排序",@"按距离排序"];
    [self.delearTypeTableView reloadData];
    [self.delearTypeTableView setHidden:YES];
    [self.delearTypeTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    @weakify(self);
    self.defaultTableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.viewModel.request.page = _page;
        self.viewModel.request.startRequest = YES;
    }];
    
 
    [[RACObserve(self.viewModel, data) filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.defaultTableView.mj_header endRefreshing];
        [self.defaultTableView.mj_footer endRefreshing];

        [self.defaultTableView dismissWithOutDataView];
        if (self.viewModel.request.page == 1) {
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:self_weak_.viewModel.data.list];
        }else{
             [self.list addObjectsFromArray:self_weak_.viewModel.data.list];
        }

        if (self.defaultTableView.mj_footer == nil) {
             @weakify(self);
            self.defaultTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                @strongify(self);
                self.viewModel.request.page = self.viewModel.request.page+1;
                self.viewModel.request.startRequest  = YES;
            }];
        }


        if (self.viewModel.data.list.count != 10 && self.viewModel.data.list.count>0) {
             [self.defaultTableView.mj_footer setState:MJRefreshStateNoMoreData];
            ((MJRefreshAutoNormalFooter*)self_weak_.defaultTableView.mj_footer).stateLabel.text = @"已经全部加载完毕";

        }else if(self.list.count == 0){
            [self.defaultTableView showWithOutDataViewWithTitle:@"暂无数据"];
        }


        [self.defaultTableView reloadData];
    }];


    //定位获取
    [[Location shareInstance]startLocationSuccess:^(CLLocationCoordinate2D coordinate, NSString *cityName, NSString *address) {
        @strongify(self);
        self.viewModel.request.lat =[NSNumber numberWithDouble:[Location shareInstance].coordinate.latitude];
        self.viewModel.request.lon = [NSNumber numberWithDouble:[Location shareInstance].coordinate.longitude];

    } failed:^(NSString *errorMessage) {
        @strongify(self);
        self.viewModel.request.lat = nil;
        self.viewModel.request.lon = nil;

    } loactionPermissionErrorAlertShow:NO];



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

            self.viewModel.request.city_id = self.cityId;
            self.viewModel.request.level = _level;
            self.viewModel.request.order = _order;
            self.viewModel.request.limit = _limit;
            self.viewModel.request.page = _page;

            self.cityButton = [Tool createButtonWithTitle:self.areaName titleColor:BlackColor555555 target:self action:@selector(rightButtonTouch)];
            self.cityButton.titleLabel.font = FontOfSize(14);
            CGSize size = [self.cityButton systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            self.cityButton.frame = CGRectMake(0, 0, size.width, size.height);
            UIBarButtonItem*item = [[UIBarButtonItem alloc]initWithCustomView:self.cityButton];
            self.navigationItem.rightBarButtonItem = item;

            [self addjustButton:self.cityButton WithTitle:self.areaName];
            [self.defaultTableView.mj_header beginRefreshing];
        }
    }];

}


#pragma tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.delearTypeTableView]) {
        return self.storeListArray.count;
    }
    
    if ([tableView isEqual:self.defaultTableView]) {
        return self.list.count;
    }
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.delearTypeTableView]) {
        return 1;
    }
    
    if ([tableView isEqual:self.defaultTableView]) {
        return 1;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.delearTypeTableView]) {
        ReduceTypeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ReduceTypeTableViewCell) forIndexPath:indexPath];
        NSString*title =self.storeListArray[indexPath.row] ;
        
        [cell.titleButton setTitle:title forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([title isEqual:self.positionButton.titleLabel.text]) {
            cell.selected = YES;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            //        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        return cell;
    }
    
    if ([tableView isEqual:self.defaultTableView]) {
        ReduceCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ReduceCarTableViewCell) forIndexPath:indexPath];
        
        ReduceModel *model = self.list[indexPath.row];
        
        cell.model = model;
        cell.cityId = self.cityId;
        cell.city = self.cityButton.titleLabel.text;
        
        cell.carname.text = [NSString stringWithFormat:@"%@ %@",model.CAR_BRAND_TYPE_NAME,model.CAR_BRAND_SON_TYPE_NAME];
        
        cell.dearname.text = model.shortname;
        
        cell.redprice.text = [NSString stringWithFormat:@"%@万",model.promotion_price];
        
        NSString *factroy_value = [NSString stringWithFormat:@"%@万",model.manufacturer_price];
        
        NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:factroy_value];
        [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,factroy_value.length)];

        cell.normalprice.attributedText = attributeMarket;
        
        cell.loseprice.text = [NSString stringWithFormat:@"↓ 降%@万 | 降%@",model.discount_price,model.reducPre];
        
        
        if ([model.juli isNotEmpty]){
         
             cell.labelright.text = [NSString stringWithFormat:@" %@ ",model.juli];
//            [cell.labelright mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(cell.labelright.width+5);
//            }];
              [cell.labelright setHidden:NO];
            if ([model.orderrange isNotEmpty]) {
                cell.labelleft.text = [NSString stringWithFormat:@" %@ ",model.orderrange];
                [cell.labelleft setHidden:NO];
//                [cell.labelleft mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(cell.labelleft.width+5);
//                }];
            }else{
                [cell.labelleft setHidden:YES];
            }
        }else{
            if ([model.orderrange isNotEmpty]) {
                cell.labelright.text = [NSString stringWithFormat:@" %@ ",model.orderrange];
//                [cell.labelright mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(cell.labelright.width+5);
//                }];
                [cell.labelright setHidden:NO];
                [cell.labelleft setHidden:YES];
            }else{
                [cell.labelleft setHidden:YES];
                [cell.labelright setHidden:YES];
            }
        }
        
        [cell.iamge setImageWithURL:[NSURL URLWithString:model.PIC_URL] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.delearTypeTableView]) {
        return 50;
    }
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.delearTypeTableView]) {
        return 50;
    }
    
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.delearTypeTableView]) {
        switch (indexPath.row) {
            case 0:
            {
                self.viewModel.request.order = 1;
            }
                break;
            case 1:
            {
                self.viewModel.request.order = 2;
            }
                break;
            case 2:
            {
                self.viewModel.request.order = 3;
            }
                break;
            default:
                break;
        }
        
        if (!self.blackgroundView.hidden) {
            [self positionClick:self.positionButton];
        }
        
        [self.defaultTableView.mj_header beginRefreshing];
    }
    
    
    if ([tableView isEqual:self.defaultTableView]) {
        
        ReduceModel *model = self.list[indexPath.row];
        
        DealerCarInfoViewController *vc= [[DealerCarInfoViewController alloc] init];
        vc.dealerId = model.dealer_id;
        vc.carId = model.car_brand_son_type_id;
        vc.typeId = model.car_brand_type_id;
        [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
    }
}





#pragma 点击事件

-(void)handlTap{
    if (!self.blackgroundView.hidden) {
        [self.positionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)askChangePrice{
    [self.price removeAllObjects];
    [self.price addObject:[NSString stringWithFormat:@"%ld",(long)self.minPrice]];
    [self.price addObject:[NSString stringWithFormat:@"%ld",(long)self.maxPrice]];
    self.viewModel.request.price = self.price;
    [self.defaultTableView.mj_header beginRefreshing];
}

-(void)rightButtonTouch{
    CityViewController*vc = [[CityViewController alloc]init];
//    vc.citySelectedBlock = ^(AreaNewModel *cityModel) {
//                    if (![self.cityId isEqual:cityModel.id]) {
//                        self.cityId = cityModel.id;
//                        self.viewModel.request.city_id= self.cityId;
//                        [self addjustButton:self.cityButton WithTitle:cityModel.name];
//                        [self.defaultTableView.mj_header beginRefreshing];
//                    }
//    };
    [self.rt_navigationController pushViewController:vc animated:YES];
}



- (IBAction)brandClick:(id)sender {
    
    if (!self.blackgroundView.hidden) {
        [self.positionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.conditionPriceView.hidden) {
        [self.priceButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    
    self.redBrandVC.carID = self.viewModel.request.brand_id;
    self.redBrandVC.carTypeID = self.viewModel.request.son_type_id;
    
    @weakify(self);
    self_weak_.redBrandVC.parentBlock = ^(NSString *brandID,NSString *carID, NSString *carTypeID) {
        @strongify(self);
        self.viewModel.request.brand_id = brandID;
        self.viewModel.request.type_id = carID;
        self.viewModel.request.son_type_id = carTypeID;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.defaultTableView.mj_header beginRefreshing];
    };
    [self presentViewController:self.redBrandVC animated:YES completion:nil];
}

- (IBAction)priceButtonClicked:(UIButton *)sender {
    
    if (!self.blackgroundView.hidden) {
        [self.positionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    sender.selected = !sender.selected;
    if (sender.selected == YES) {

        NSString*title;
        
        if (self.viewModel.request.price.count >0) {
            int min = [self.viewModel.request.price[0] intValue];
            int max = [self.viewModel.request.price[1] intValue];
            
            if (max == 5) {
                title = @"5万以下";
            }else if(max == 9999 && min== 100){
                title = @"100万以上";
            }else if(max == 9999 && min == 0){
                
            }else{
                title = [NSString stringWithFormat:@"%d-%d万",min,max];
            }
        }
        
        @weakify(self);
        [self.conditionPriceView showWithPriceButtonTitleWithoutCount:title selctedBlock:^(NSInteger minPrice, NSInteger maxPrice) {
            @strongify(self);
            
            self.minPrice = minPrice;
            self.maxPrice= maxPrice;
            self.priceButton.selected = NO;
            [self.price removeAllObjects];
//            [self.viewModel.request.price removeAllObjects];
            [self.price addObject:[NSString stringWithFormat:@"%ld",(long)self.minPrice]];
            [self.price addObject:[NSString stringWithFormat:@"%ld",(long)self.maxPrice]];
            
            self.viewModel.request.price = self.price;
            
            [self.defaultTableView.mj_header beginRefreshing];
        } priceChangeBlock:^(NSInteger minPrice, NSInteger maxPrice) {
             @strongify(self);
            self.minPrice = minPrice;
            self.maxPrice= maxPrice;
        }cancelBlock:^{
             @strongify(self);
            self.priceButton.selected = NO;
        }];

    }else{
        [self.conditionPriceView dismiss];
    }
}

- (IBAction)typeClick:(id)sender {
    
    if (!self.blackgroundView.hidden) {
        [self.positionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!self.conditionPriceView.hidden) {
        [self.priceButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
 
    if (self.viewModel.request.level != 0 ) {
         self.brandVC.selectLevel = [NSString stringWithFormat:@"%ld",self.viewModel.request.level];
    }
   

    [self presentViewController:self.brandVC animated:YES completion:nil];
    
}

- (IBAction)positionClick:(UIButton*)sender {
    
    if (!self.conditionPriceView.hidden) {
        [self.priceButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    sender.selected = !sender.selected;
    
    bool selected =  sender.selected;
    if (selected) {
        self.delearTypeTableView.hidden = NO;
        self.blackgroundView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 150;
        }completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.delearTypeTableView.height = 0;
        }completion:^(BOOL finished) {
//            self.delearTypeTableView.hidden = YES;
            self.blackgroundView.hidden = YES;
        }];
    }
    
//    if (!self.shopPop) {
//        self.moreImage.image = [UIImage imageNamed:@"箭头向下"];
//    }else{
//        self.moreImage.image = [UIImage imageNamed:@"箭头向上"];
//    }
}

#pragma 懒加载
//-(FactoryListViewController *)brandVC{
//    if (!_brandVC) {
//        _brandVC = [[FactoryListViewController alloc]init];
//        _brandVC.controllerType = UIControllerCarLevel;
//        @weakify(self);
//        _brandVC.levelBlock = ^(NSString *level) {
//            @strongify(self);
//            self.viewModel.request.level = [level intValue];
//            [self.defaultTableView.mj_header beginRefreshing];
//        };
//    }
//    return _brandVC;
//}
//
//-(ReduceBrandSelectViewController *)redBrandVC{
//    if (!_redBrandVC) {
//        _redBrandVC = [[ReduceBrandSelectViewController alloc]init];
//
//    }
//    return _redBrandVC;
//}

-(NSMutableArray *)price{
    if (!_price) {
        _price = [NSMutableArray arrayWithCapacity:1];
    }
    return _price;
}

-(NSMutableArray<ReduceModel> *)list{
    if (!_list) {
        _list = [NSMutableArray<ReduceModel> arrayWithCapacity:1];
    }
    return _list;
}

-(ReduceViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [ReduceViewModel SceneModel];
    }
    return _viewModel;
}

-(UITableView *)delearTypeTableView{
    if (!_delearTypeTableView) {
        _delearTypeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _delearTypeTableView.delegate = self;
        _delearTypeTableView.dataSource = self;
        [self.blackgroundView addSubview:_delearTypeTableView];
        [_delearTypeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.blackgroundView);
            make.height.mas_equalTo(150);
        }];
        [_delearTypeTableView registerNib:nibFromClass(ReduceTypeTableViewCell) forCellReuseIdentifier:classNameFromClass(ReduceTypeTableViewCell)];
    }
    return _delearTypeTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
