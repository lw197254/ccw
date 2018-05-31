//
//  CarDeptViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarDeptViewController.h"
#import "ButtonUIView.h"
#import "CarDeptViewModel.h"
#import "PicModel.h"
#import "SeeOthers.h"
#import "BuyCarCalculatorViewController.h"
#import "SellCarTableViewCell.h"
#import "CarDeptTableViewHeaderFooterView.h"
#import "CarTableViewHeaderFooterView.h"
#import "CarTypeDetailViewController.h"
#import "PhotoViewController.h"
#import "AskForPriceNewViewController.h"
#import "ParameterConfigViewController.h"
#import "PublicPraiseViewController.h"
#import "InformationViewController.h"
#import "KouBeiCarDeptModel.h"
#import "BrowseKouBeiCarDeptModel.h"
#import "MyUMShare.h"
#import "FindCarByGroupByCarTypeGetCarModel.h"
#import "CompareDict.h"
#import "CompareListViewController.h"
#import "DialogView.h"
#import "CustomTableViewHeaderSectionView.h"

#import "CityViewController.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"
#import "CarDeptDealerViewController.h"

#import "SubjectAndSaveObject.h"
#import "MyOwnShareView.h"

#import "Location.h"
#import "CustomAlertView.h"
#import "CheckCityBytime.h"

#define footerButtonTag 10000
#define headerButtonTag 10001
#define sectionTag 1000


///真正的数据列表从FirstSection开始
#define FirstSection 1

@interface CarDeptViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *pics;
@property (weak, nonatomic) IBOutlet UILabel *cartype;
@property (weak, nonatomic) IBOutlet UIImageView *saveImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *labelViewHolder;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property(nonatomic,strong)UILabel *firtslabel;
///上面的询价按钮
@property (weak, nonatomic) IBOutlet UIButton * xunJiaButton;
@property(nonatomic,strong)NSMutableArray *labelList;
@property(nonatomic,strong)NSMutableArray *buttonViewList;
@property (weak, nonatomic) IBOutlet UILabel *carpaiming;

@property(nonatomic,strong)CarTableViewHeaderFooterView *footer;

@property(nonatomic,strong)CarDeptViewModel *model;
///在售
@property(nonatomic,strong)NSArray<CarOnOffSale> *carOnSale;
///停售
@property(nonatomic,strong)NSArray<CarOnOffSale> *carOffSale;
///在售
@property(nonatomic,strong)NSArray<CarOnOffSale> *carsSale;
/////推荐车系
//@property(nonatomic,strong)NSArray<SeeOthers*> *seeOthers;

@property(nonatomic,strong)UIImageView *topImage;

@property(nonatomic,assign)BOOL rightclick;

//底部的询价
@property (weak, nonatomic) IBOutlet UIButton * xunJia;


@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *PKCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property(strong,nonatomic)UIImageView *bgChexi;
@property (weak, nonatomic) IBOutlet UIButton *PKButton;
@property(copy,nonatomic)NSString *cityId;
@property (weak, nonatomic) IBOutlet UIButton *customBackButton;
@property (weak, nonatomic) IBOutlet UIView *customNavigationView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBottomLineView;
@property(nonatomic,strong) UIImageView *topBlackImage;
///头部信息 头部在售和停售
@property(nonatomic,strong) CarDeptTableViewHeaderFooterView *headview;

@property(nonatomic,strong) SubjectAndSaveObject *subjectObject;

@property(nonatomic,strong) MyOwnShareView *shareView;

@end

@implementation CarDeptViewController

-(MyOwnShareView *)shareView{
    if(!_shareView){
        _shareView = [[MyOwnShareView alloc] init];
    }
    return _shareView;
}
-(CGFloat)topOffSet{
    if (IOS_11_OR_LATER) {
        return 64;
    }else{
        return 64;
    }
}
-(SubjectAndSaveObject *)subjectObject{
    if (!_subjectObject) {
        _subjectObject = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectObject;
}

-(CGFloat)headBackgroundImageHeight{
    return kwidth*3.0/4 ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager*manger = [AFHTTPSessionManager manager];
    @weakify(self);

  
   
    self.block = ^(NSString *name) {
        @strongify(self);
         self.cityId = @"1111";
    };
    [[GCDQueue globalQueue]queueBlock:^{
       self.block(@"name");
        NSLog(@"________%@",self.cityId);
        
        //        }];
    } afterDelay:10];
   
    
    [self.customNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(44+StatusHeight);
    }];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (IOS_11_OR_LATER) {
        self.tableView.contentInset = UIEdgeInsetsMake(44-[UIApplication sharedApplication].statusBarFrame.size.height+20, 0, 0, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    
//    self.tableView.contentInset = UIEdgeInsetsMake([self topOffSet ], 0, 0, 0);
    // Do any additional setup after loading the view.
    self.topImage = [[UIImageView alloc] init];
   
    self.rightclick = NO;
    //去除点击效果
    [self.favouriteButton setHighlighted:NO];
    
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    [self.firstView addSubview:self.topImage];
    [self.firstView sendSubviewToBack:self.topImage];
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView).with.offset(-[self topOffSet]);
        make.left.right.equalTo(self.firstView);
        make.height.mas_equalTo([self headBackgroundImageHeight]);
    }];

    [self.topImage setImage:[UIImage imageNamed:@"默认图片105_80"]];
    
    
    
    self.footer = [[CarTableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 210)];
    
    
    
    self.bgChexi = [[UIImageView alloc] init];
    self.bgChexi.image = [UIImage imageNamed:@"bg_chexi"];
    [self.firstView insertSubview:self.bgChexi aboveSubview:self.topImage];
    
    
    
    //头部加入黑色萌版
    self.topBlackImage= [[UIImageView alloc] init];
    self.topBlackImage.image = [UIImage imageNamed:@"nav_bar"];
    
    [self.firstView addSubview:self.topBlackImage];
    
    [self.topBlackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(69);
        make.right.left.equalTo(self.firstView);
        make.top.equalTo(self.topImage);
    }];
    
    //透明背景
    [self.bgChexi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.firstView);
        make.bottom.equalTo(self.labelViewHolder.mas_top);
        make.height.mas_equalTo(70);
 
    }];
