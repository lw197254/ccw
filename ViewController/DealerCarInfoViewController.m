//
//  DealerCarInfoViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerCarInfoViewController.h"
#import "DearlerCarTableViewCell.h"
#import "DealerDetailTableViewHeaderFooterView.h"

#import "DealerCarViewModel.h"
#import "DealerCarPopUIView.h"
#import "PromotionConditionTableViewCell.h"
#import "ColorTableViewHeaderFooterView.h"

#import "ParameterConfigViewController.h"
#import "AskForPriceViewController.h"
#import "PhoneCallWebView.h"
#import "ParameterConfigSingleViewController.h"
@interface DealerCarInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgimage;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;
@property (weak, nonatomic) IBOutlet UILabel *downprice;
@property (weak, nonatomic) IBOutlet UILabel *pricearea;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *colorView;

#pragma 这便是弹出框
@property(nonatomic,strong)DealerCarPopUIView *popView;

@property(nonatomic,strong)DealerCarViewModel *dealerCarViewModel;



@end

@implementation DealerCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 0)];
    [self.view addSubview:view];
    
    [self setTitle:@"车辆详情"];
    [self initTable];
    [self initButtonView];
    [self initData];
}

-(void)initTable{
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
            self.automaticallyAdjustsScrollViewInsets = YES;
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.tableView.estimatedSectionFooterHeight=0;
    self.tableView.estimatedSectionHeaderHeight=0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //经销商
    [self.tableView registerNib:nibFromClass(DearlerCarTableViewCell) forCellReuseIdentifier:@"DearlerCarTableViewCell"];
    
    //条件
    [self.tableView registerClass:[PromotionConditionTableViewCell class] forCellReuseIdentifier:@"PromotionConditionTableViewCell"];
    
    [self.tableView registerClass:[DealerDetailTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"DealerDetailTableViewHeaderFooterView"];
    
    [self.tableView registerClass:[ColorTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"ColorTableViewHeaderFooterView"];
}

-(void)initData{
    self.dealerCarViewModel = [DealerCarViewModel SceneModel];
    self.dealerCarViewModel.request.dealerId = self.dealerId;
    self.dealerCarViewModel.request.carId = self.carId;
    self.dealerCarViewModel.request.typeId = self.typeId;
    self.dealerCarViewModel.request.startRequest = YES;
    
    UIView*view =  self.tableView.tableHeaderView;
    view.frame = CGRectMake(0, 0, kwidth, kwidth*3/4+225);
    self.tableView.tableHeaderView = view;
    
    @weakify(self);
    [[RACObserve(self.dealerCarViewModel, data)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.dealerCarViewModel.data.isNotEmpty;
     }]subscribeNext:^(id x) {
         @strongify(self);
         if (x) {
             [self initHeadView];
             [self.tableView reloadData];
         }
     }];
}


-(void)initHeadView{
    [self.bgimage setImageWithURL:[NSURL URLWithString:self.dealerCarViewModel.data.picurl] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.name.text = [NSString stringWithFormat:@"[%@] %@",self.dealerCarViewModel.data.brandName,self.dealerCarViewModel.data.carname];
    self.price.text = [NSString stringWithFormat:@"¥%@万",self.dealerCarViewModel.data.showPrice];
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@万",self.dealerCarViewModel.data.facPrice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    
    self.oldprice.attributedText =newPrice;
    
    self.downprice.text = [NSString stringWithFormat:@"¥%@万",self.dealerCarViewModel.data.reducePrice];
    
    self.pricearea.text = [NSString stringWithFormat:@"↓%@",self.dealerCarViewModel.data.reduceRate];
    
    [self initColorView];
}

-(void)initColorView{
    
    if (self.dealerCarViewModel.data.carcolor.count>0) {
        for (int i=0; i<self.dealerCarViewModel.data.carcolor.count; i++) {
            UIImageView *view = [[UIImageView alloc] init];
            [self.colorView addSubview:view];
            
            //添加边框
            CALayer * layer = [view layer];
            layer.borderColor = [BlackColorF8F8F8 CGColor];
            layer.borderWidth = 1.0f;
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.colorView);
                make.width.height.mas_equalTo(12);
                if (i==0) {
                     make.left.equalTo(self.colorView.mas_left);
                }else{
                     make.left.equalTo(self.colorView.mas_left).offset(5+12*i);
                }
            }];
            
            DealerColorModel *color = self.dealerCarViewModel.data.carcolor[i];
            NSString *info = color.value;
            NSMutableString  *a = [[NSMutableString alloc ] initWithString :[info substringFromIndex:1]];
            [a insertString:@"0x"  atIndex:0];
            
            [view setBackgroundColor:[UIColor colorWithString:a]];
        }
    }else{
        
        for (UIView *subviews in [self.colorView subviews]) {
            [subviews removeFromSuperview];
        }
        
        UILabel *view = [[UILabel alloc] init];
        [self.colorView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.colorView);
        }];

        view.textColor = BlackColor999999;
        view.font = FontOfSize(12);
        view.text = @"暂无";
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dealerCarViewModel.data.proinfo.length>0) {
            return 1;
        }else{
            return 0;
        }

    }else{
        return 1;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma  头部

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if (self.dealerCarViewModel.data.proinfo.length>0) {
                return 30;
            }else{
                return 0.0001;
            }
            break;
        case 1:
            if (self.dealerCarViewModel.data.proinfo.length>0) {
                return 10;
            }else{
                return 0.0001;
            }
        default:
            break;
    }
    return 0.00001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            if (self.dealerCarViewModel.data.proinfo.length>0) {
                ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
                view.label.text = @"优惠条件";
                [view.contentView setBackgroundColor:[UIColor whiteColor]];
                return view;
            }else{
                return nil;
            }

        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma  中部

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            PromotionConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionConditionTableViewCell" forIndexPath:indexPath];
            [cell setData:self.dealerCarViewModel.data.proinfo];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            DearlerCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DearlerCarTableViewCell" forIndexPath:indexPath];
            cell.dealer = self.dealerId;
            [cell setData:self.dealerCarViewModel.data.dealerinfo];
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (self.dealerCarViewModel.data.proinfo.length>0) {
                return UITableViewAutomaticDimension;
            }else{
                return 0.0001;
            }
        }
            break;
        case 1:
            return UITableViewAutomaticDimension;
            break;
        default:
            break;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (self.dealerCarViewModel.data.proinfo.length>0) {
                return 60;
            }else{
                return 60;
            }
        }
            break;
        case 1:
            return 140;
            break;
        default:
            break;
    }
    return 60;
}
#pragma 尾部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else if(section == 2){
        return 10;
    }
    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [[UIView alloc] init];
        return view;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///按钮
