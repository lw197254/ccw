//
//  DealerDetailViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/3/2.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerDetailViewController.h"
#import "DealerTableViewHeaderView.h"
#import "TableViewFooterView.h"

#import "DealerBigImageTableViewCell.h"
#import "ColorTableViewHeaderFooterView.h"
#import "DealerDetailTableViewCell.h"
#import "CompanyIntroduceViewController.h"
#import "PromotionSaleCarsViewController.h"
#import "SalesInformationViewController.h"

#import "DealerDetailViewModel.h"

#import "PromotionDearInfoModel.h"
#import "PromotionArtInfoModel.h"
#import "PromotionCarModel.h"
#import "DealerCarInfoViewController.h"

#import "PromotionMoreTableViewHeaderFooterView.h"
#import "AskForPriceViewController.h"
#import "PhoneCallWebView.h"

#import "PromotionViewController.h"
#import "MyOwnShareView.h"

@interface DealerDetailViewController ()<UITableViewDataSource,UITableViewDelegate,HTHorizontalSelectionListDelegate>
@property (strong, nonatomic) UIButton *shareButton;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)DealerDetailViewModel *dealerViewModel;
//弹出控件
@property(nonatomic,strong) MyOwnShareView *shareView;
@end

@implementation DealerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
     self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self showNavigationTitle:@"经销商"];
    [self showSingleButton];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 0)];
    [self.view addSubview:view];
    
    [self initTableView];
    [self initButtonView];
    [self initData];
}