//    //将数据加入到透明背景
//    [self.bgChexi addSubview:self.carName];
//    [self.bgChexi addSubview:self.price];
//    [self.bgChexi addSubview:self.pics];
//    [self.bgChexi addSubview:self.cartype];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonView:)];
    
    //大图事件
    self.firstView.tag = 0;
    [self.firstView addGestureRecognizer:tapRecognizer];
    
    //询价按钮
    self.xunJia.tag = footerButtonTag;
    [self.xunJia addTarget:self action:@selector(searchPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.xunJia setBackgroundImage:[UIImage imageWithColor:BlueColorD5E3FF] forState:UIControlStateDisabled];
    //询底价加入头部的button线
       
    [self initButton];
    [self initFourButton];
    //[self initWordPrice];
    [self initCarSell];
   
    
   
//       UIView*view1 = self.tableView.tableHeaderView;
//    view1.frame = CGRectMake(0, 0, kwidth, kwidth*3.0/4+120);
//    self.tableView.tableHeaderView = view1;

    self.tableView.tableFooterView = self.footer;
    

    
   [self initData];
    /// 重设tableviewheaderview
    CGRect frame =  self.tableView.tableHeaderView.frame;
    frame.size.height = 194/2+[self headBackgroundImageHeight]-[self topOffSet];
    UIView*view =self.tableView.tableHeaderView;
    view.frame = frame;
    self.tableView.tableHeaderView = view;
    
    [self showCityAlert];
    
}

//-(void)showRightButton{
//     [self.backButton setImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
////    //头部两个按钮
//    
//        self.shareButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"shareWhite"]];
//    
//        self.shareButton .tag = 0;
//        [self.shareButton  addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        self.PKButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"PKWhite"]];
//    [self.PKButton addTarget:self action:@selector(PKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    NSInteger count = [CompareDict shareInstance].count;
//    
//    self.PKCountLabel = [Tool createLabelWithTitle:[NSString stringWithFormat:@"%lu",count] textColor:[UIColor whiteColor] tag:0];
//    self.PKCountLabel.textAlignment = NSTextAlignmentCenter;
//    self.PKCountLabel.font = FontOfSize(9);
//   
//    self.PKCountLabel.layer.masksToBounds = YES;
//    self.PKCountLabel.backgroundColor = [UIColor redColor];
//    NSInteger labelWidth = 12;
//    self.PKCountLabel.layer.cornerRadius = labelWidth/2;
//    NSInteger buttonWidth = 25;
//    self.PKButton.frame = CGRectMake(labelWidth/2, labelWidth/2, buttonWidth, buttonWidth);
//     self.PKCountLabel.frame = CGRectMake(buttonWidth-labelWidth/2, labelWidth/2, labelWidth, labelWidth);
//    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth+labelWidth/2, buttonWidth+labelWidth/2)];
//    [view addSubview:_PKButton];
//    [view addSubview:_PKCountLabel];
//    
//    if (!self.cityButton) {
//        
//        self.cityButton = [[UIButton alloc]initNavigationButtonWithTitle:@"" color:BlackColor333333 font:FontOfSize(14)];
//        [self.cityButton addTarget:self action:@selector(cityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        self.cityButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
//        //self.cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
//        
//    }
//
//        self.favouriteButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"favouriteWhite.png"]];
//    self.favouriteButton.tag = 1;
//        [self.favouriteButton setImage:[UIImage imageNamed:@"favouriteYellow.png"] forState:UIControlStateSelected];
//        [self.favouriteButton setImage:[UIImage imageNamed:@"favouriteYellow.png"] forState:UIControlStateHighlighted];
//        [self.favouriteButton addTarget:self action:@selector(favouriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
////        NSArray *records = [KouBeiCarDeptModel findByColumn:@"colId" value:self.chexiid];
////        if ( [records count] ) {
////            self.favouriteButton.selected = YES;
////        }
//    self.favouriteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//     self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//     self.PKButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    self.favouriteButton.userInteractionEnabled = NO;
//    self.shareButton.userInteractionEnabled = NO;
//     UIBarButtonItem*PKItem = [[UIBarButtonItem alloc]initWithCustomView:view];
//    UIBarButtonItem*shareItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
//    UIBarButtonItem*favouriteItem = [[UIBarButtonItem alloc]initWithCustomView:self.favouriteButton];
//    
//    
//    
//    UIBarButtonItem*cityItem = [[UIBarButtonItem alloc]initWithCustomView:self.cityButton];
//    
//    
//    self.navigationItem.rightBarButtonItems =@[cityItem,shareItem,favouriteItem,PKItem];
//
//    
//    
//}

//初始化按钮
-(void)initButton{

    self.xunJiaButton.tag = headerButtonTag;
    [self.xunJiaButton addTarget:self action:@selector(searchPriceClicked:) forControlEvents:UIControlEventTouchUpInside];

    

}

-(void)initFourButton{
    
     NSArray *stringlist = @[@{@"name":@"图片",@"pic":@"图片"},@{@"name":@"配置",@"pic":@"配置"},@{@"name":@"经销商",@"pic":@"经销商_n"},@{@"name":@"口碑",@"pic":@"口碑"},@{@"name":@"资讯",@"pic":@"资讯"}];
    self.buttonViewList = [[NSMutableArray alloc] init];
    for (int i=0; i<stringlist.count; i++) {
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonView:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        
        if(i==0){
            ButtonUIView *buttonCustom = [[ButtonUIView alloc] init];
            
            buttonCustom.imageView.image = [UIImage imageNamed:stringlist[i][@"pic"]];
            buttonCustom.label.text =stringlist[i][@"name"];
            buttonCustom.label.font = FontOfSize(13);
            buttonCustom.label.textColor = BlackColor555555;
            [self.labelViewHolder addSubview:buttonCustom];
            [self.buttonViewList addObject:buttonCustom];
           
            [buttonCustom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kwidth/stringlist.count);
             
                make.top.bottom.left.equalTo(self.labelViewHolder);
            }];
            
            buttonCustom.tag = i;
            [buttonCustom addGestureRecognizer:tapRecognizer];
        }else{
            ButtonUIView *temp = self.buttonViewList[i-1];
            ButtonUIView *buttonCustom = [[ButtonUIView alloc] init];
            buttonCustom.imageView.image = [UIImage imageNamed:stringlist[i][@"pic"]];
            buttonCustom.label.text = stringlist[i][@"name"];
            buttonCustom.label.textColor = BlackColor333333;
            [self.labelViewHolder addSubview:buttonCustom];
            [self.buttonViewList addObject:buttonCustom];
            [buttonCustom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kwidth/stringlist.count);
                make.top.bottom.equalTo(self.labelViewHolder);
               
                make.left.equalTo(temp.mas_right);
            }];
            buttonCustom.tag =i;
            [buttonCustom addGestureRecognizer:tapRecognizer];
        }
        
        
     }
}