- (IBAction)showTable:(id)sender {
    if (self.button.isSelected) {
        [self.button setSelected:NO];
        self.popView.hidden = YES;
    }else{
        [self.button setSelected:YES];
        if(!self.popView){
        self.popView = [[DealerCarPopUIView alloc] init];
            self.popView.delearId = self.dealerId;
        [self.view addSubview:self.popView];
        [self.popView SetDataList:self.dealerCarViewModel.data.carinfo];
            
        [self.popView.close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
            
        [self.popView.button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
            
            @weakify(self)
        self.popView.CallService = ^(PromotionCarModel *model){
            @strongify(self)
            self.dealerCarViewModel.request.dealerId = self.dealerId;
            self.dealerCarViewModel.request.carId = model.carid;
            self.dealerCarViewModel.request.typeId = self.typeId;
            self.dealerCarViewModel.request.startRequest = YES;
            
            [self.button setSelected:NO];
            self.popView.hidden = YES;
        };
            
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        }
        self.popView.hidden = NO;

    }
}

- (IBAction)close:(id)sender {
    if (self.button.isSelected) {
        [self.button setSelected:NO];
        self.popView.hidden = YES;
    }else{
        [self.button setSelected:YES];
        if(!self.popView){
            self.popView = [[DealerCarPopUIView alloc] init];
            [self.view addSubview:self.popView];
            [self.popView SetDataList:self.dealerCarViewModel.data.carinfo];
            self.popView.delearId = self.dealerId;
            [self.button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
        self.popView.hidden = NO;
    }
}



///参数配置
- (IBAction)buttonGo:(id)sender {
    
//    ParameterConfigViewController *vc = [[ParameterConfigViewController alloc] init];
//    //vc.typeId = self.dealerCarViewModel.data.typeId;
//    vc.typeId = @"";
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [array addObject:self.dealerCarViewModel.data.carId];
//    vc.carIds = array;
//    [URLNavigation pushViewController:vc animated:YES];
    
    
    ParameterConfigSingleViewController*vc = [[ParameterConfigSingleViewController alloc]init];
    vc.carId = self.dealerCarViewModel.data.carId;
    vc.typeId = self.dealerCarViewModel.data.brandId;
    vc.carTypeName = [NSString stringWithFormat:@"%@ %@",self.dealerCarViewModel.data.brandName, self.dealerCarViewModel.data.carname];
    
    [self.rt_navigationController pushViewController:vc animated:YES];
}

-(void)askPrise:(UIButton *)sender{
    [ClueIdObject setClueId:xunjia_18];
    AskForPriceViewController *vc = [[AskForPriceViewController alloc] init];
    vc.delearId = self.dealerId;
    vc.carTypeId = self.carId;
    vc.carSerieasId = self.dealerCarViewModel.data.typeId;
    vc.carTypeName = self.dealerCarViewModel.data.carname;
    
    [URLNavigation pushViewController:vc animated:YES];
}

-(void)makeCall:(UIButton *)sender{
     [PhoneCallWebView showWithTel:self.dealerCarViewModel.data.dealerinfo.servicePhone];
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