//一个按钮
-(void)showSingleButton{
    self.shareButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"shareBlack.png"]];
    [self.shareButton setImage:[UIImage imageNamed:@"shareBlackSelected.png"] forState:UIControlStateHighlighted];
    
    [self.shareButton  addTarget:self action:@selector(shareDealerClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem*shareItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItems =@[shareItem];
    
}



-(void)initTableView{
    self.tableView  =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50-SafeAreaBottom);
    }];
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 头部尾部
    [self.tableView registerClass:[PromotionMoreTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PromotionMoreTableViewHeaderFooterView"];
    
    [self.tableView registerClass:[ColorTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"ColorTableViewHeaderFooterView"];
    
    [self.tableView registerClass:[TableViewFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewFooterView"];
    // cell
    [self.tableView registerNib:nibFromClass(DealerBigImageTableViewCell)forCellReuseIdentifier:@"DealerBigImageTableViewCell"];
    
    [self.tableView registerNib:nibFromClass(DealerDetailTableViewCell)forCellReuseIdentifier:@"DealerDetailTableViewCell"];
}




-(void)initData{
    self.dealerViewModel = [DealerDetailViewModel SceneModel];
    self.dealerViewModel.request.dealerId = self.dealerId;
    self.dealerViewModel.request.startRequest = YES;
    
    @weakify(self);
    [[RACObserve(self.dealerViewModel, data)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.dealerViewModel.data.isNotEmpty;
     }]subscribeNext:^(id x) {
          @strongify(self);
         if(x){
             [self.tableView reloadData];
         }
     }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if (self.dealerViewModel.data.article.count>0) {
                return 1;
            }
            return 0;
        }
            break;
        case 1:
            return self.dealerViewModel.data.carlist.count;
            break;
        default:
            break;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    switch (indexPat.section) {
        case 0:
        {
            PromotionViewController *vc = [[PromotionViewController alloc] init];
            PromotionArtInfoModel *model = self.dealerViewModel.data.article[indexPat.row];
            vc.dealerId = self.dealerId;
            vc.newsid = model.newsid;
            
           [self.rt_navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            DealerCarInfoViewController *vc = [[DealerCarInfoViewController alloc] init];
            PromotionCarModel *model = self.dealerViewModel.data.carlist[indexPat.row];
            
            vc.dealerId =self.dealerId;
            vc.typeId = model.typeid;
            vc.carId = model.carid;
            
             [self.rt_navigationController pushViewController:vc animated:YES];

        }
            break;
            
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            DealerBigImageTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"DealerBigImageTableViewCell" forIndexPath:indexPath];
            [cell setData:self.dealerViewModel.data.article[0]];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            }
            break;
        case 1:{
            DealerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealerDetailTableViewCell" forIndexPath:indexPath];
            [cell setData:self.dealerViewModel.data.carlist[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            return kwidth*3/4;
            break;
        case 1:
            return UITableViewAutomaticDimension;
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return kwidth*3/4;
            break;
        case 1:
            return 100;
            break;
        default:
            break;
    }
    return 0;
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    switch (index) {
       
        case 1:
        {
            ///促销信息
            SalesInformationViewController *vc= [[SalesInformationViewController alloc] init];
            vc.dealerId = self.dealerId;
            [URLNavigation pushViewController:vc animated:YES];

        }
            break;
        case 0:
        {
            ///在售车型
            PromotionSaleCarsViewController *vc = [[PromotionSaleCarsViewController alloc] init];
            vc.dealer = self.dealerId;
            [URLNavigation pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ///公司信息
            CompanyIntroduceViewController*vc = [[CompanyIntroduceViewController alloc]init];
            vc.dealerId = self.dealerId;
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma 头部信息

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 200;
            break;
        case 1:
            return 44;
            break;
        default:
            break;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        DealerTableViewHeaderView *view = [[DealerTableViewHeaderView alloc] init];
        view.horizontalSelectionList.delegate = self;
        [view setHeadData:self.dealerViewModel.data.dealerinfo];
        return view;
    }else if(section == 1){
        ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
        view.label.text = @"具体车型推荐";
        view.label.font = FontOfSize(16);
        [view.contentView setBackgroundColor:[UIColor whiteColor]];
        return view;
    }
    return 0;

}

#pragma 尾部信息
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==0){
        if (self.dealerViewModel.data.article.count>0) {
            return 10;
        }
        return 0.000001;
    }
    return 54;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        return nil;
    }else if(section == 1){
        PromotionMoreTableViewHeaderFooterView *view = [[PromotionMoreTableViewHeaderFooterView alloc]initWithFrame:CGRectZero];
        ///隐藏头部的线
        [view setTopLineShow:NO];
        view.label.font = FontOfSize(14);
        view.label.textColor = BlackColorBBBBBB;
        
        [view.backgroundColorLabel addTarget:self action:@selector(footerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view.backgroundColorLabel setBackgroundColor:[UIColor clearColor]];
        
        [view.contentView setBackgroundColor:[UIColor whiteColor]];

        view.label.text=@"查看更多热销车型";
        view.image.image = [UIImage imageNamed:@"箭头向右"];
        
        return view;
    }

    
    return nil;
}

#pragma 点击方法
-(void)footerViewClicked:(UIButton*)button{
    ///在售车型
    PromotionSaleCarsViewController *vc = [[PromotionSaleCarsViewController alloc] init];
    vc.dealer = self.dealerId;
    [URLNavigation pushViewController:vc animated:YES];

}

-(void)askPrise:(UIButton *)sender{
    [ClueIdObject setClueId:xunjia_13];
    AskForPriceViewController *vc = [[AskForPriceViewController alloc] init];
    vc.delearId = self.dealerId;
    [URLNavigation pushViewController:vc animated:YES];
}

-(void)makeCall:(UIButton *)sender{
    [PhoneCallWebView showWithTel:self.dealerViewModel.data.dealerinfo.servicePhone];
}

-(MyOwnShareView *)shareView{
    if(!_shareView){
        _shareView = [[MyOwnShareView alloc] init];
    }
    return _shareView;
}

///分享
-(void)shareDealerClicked:(UIButton*)button{
    
    self.shareView.title = self.dealerViewModel.data.dealerinfo.name;
    self.shareView.content = self.dealerViewModel.data.dealerinfo.name;;
    self.shareView.share_url = self.dealerViewModel.data.share_link;
    self.shareView.pic_url = self.dealerViewModel.data.dealerinfo.pic_url;
    
    [self.shareView setMyownshareType:ShareArt];
    [self.shareView initPopView];
    
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