-(void)buttonView:(UITapGestureRecognizer*)tap{
    
   
    switch (tap.view.tag) {
        case 0:{
            // 无图片无法点击
            
            if (self.model.data.hasPic==NO ) {
                return ;
            }
            
            PhotoViewController *controller = [[PhotoViewController alloc] init];
            controller.carId = @"";
            controller.typeId = self.model.data.car_brand_type_id;
            
            controller.carName = self.model.data.car_model_name;
            controller.carType = self.model.data.car_brand_type_name;
            controller.carPrice = self.model.data.zhidaoPrice;
            [URLNavigation pushViewController:controller animated:YES];
            break;
        }

        case 1:{
            ParameterConfigViewController *controller = [[ParameterConfigViewController alloc] init];
            controller.typeId = self.model.data.car_brand_type_id;
            [URLNavigation pushViewController:controller animated:YES];
            break;
          
          
        }
       
        case 2:{
            CarDeptDealerViewController *controller = [[CarDeptDealerViewController alloc] init];
            controller.brandId = self.chexiid;
            [URLNavigation pushViewController:controller animated:YES];
            break;
        }
        case 3:{
            PublicPraiseViewController *controller = [[PublicPraiseViewController alloc] init];
            controller.catTypeId = self.model.data.car_brand_type_id;
            controller.carSeriesName = self.model.data.car_brand_type_name;
            [URLNavigation pushViewController:controller animated:YES];
            break;
        }
        case 4:{
            InformationViewController*infor = [[InformationViewController alloc]init];
            infor.carSeriesId = self.chexiid;
            [self.rt_navigationController pushViewController: infor animated:YES];
            break;
        }


           
        default:
            break;
    }
}

-(void)initWordPrice{
    //第一部分
    //左边
    self.firtslabel = [[UILabel alloc]init];
    self.firtslabel.text = @"口碑印象";
    self.firtslabel.font = FontOfSize(16);
    self.firtslabel.textColor = BlackColor333333;
    
    [self.view addSubview:self.firtslabel];
    [self.firtslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).offset(10);
    }];
    
    //右边
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.text = @"全部";
    button.titleLabel.textColor = [UIColor blackColor];;
    button.titleLabel.font = FontOfSize(12);
    
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(10);
    }];
    
    UIView *labelViewGroup = [[UIView alloc] init];
    [self.view addSubview:labelViewGroup];
    
    [labelViewGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(10);
    }];
    
    self.labelList = [[NSMutableArray alloc]init];
    
    for (int i =0; i<5; i++) {
        UILabel *label = [self buildBlueLabel:@"text"];
    
        [self.view addSubview:label];
        
        if(self.labelList == nil || self.labelList.count == 0){
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firtslabel.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(15);
            }];
            [self.labelList addObject:label];
        }else{
            UILabel *temp_label = self.labelList[i-1];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.firtslabel.mas_bottom).offset(10);
                make.left.equalTo(temp_label.mas_right).offset(15);
            }];
            [self.labelList addObject:label];
        }
    }
}

-(UILabel *)buildBlueLabel:(NSString *)info{
    UILabel *label = [[UILabel alloc] init];
    label.text = info;
    label.font = FontOfSize(12);
    label.textColor = BlueColor447FF5;
    //边框
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderColor = BlueColor447FF5.CGColor;
    label.layer.borderWidth = 0.5f;
    label.layer.masksToBounds = YES;
    
//    NSMutableParagraphStyle *
//    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.headIndent = 2;//头部缩进，相当于左padding
//    style.tailIndent = 2;//相当于右padding

    return label;
}

-(void)initCarSell{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   

    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[CustomTableViewHeaderSectionView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
    [self.tableView registerNib:[UINib nibWithNibName:@"SellCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"SellCarTableViewCell"];
    
}

-(void)initData{
    if (!self.model) {
        self.model = [CarDeptViewModel SceneModel];
    }
    
   
   self.model.request.chexiId =  self.chexiid;
    @weakify(self);
   
    [[RACObserve([AreaNewModel shareInstanceSelectedInstance],id)filter:^BOOL(id value) {
        return [AreaNewModel shareInstanceSelectedInstance].id.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        if (![self.cityId isEqual:[AreaNewModel shareInstanceSelectedInstance].id]) {
            self.cityId = [AreaNewModel shareInstanceSelectedInstance].id;
            
            self.model.request.city_id = self.cityId;
            self.model.request.startRequest = YES;
            
            
        }
      
    }];
    
 
    [[RACObserve([AreaNewModel shareInstanceSelectedInstance],name)filter:^BOOL(id value) {
        return [AreaNewModel shareInstanceSelectedInstance].name.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.cityButton setTitle:[AreaNewModel shareInstanceSelectedInstance].name forState:UIControlStateNormal];
//        [self addjustButton:self.cityButton WithTitle:[AreaNewModel shareInstanceSelectedInstance].name];
    }];


    [[RACObserve(self.model.request,state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.model.request.failed;
      }]
     subscribeNext:^(id x) {
          @strongify(self);
         self.xunJia.userInteractionEnabled = NO;
         self.favouriteButton.userInteractionEnabled = NO;
         self.shareButton.userInteractionEnabled = NO;
    [self.tableView showNetLost];
     }];
    [[RACObserve(self.model,data)
    filter:^BOOL(id value) {
        @strongify(self);
        return self.model.data.isNotEmpty;
    }]
    subscribeNext:^(id x) {
        @strongify(self);
        self.rightclick = false;
        [self.tableView dismissWithOutDataView];
        self.xunJia.userInteractionEnabled = YES;
        self.favouriteButton.userInteractionEnabled = YES;
        self.shareButton.userInteractionEnabled = YES;
        self.carName.text  = self.model.data.car_brand_type_name;
        
        NSString *cartype = self.model.data.car_model_name;
        cartype = [cartype stringByAppendingString:@"/"];
        cartype = [cartype stringByAppendingString:self.model.data.engine];
        self.cartype.text = cartype;
        
        
        if (![self.model.data.zhidaoPrice isEqualToString:@"暂无报价"]) {
            NSString *price  =@"厂商指导价: ¥";
            self.price.text = [price stringByAppendingString:self.model.data.zhidaoPrice];
        }else{
            self.price.text = @"暂无报价";
        }
        
        
        
        self.carpaiming.text = [NSString stringWithFormat:@"(%@关注度排名第%@名)",self.model.data.car_model_name,self.model.data.hot];
        
        
        NSString *total = @"共";
        total = [total stringByAppendingString:self.model.data.pic_count];
        total = [total stringByAppendingString:@"张图"];
        self.pics.text = total;
        
        
        PicModel *pic = self.model.data.picture;
        [self.topImage setImageWithURL:[NSURL URLWithString:pic.bigpic] placeholderImage:[UIImage imageNamed:@"默认图片330_165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        
        
        if ([self.footer isEqual:nil]) {
            self.footer = [[CarTableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 270-15)];
        }
        self.footer.seeothers = self.model.data.seeOthers;
        
        self.carOnSale = self.model.data.carOnSale;
        self.carOffSale = self.model.data.carOffSale;
        
        self.carsSale =self.carOnSale;
        
        NSArray *browes = [BrowseKouBeiCarDeptModel findByColumn:@"id" value:self.chexiid];
        
        if ( ![browes count] ) {
            [self saveBrowseModel];
        }else{
            [self deleteBrowesModel:browes[0]];
            [self saveBrowseModel];
        }
        
        if (self.model.data.hasKoubei==NO ) {
            [self reBuildKouBei];
        }
        
        if (self.model.data.hasPic==NO ) {
            [self picButtonDisable];
        }
        if (self.model.data.hasParam==NO ) {
            [self parogarmButtonDisable];
        }
        if (self.model.data.hasArt==NO ) {
            [self infoButtonDisable];
        }
        if (self.model.data.hasDealer==NO ) {
            [self DealerButtonDisable];
        }
        [self.tableView reloadData];
       
       [self scrollViewDidScroll:self.tableView];
    }];
}


//重置口碑颜色
-(void)reBuildKouBei{
    ButtonUIView *temp = self.buttonViewList[3];
    temp.imageView.image = [UIImage imageNamed:@"口碑_d"];
    temp.label.textColor = BlackColor999999;
    //10 只是随机一个数子，点击方法直接无效
    temp.tag = 10;
}
//重置图片颜色
-(void)picButtonDisable{
    ButtonUIView *temp = self.buttonViewList[0];
    temp.imageView.image = [UIImage imageNamed:@"图片_d"];
    temp.label.textColor = BlackColor999999;
    //10 只是随机一个数子，点击方法直接无效
    temp.tag = 10;
}
//重置配置颜色
-(void)parogarmButtonDisable{
    ButtonUIView *temp = self.buttonViewList[1];
    temp.imageView.image = [UIImage imageNamed:@"配置_d"];
    temp.label.textColor = BlackColor999999;
    //10 只是随机一个数子，点击方法直接无效
    temp.tag = 10;
}
//重置咨询颜色
-(void)infoButtonDisable{
    ButtonUIView *temp = self.buttonViewList[4];
    temp.imageView.image = [UIImage imageNamed:@"资讯_d"];
    temp.label.textColor = BlackColor999999;
    //10 只是随机一个数子，点击方法直接无效
    temp.tag = 10;
}
//重置咨询颜色
-(void)DealerButtonDisable{
    ButtonUIView *temp = self.buttonViewList[2];
    temp.imageView.image = [UIImage imageNamed:@"经销商_d"];
    temp.label.textColor = BlackColor999999;
    //10 只是随机一个数子，点击方法直接无效
    temp.tag = 10;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section<FirstSection) {
        return 0;
    }
    CarOnOffSale*sale = self.carsSale[section-FirstSection];
    return sale.carlist.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.carOnSale.count >0){
        return self.carsSale.count+FirstSection;
    }else{
        if (self.carOffSale.count!=0) {
            self.carsSale =[self.carOffSale mutableCopy];
            return  self.carsSale.count + FirstSection;
        }
        return  0;
    }

   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < FirstSection) {
        return nil;
    }
    
    
    
        
        CarOnOffSale *model = self.carsSale[indexPath.section-FirstSection];
    
        SellCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellCarTableViewCell" forIndexPath:indexPath];
        CarOnOffTypeModel*car = model.carlist[indexPath.row];
        cell.title.text = car.name;
    
        cell.compareButton.tag =  indexPath.row+sectionTag*(indexPath.section-FirstSection);
    

    

    
        //厂商的报价
        if([car.factory_price isNotEmpty]&&[car.factory_price integerValue] != 0){
            NSString *price = @"￥";
            price = [price stringByAppendingString:car.factory_price];
            cell.price.text = [price stringByAppendingString:@"万"];
            
            cell.buyCarCalculatorButton.tag = indexPath.row+sectionTag*(indexPath.section-FirstSection);
            UIImage*image =[UIImage imageNamed:@"计算器"] ;
            [cell.buyCarCalculatorButton  setImage:image forState:UIControlStateNormal];
            //            [cell.buyCarCalculatorButton setBackgroundColor:[UIColor whiteColor]];
            [cell.buyCarCalculatorButton setImage:[UIImage imageNamed:@"计算器选中"] forState:UIControlStateHighlighted];
            [cell.buyCarCalculatorButton addTarget:self action:@selector(BuyCarCalculatorClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self setCellSearchButton:cell.searchPrice enable:YES];
        }else{
            cell.price.text = @"暂无报价";
            [self setCellSearchButton:cell.searchPrice enable:NO];
            
            UIImage*image =[UIImage imageNamed:@"计算器disable"] ;
            [cell.buyCarCalculatorButton  setImage:image forState:UIControlStateNormal];
//            [cell.buyCarCalculatorButton setBackgroundColor:[UIColor whiteColor]];
            [cell.buyCarCalculatorButton setImage:image forState:UIControlStateHighlighted];
            [cell.buyCarCalculatorButton removeTarget:self action:@selector(BuyCarCalculatorClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //自己的报价
        if(car.dealer_price.isNotEmpty&&[car.dealer_price integerValue] != 0){
            NSString *price = @"￥";
            price = [price stringByAppendingString:car.dealer_price];
            cell.myPrice.text = [price stringByAppendingString:@"万"];
        }else{
            cell.myPrice.text = @"暂无报价";
        }
        cell.searchPrice.tag = indexPath.row+sectionTag*(indexPath.section-FirstSection);
    
    
        
        
        if(!car.dealer_price.isNotEmpty&&car.has_dealer ==NO){
            //手动切换颜色
//            [self buildNotSaleButtonImage:cell.searchPrice];

        }else{
            cell.myPrice.hidden =NO;
            cell.reference.hidden =NO;
           
            
            
//            [self buildButtonImage:cell.searchPrice];
        }
    
        CompareDict*dict = [CompareDict shareInstance] ;
        if ([dict objectForKey:car.id]) {
            [cell.compareButton setImage:[UIImage imageNamed:@"PK不可用.png"] forState:UIControlStateHighlighted];
            [cell.compareButton setImage:[UIImage imageNamed:@"PK不可用.png"] forState:UIControlStateNormal];
            [cell.compareButton removeTarget:self action:@selector(compareClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.compareButton addTarget:self action:@selector(compareClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.compareButton setImage:[UIImage imageNamed:@"PK可用选中.png"] forState:UIControlStateHighlighted];
            [cell.compareButton setImage:[UIImage imageNamed:@"PK可用.png"] forState:UIControlStateNormal];
        }

        
        //[self setline:cell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
   
}
-(void)setCellSearchButton:(UIButton*)button enable:(BOOL)enable{
    if (enable) {
        [button setBackgroundImage:[UIImage imageWithColor:BlueColorF5F8FE] forState:UIControlStateNormal];
        [button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(searchPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = BlueColor447FF5.CGColor;
    }else{
        [button setBackgroundImage:[UIImage imageWithColor:BlueColorF5F8FE] forState:UIControlStateNormal];
        [button setTitleColor:BlackColor999999 forState:UIControlStateNormal];
        
        [button removeTarget:self action:@selector(searchPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = BlueColorD1E1FF.CGColor;
    }
}

////车系为可点击 在售状态
//-(void)buildButtonImage:(UIButton *)button{
//    UIImage *buttonImageNomal=[UIImage imageNamed:@"bnt_xundijia_n"];
//
//    [button setBackgroundImage:buttonImageNomal forState:UIControlStateNormal];
//    UIImage *imageButtonPress=[UIImage imageNamed:@"bnt_xundijia_s"];
//    [button setBackgroundImage:imageButtonPress forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(searchPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
//}

////车系为不可点击 停售状态 点击询价无效
//-(void)buildNotSaleButtonImage:(UIButton *)button{
//    button.hidden = YES;
//    UIImage *buttonImageNomal=[UIImage imageNamed:@"bnt_xundijia_d"];
//    [button setBackgroundImage:buttonImageNomal forState:UIControlStateNormal];
//    button.userInteractionEnabled =NO;
//}

//加入比较
-(void)compareClicked:(UIButton*)button{
        if(CompareMaxCount == [CompareDict shareInstance].count){
            [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"最多支持%d款车型！",CompareMaxCount] ];
            return;
        }
    [button setImage:[UIImage imageNamed:@"PK不可用.png"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"PK不可用.png"] forState:UIControlStateNormal];
    [button removeTarget:self action:@selector(compareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
        NSInteger section = button.tag/sectionTag;
        NSInteger row = button.tag - section*sectionTag;
         CarOnOffSale *onOffmodel = self.carsSale[section];
        CarOnOffTypeModel*car = onOffmodel.carlist[row];
        FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel alloc]init];
        model.car_id = car.id;
        
        model.car_name = [NSString stringWithFormat:@"%@ %@",self.model.data.car_brand_type_name, car.name];
        model.factory_price = car.factory_price;
        
         [[CompareDict shareInstance] setObject:model forKey:car.id];
    CompareListViewController*vc = [[CompareListViewController alloc]init];
        [vc editCompareSlectedDictWithModel:model isDelete:NO];
        [model save];
        if([CompareDict shareInstance].count == 0){
            self.PKCountLabel.hidden = YES;
        }else{
            self.PKCountLabel.hidden = NO;
            self.PKCountLabel.text =[NSString stringWithFormat:@"%lu",  [CompareDict shareInstance].count];
        }
    
    
    SellCarTableViewCell*cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section+FirstSection]];
    
    CGRect frame = [cell convertRect:cell.compareButton.frame toView:self.view];
    UIButton*newButton = [Tool createButtonWithImage:button.imageView.image target:nil action:nil tag:0];
     newButton.frame = frame;
    [self.view addSubview:newButton];
   
    [newButton layoutIfNeeded];
    
    CGRect pkFrame = [self.customNavigationView convertRect:self.PKButton.frame toView:self.view];
//    newButton.frame = CGRectMake(pkFrame.origin.x, frame.origin.y, frame.size.width/2, frame.size.height/2);
//    [UIView animateWithDuration:0.5 animations:^{
//    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            newButton.center =  CGPointMake(pkFrame.origin.x+pkFrame.size.width/2, pkFrame.origin.y+pkFrame.size.height/2);
            newButton.frame = CGRectMake(pkFrame.origin.x+pkFrame.size.width/2, pkFrame.origin.y+pkFrame.size.height/2, frame.size.width/2, frame.size.height/2);
            //newButton.bounds = CGRectMake(0, 0, 0, 0);
        }completion:^(BOOL finished) {
            
            [newButton removeFromSuperview];
             [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"车型添加成功"] ];
        }];
        
//    }];

    
//        CompareListViewController*vc = [[CompareListViewController alloc]init];
//        [self.rt_navigationController pushViewController:vc animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    CarTypeDetailViewController*vc = [[CarTypeDetailViewController alloc]init];
    
    CarOnOffSale *onOffmodel = self.carsSale[indexPath.section-FirstSection];
    CarOnOffTypeModel*car = onOffmodel.carlist[indexPath.row];
    vc.chexingId = car.id;
    [self.rt_navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < FirstSection) {
        return 0;
    }
    
//    CarOnOffSale *onOffmodel = self.carsSale[indexPath.section-FirstSection];
//    if (onOffmodel.carlist.count-1 == indexPath.row&&indexPath.section-FirstSection!=self.carsSale.count-1) {
//        ///每一个分组的最后一个高度去掉10，
//        return (156+80+20)/2;
//    }
    return 143;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < FirstSection) {
        return 0;
    }
    return 143;
}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if(section == self.carsSale.count){
//        return self.footer;
//    }
//    
//    return nil;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section < FirstSection){
        return [self buildview];
    }else{
        CustomTableViewHeaderSectionView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
        view.topLine.hidden = YES;
        view.middleLine.hidden = YES;
        view.bottomLine.hidden = YES;
        view.titleLabel.font = FontOfSize(12);
        view.titleLabel.textColor = BlackColor333333;
        view.backgroundColor = BlackColorF1F1F1;
      CarOnOffSale*model = self.carsSale[section-FirstSection];
        if(self.carsSale == self.carOffSale){
            view.titleLabel.text = [model.title stringByAppendingString:@"(停售)"];
        }else{
            view.titleLabel.text = model.title;
        }
        
        return view;
    }
    
}



-(CarDeptTableViewHeaderFooterView *)buildview{
    
    if(self.carOnSale.count>0 && self.carOffSale.count>0){
        self.headview.label.text = @"在售";
        self.headview.label.font = FontOfSize(15);
        self.headview.secondLabel.text = @"停售";
        self.headview.secondLabel.font = FontOfSize(15);
        
        [self.headview.label1 setHidden:NO];
        [self.headview.label2 setHidden:YES];
        
    }else if(self.carOnSale.count>0 && self.carOffSale.count <=0){
        self.headview.label.text = @"在售";
        self.headview.label.font = FontOfSize(15);
        self.headview.secondLabel.hidden = YES;
        [self.headview.label1 setHidden:NO];
        [self.headview.label2 setHidden:YES];
    }else if(self.carOnSale.count <=0 && self.carOffSale.count>0){
        self.headview.label.text = @"停售";
        self.headview.label.font = FontOfSize(15);
        self.headview.secondLabel.hidden = YES;
        [self.headview.label1 setHidden:YES];
        [self.headview.label2 setHidden:NO];

    }
    
   
  
    if(self.rightclick){
        [self.headview.label1 setHidden:YES];
        [self.headview.label2 setHidden:NO];
        self.headview.label.textColor =BlackColor999999;
        self.headview.secondLabel.textColor =BlackColor333333;
    }else{

        [self.headview.label1 setHidden:NO];
        [self.headview.label2 setHidden:YES];
        self.headview.label.textColor =BlackColor333333;
        self.headview.secondLabel.textColor =BlackColor999999;
    }


    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    
    UITapGestureRecognizer *tapRecognizer_temp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    
    self.headview.label.tag = 0;
    [self.headview.label addGestureRecognizer:tapRecognizer];
    self.headview.label.userInteractionEnabled =YES;
    
    self.headview.secondLabel.tag = 1;
    [self.headview.secondLabel addGestureRecognizer:tapRecognizer_temp];
    self.headview.secondLabel.userInteractionEnabled =YES;
    
    
    UITapGestureRecognizer *tapRecognizer_temp1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    
    self.headview.moreRightLabel.tag = 100;
    [self.headview.moreRightLabel addGestureRecognizer:tapRecognizer_temp1];
    self.headview.moreRightLabel.userInteractionEnabled =YES;
    
    return self.headview;

}


-(void)handlTap:(UITapGestureRecognizer*)tap{
    
    if (tap.view.tag == 0) {
        [self.headview.label1 setHidden:NO];
        [self.headview.label2 setHidden:YES];
            self.rightclick = false;
        self.carsSale =self.carOnSale ;
        [self.tableView reloadData];
    
    }else if(tap.view.tag == 100){
        PublicPraiseViewController *controller = [[PublicPraiseViewController alloc] init];
        controller.catTypeId = self.model.data.car_brand_type_id;
        controller.carSeriesName = self.model.data.car_brand_type_name;
        [URLNavigation pushViewController:controller animated:YES];
      
    }else{
        [self.headview.label1 setHidden:YES];
        [self.headview.label2 setHidden:NO];
        self.rightclick = true;
        self.carsSale = self.carOffSale ;
        [self.tableView reloadData];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if(section <FirstSection&&(self.carOnSale.count != 0 || self.carOffSale.count != 0)){
        if (self.model.data.repTag.count == 0) {
            return 0;
        }else{
            return self.headview.height ;
        }
    }else if(section ==self.carsSale.count&&self.carsSale.count!=0){
       
        return 26;
    }else if(section !=self.carsSale.count&&self.carsSale.count!=0){
        return 26;
    }else{
        return 0;
    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    
//    if(section == self.carsSale.count&&self.model.data.seeOthers.count > 0){
//        return 220;
//    }
//    return 0.000001;
//}
///计算器
-(void)BuyCarCalculatorClicked:(UIButton*)button{
    NSInteger section = button.tag/sectionTag;
    NSInteger row = button.tag - section*sectionTag;
    CarOnOffSale *onOffmodel = self.carsSale[section];
    CarOnOffTypeModel*car = onOffmodel.carlist[row];
    BuyCarCalculatorViewController*vc  = [[ BuyCarCalculatorViewController alloc]init];
    vc.paiLiangString = car.engine_capacity;
    vc.seatNumber = car.seatnum;
    vc.cheXingString = car.name;
    if (car.factory_price.isNotEmpty) {
         vc.price = [car.factory_price floatValue]*10000;
    }else{
        vc.price =0;
    }
    [self.rt_navigationController pushViewController:vc animated:YES];


}

////询底价
-(void)searchPriceClicked:(UIButton*)button{
   
    
    switch (button.tag) {
        case headerButtonTag:
            [ClueIdObject setClueId:xunjia_01];
            break;
        case footerButtonTag:
            [ClueIdObject setClueId:xunjia_03];
            break;
        default:
            [ClueIdObject setClueId:xunjia_02];
            break;
    }
    
    AskForPriceNewViewController*vc = [[AskForPriceNewViewController alloc]init];
    if (button.tag == footerButtonTag ||button.tag == headerButtonTag) {
        if(self.model.data.carOnSale.count == 0 ){
            if (self.model.data.carOffSale.count == 0) {
                 [[DialogView sharedInstance]showDlg:self.view textOnly:@"没有可用车型"];
                return;
            }else{
                __block BOOL findCanSale = NO;
                [self.model.data.carOffSale enumerateObjectsUsingBlock:^(  CarOnOffSale* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.carlist enumerateObjectsUsingBlock:^(CarOnOffTypeModel* model, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (model.has_dealer==YES) {
                            findCanSale = YES;
                            *stop = YES;
                        }

                    }];
                    if (findCanSale ==YES) {
                        *stop = YES;
                    }
                    
                }];
                if (findCanSale==NO) {
                    [[DialogView sharedInstance]showDlg:self.view textOnly:@"没有可用车型"];
                    return;
                }
            }
           
        }else{
          
       
            CarOnOffSale *onOffmodel = self.carsSale[0];
            CarOnOffTypeModel*car = onOffmodel.carlist[0];
            
            vc.carTypeId = car.id;
            vc.carTypeName = car.name;
        }
        vc.carSerieasId = self.model.data.car_brand_type_id;
        vc.imageUrl = self.model.data.picture.bigpic;
 
    }else{
        NSInteger section = button.tag/sectionTag;
        NSInteger row = button.tag - section*sectionTag;
        CarOnOffSale *onOffmodel = self.carsSale[section];
        CarOnOffTypeModel*car = onOffmodel.carlist[row];
        
                vc.carTypeId = car.id;
                vc.carTypeName = car.name;
         vc.imageUrl = self.model.data.picture.bigpic;
    }
    [self.rt_navigationController pushViewController:vc animated:YES];

}
- (IBAction)backClicked:(UIButton *)sender {
    [self leftButtonTouch];
}

-(void)leftButtonTouch{
    [super  leftButtonTouch];
}

//城市选择
-(void)cityButtonClicked:(UIButton*)button{
    CityViewController*vc = [[CityViewController alloc]init];
//    vc.citySelectedBlock = ^(AreaNewModel *cityModel) {
//        if (![self.cityId isEqual:cityModel.id]) {
//            self.cityId = cityModel.id;
//            if(!self.model){
//                self.model = [CarDeptViewModel SceneModel];
//            }
//            self.model.request.chexiId =  self.chexiid;
//            self.model.request.city_id= self.cityId;
//            self.model.request.startRequest = YES;
//            [self addjustButton:self.cityButton WithTitle:cityModel.name];
//        }
//  
//    };
    [self.rt_navigationController pushViewController:vc animated:YES];
    
}

///PK
-(IBAction)PKButtonClicked:(UIButton*)button{
    CompareListViewController*vc = [[CompareListViewController alloc]init];
    [self.rt_navigationController pushViewController:vc animated:YES];
}
///分享
-(IBAction)shareButtonClicked:(UIButton*)button{
    NSString *title = @"";
    title = [NSString stringWithFormat:@" %@ %@",self.model.data.car_brand_type_name,self.model.data.zhidaoPrice];
    
    NSString *commentShare = shareContent;
    NSString *content = [NSString stringWithFormat:@"【%@】%@",self.model.data.car_brand_type_name,commentShare];
    

    self.shareView.title = title;
    self.shareView.content = content;
    self.shareView.share_url = self.model.data.share_link;
    self.shareView.pic_url = self.picture;
    
    [self.shareView setMyownshareType:ShareArt];
    [self.shareView initPopView];
}
///收藏
-(IBAction)favouriteButtonClicked:(UIButton*)button{
    
    if(button.selected){
        [self deleteMode:button];
        
    }else{
        
        if ([[UserModel shareInstance].uid isNotEmpty]) {
            [self saveModel:button];
        }else{
            //这边是用来重新登录并且绘制界面
            ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
            [URLNavigation pushViewController:controller animated:YES];
            @weakify(self)
            controller.loginSuccessDataBlock = ^{
                [self_weak_ updateView];
            };
        }

    }

}

///这边是用来重新登录并且绘制界面
-(void)updateView{
    NSArray *records = [KouBeiCarDeptModel findByColumn:@"colId" value:self.chexiid];
    if ( [records count] ) {
        self.favouriteButton.selected = YES;
    }else{
        self.favouriteButton.selected = NO;
    }
    
}




-(void)saveModel:(UIButton*)button{
    KouBeiCarDeptModel *carDept = [[KouBeiCarDeptModel alloc] init];
    
    carDept.name = self.model.data.car_brand_type_name;
    carDept.colId = self.model.data.car_brand_type_id;
    carDept.zhidaoPrice = self.model.data.zhidaoPrice;
    carDept.imgurl = self.picture;
    carDept.tag = chexi;

    [self.subjectObject InfoSaveObject:carDept typeid:chexi];
    
    @weakify(self)
    self.subjectObject.infoBlock = ^(bool isok) {
        if (isok) {
            [self_weak_ showSaveSuccess];
             button.selected =YES;
        }else{
            [self_weak_ showSaveSuccessWithTitle:@"收藏失败"];
        }
    };
    
   
}

-(void)saveBrowseModel{
    BrowseKouBeiCarDeptModel *model = [[BrowseKouBeiCarDeptModel alloc] init];
    
    model.name = self.model.data.car_brand_type_name;
    model.id = self.model.data.car_brand_type_id;
    model.price = self.model.data.zhidaoPrice;
    model.pic = self.picture;
    model.tag = chexi;
    [model save];
   
}

-(void)deleteBrowesModel:(BrowseKouBeiCarDeptModel *) model{
    BrowseKouBeiCarDeptModel *temp = model;
    [temp deleteSelf];
}

-(void)deleteMode:(UIButton*)button{
    NSArray *art = [KouBeiCarDeptModel findByColumn:@"colId" value:self.chexiid];
    if ([art count]) {
        KouBeiCarDeptModel *temp = art[0];
        
        [self.subjectObject InfoMoveObject:temp typeid:chexi];
        
        @weakify(self)
        self.subjectObject.infoBlock = ^(bool isok) {
            if (isok) {
                [self_weak_ showSaveRemove];
                 button.selected = NO;
            }else{
                [self_weak_ showSaveSuccessWithTitle:@"收藏失败"];
            }
        };
    }
}


-(void)adjustNavigationBarColorWithYContentOffSet:(CGFloat)Y{
    
    if (IOS_11_OR_LATER) {
        
    }
    
    if (Y <=0) {
        
        //／背景色为空，按钮为白色
        self.customNavigationView.backgroundColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        [self.cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.customBackButton setImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
        [self.PKButton setImage:[UIImage imageNamed:@"PKWhite"] forState:UIControlStateNormal];
        [self.favouriteButton setImage:[UIImage imageNamed:@"favouriteWhite"] forState:UIControlStateNormal];
              [self.shareButton setImage:[UIImage imageNamed:@"shareWhite"] forState:UIControlStateNormal];
        self.customNavigationBottomLineView.backgroundColor = [UIColor clearColor];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        float alpha = Y/114;
        if (alpha >= 1) {
            alpha = 1;
            self.customNavigationBottomLineView.backgroundColor = [UIColor fromHexValue:0xE3E3E3 alpha:alpha];
        }else{
             self.customNavigationBottomLineView.backgroundColor = [UIColor clearColor];
        }
        
        //／背景色为白色，按钮为蓝色
        [self.customBackButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
         [self.cityButton setTitleColor:BlackColor333333 forState:UIControlStateNormal];
        [self.PKButton setImage:[UIImage imageNamed:@"PKBlack"] forState:UIControlStateNormal];
       
        [self.favouriteButton setImage:[UIImage imageNamed:@"favouriteBlack.png"] forState:UIControlStateNormal];
        [self.shareButton setImage:[UIImage imageNamed:@"shareBlack.png"] forState:UIControlStateNormal];

        self.customNavigationView.backgroundColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y+[self topOffSet];
    if (offSetY==0) {
        offSetY=-1;
    }
    [self adjustNavigationBarColorWithYContentOffSet:offSetY];
   
    [self scaleHeaderImageWithScrollViewOffSetY:offSetY];
    ///改变顶部的阴影
   
//    
//       CGFloat imageH = self.topImage.frame.size.height;
//    //获取偏移量
//    CGFloat offsetY = scrollView.contentOffset.y;
//    //centrView的frame
//    
//    //等比例的伸缩
//    
//  CGFloat scale=   ((-offsetY +headBackgroundImageHeight) /(headBackgroundImageHeight));
//    scale = (scale>=1)?scale :1;
//    
//    
//    self.topImage.layer.anchorPoint = CGPointMake(0.5, 1-0.5*headBackgroundImageHeight/imageH);
//    self.topImage.transform =  CGAffineTransformMakeScale( scale, scale);
    
}
-(void)scaleHeaderImageWithScrollViewOffSetY:(CGFloat)offSetY{
 
    NSLog(@"%f",offSetY);
    if(offSetY <= 0)
    {
        //获取第一个cell
        
        CGFloat imageH =[self headBackgroundImageHeight];
        
        CGFloat percent = (-offSetY + imageH)/imageH;
        //获得cell的尺寸
        CGRect cellFrame = self.topImage.frame;
        CGPoint cellCenter = self.topImage.center;
        cellFrame.size.width = [UIScreen mainScreen].bounds.size.width *percent;
        cellFrame.size.height = imageH *percent;
        cellCenter.x = cellCenter.x;
        cellCenter.y = imageH * 0.5 + offSetY * 0.5- [self topOffSet];
        self.topImage.center = cellCenter;
        self.topImage.bounds = cellFrame;
        
        
        //获得topbackimage的尺寸
        //获得offset
        CGFloat toppercent = (-offSetY + 49)/49;
        
        CGRect topFrame = self.topBlackImage.frame;
        CGPoint topCenter = self.topBlackImage.center;
        topFrame.size.width = [UIScreen mainScreen].bounds.size.width *toppercent;
        topFrame.size.height = 49 *toppercent;
        topCenter.x = topCenter.x;
        topCenter.y = 49 * 0.5 + offSetY * 0.5- [self topOffSet];
        self.topBlackImage.center = topCenter;
        self.topBlackImage.bounds = topFrame;
        
    }

}


-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
     
     self.cityId = [AreaNewModel shareInstanceSelectedInstance].id;
    [self updateView];
    
    //    self.navigationStyle = navigationStyleNormal;
    ///设置返回按钮颜色为白色
    //    [self.rt_navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self adjustNavigationBarColorWithYContentOffSet:self.tableView.contentOffset.y];
    if([CompareDict shareInstance].count == 0){
        self.PKCountLabel.hidden = YES;
    }else{
        self.PKCountLabel.hidden = NO;
        self.PKCountLabel.text =[NSString stringWithFormat:@"%lu",  [CompareDict shareInstance].count];
    }
    [self.tableView reloadData];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CarDeptTableViewHeaderFooterView *)headview{
    if (!_headview) {
        _headview= [[CarDeptTableViewHeaderFooterView alloc]initWithFrame:CGRectZero];
            
        _headview.image.hidden =YES;
        _headview.noimage = YES;
        _headview.tags = self.model.data.repTag;
        _headview.contentView.backgroundColor = [UIColor whiteColor];
        [_headview updateView];
        _headview.frame = CGRectMake(0, 0,kwidth , 75+_headview.tagView.height);
    }
    return _headview;
}

#pragma 城市切换

-(void)showCityAlert{
    CheckCityBytime *alet = [[CheckCityBytime alloc] init];
    if ([alet checkByTime:1*12*60]) {
        [self showCity];
    }
}

-(void)showCity{
    if ([[Location shareInstance].cityId isNotEmpty] && [Location shareInstance].cityId.length >0 && ![[Location shareInstance].cityId isEqual:[AreaNewModel shareInstanceSelectedInstance].id]){
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
        }];
    }
}
-(void)dealloc{
    
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
