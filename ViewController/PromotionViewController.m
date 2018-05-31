//
//  PromotionViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionViewController.h"

#import "PromotionInfoTableViewCell.h"
#import "PromotionConditionTableViewCell.h"
#import "PromotionImageTableViewCell.h"
#import "CarHeaderCollectionViewCell.h"
#import "PromotionPTableViewCell.h"
#import "DealerPopTableViewCell.h"
#import "ColorTableViewHeaderFooterView.h"
#import "TableViewFooterView.h"

#import "PromotionInfoViewModel.h"
#import "PromotionSaleCarTableViewCell.h"
#import "PromotionCarList.h"
#import "PromotionTableViewCell.h"
#import "PromotionMoreTableViewHeaderFooterView.h"

#import "PromotionPrcinfoModel.h"
#import "ZLPhotoPickerBrowserViewController.h"

#import "PromotionCarTableViewCell.h"
#import "AskForPriceViewController.h"
#import "PhoneCallWebView.h"


@interface PromotionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)PromotionInfoViewModel *promotionViewModel;

//零时使用的列表
@property(nonatomic,strong)PromotionCarList *temp_list;
@property(nonatomic,assign)bool isShowAll;

///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowAll = false;
    // Do any additional setup after loading the view from its nib.
    [self setNavigationtitle:@"促销详情" textColor:BlackColor333333];
    [self initTable];
    [self initButtonView];
    [self initData];
}

-(void)initTable{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //头部信息
    [self.tableView registerNib:nibFromClass(PromotionInfoTableViewCell) forCellReuseIdentifier:@"PromotionInfoTableViewCell"];
    //条件
    [self.tableView registerClass:[PromotionConditionTableViewCell class] forCellReuseIdentifier:@"PromotionConditionTableViewCell"];
    //文本信息
    [self.tableView registerNib:nibFromClass(PromotionPTableViewCell) forCellReuseIdentifier:@"PromotionPTableViewCell"];
    
    //列表
//    [self.tableView registerNib:nibFromClass(PromotionTableViewCell)
//         forCellReuseIdentifier:@"PromotionTableViewCell"];
    
    [self.tableView registerNib:nibFromClass(PromotionCarTableViewCell) forCellReuseIdentifier:@"PromotionCarTableViewCell"];
    //图片
    [self.tableView registerNib:nibFromClass(PromotionImageTableViewCell)forCellReuseIdentifier:@"PromotionImageTableViewCell"];

    
    //l
    //头部标题
//    [self.tableView registerClass:[CarHeaderCollectionViewCell class] forCellReuseIdentifier:@"CarHeaderCollectionViewCell"];
    //车系简介
    [self.tableView registerClass:[ColorTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"ColorTableViewHeaderFooterView"];
    //相关推荐
    [self.tableView registerClass:[TableViewFooterView class]forHeaderFooterViewReuseIdentifier:@"TableViewFooterView"];
    
    [self.tableView  registerClass:[PromotionMoreTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PromotionMoreTableViewHeaderFooterView"];
}

-(void)initData{
    self.promotionViewModel = [PromotionInfoViewModel SceneModel];
    self.promotionViewModel.request.dealerId = self.dealerId;
    self.promotionViewModel.request.newsId = self.newsid;
    self.promotionViewModel.request.startRequest = YES;
    
    @weakify(self);
    [[RACObserve(self.promotionViewModel, data)filter:^BOOL(id value) {
        @strongify(self);
        return self.promotionViewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        if(x){
            [self initPhotos];
            [self.tableView reloadData];
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.promotionViewModel.data isNotEmpty]){
    return 6;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if ([self.promotionViewModel.data.dealerinfo isNotEmpty]) {
                return 1;
            }else{
                return 0;
            }
            break;
        case 1:
            if ([self.promotionViewModel.data.proinfo isNotEmpty]) {
                return 1;
            }else{
                return 0;
            }
            break;
        case 2:
            if ([self.promotionViewModel.data.article isNotEmpty]) {
                return 1;
            }else{
                return 0;
            }
            break;
        case 3:
            if (self.promotionViewModel.data.carlist.count>0) {
                if (self.isShowAll) {
                    return self.promotionViewModel.data.carlist.count;
                }else{
                    self.temp_list = self.promotionViewModel.data.carlist[0];
                    return 1;
                }
            }else{
                return 0;
            }
            break;
        case 4:
            if (self.promotionViewModel.data.picinfo.count>0) {
                return [self picCount];
            }else{
                return 0;
            }
            break;
        case 5:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 4:
        {
            [self jump2photo:indexPath.row];
        }
        break;
            
        default:
            break;
    }
}

#pragma 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0.00001;
            break;
        case 1:
            if (self.promotionViewModel.data.proinfo.length>0) {
                return 30;
            }else{
                return 0;
            }
            break;
        case 2:
            return 30;
            break;
        case 3:
            return 0.00001;
            break;
        case 4:
            return 30;
            break;
        case 5:
            return 30;
            break;
        default:
            break;
    }
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:{
            if (self.promotionViewModel.data.proinfo.length>0) {
                ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
                view.label.text = @"优惠条件";
                [view.contentView setBackgroundColor:[UIColor whiteColor]];
                return view;
            }else{
                return nil;
            }

        }
            break;
        case 2:{
            ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
            view.label.text = @"活动说明";
            view.label.font = FontOfSize(16);
            [view.contentView setBackgroundColor:[UIColor whiteColor]];
            return view;
        }
            break;
        case 3:{
           
        }
            break;
        case 4:{
           
            ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
            view.label.text = @"车型图片";
            view.label.font = FontOfSize(16);
            [view.contentView setBackgroundColor:[UIColor whiteColor]];
           
            return view;

        }
            break;
        case 5:{
            ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
            view.label.text = @"免责声明";
            view.label.font = FontOfSize(16);
            [view.contentView setBackgroundColor:[UIColor whiteColor]];
            return view;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma 中部

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            // 头部
            return 60;
            break;
        case 1:
            //优惠条件
            return UITableViewAutomaticDimension;
            break;
        case 2:
            //活动说明
            return UITableViewAutomaticDimension;
            break;
        case 3:
            //车辆列表
        {
            CGFloat height = 0;
            
            if (self.isShowAll) {
                PromotionCarList *list = self.promotionViewModel.data.carlist[indexPath.row];
                height = height+list.carlist.count*102;
                height = height+30;
            }else{
                height = height+self.temp_list.carlist.count*102;
                height = height+30;
            }
            return height;
        }
            break;
        case 4:{
            return 130;
        }
            break;
        default:
            break;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            PromotionInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionInfoTableViewCell"
                                                forIndexPath:indexPath];
            [cell setData:self.promotionViewModel.data.dealerinfo Art:self.promotionViewModel.data.article];
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:{
            PromotionConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionConditionTableViewCell" forIndexPath:indexPath];
            [cell setData:self.promotionViewModel.data.proinfo];
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:{
            PromotionPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionPTableViewCell"];
            [self setContentStyle:cell :self.promotionViewModel.data.article.des];
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
//            if(indexPath.row==0){
//                [cell setTopLineShow:NO];
//            }else{
//                [cell setTopLine];
//            }
            
            return cell;
        }
            break;
        case 3:{
            PromotionCarTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PromotionCarTableViewCell"];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell.dealerId = self.dealerId;
            if (self.isShowAll) {
               PromotionCarList *list = self.promotionViewModel.data.carlist[indexPath.row];
               [cell SetDataList:list];
            }else{
               [cell SetDataList:self.temp_list];
            }
            return cell;
        }
            break;
        case 4:{
            PromotionImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionImageTableViewCell"];
             cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            [cell setData:self.promotionViewModel.data.picinfo Count:indexPath.row];
            return cell;
        }
        case 5:{
            PromotionPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionPTableViewCell"];
            NSString *info = @"本促销内容由经销商发布，其真实性、准确性、合法性由该经销商负责，与车城网无关。";
            [self setContentStyle:cell : info];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
//            if(indexPath.row==0){
//                [cell setTopLineShow:NO];
//            }else{
//                [cell setTopLine];
//            }

            return cell;
        }
        default:
            break;
    }
    return nil;
}

#pragma 尾部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 10;
        }
            break;
        case 1:
        {
            if (self.promotionViewModel.data.proinfo.length>0) {
                return 10;
            }else{
                return 0.00001;
            }
   
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:{
            if(self.promotionViewModel.data.carlist.count>1){
            return 54;
            }else{
                return 10;
            }
        }
            break;
        case 4:{
            return 10;
        }
            break;
    }
    return 0.00001;

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
           
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
            [view.contentView setBackgroundColor:[UIColor whiteColor]];
            return view;
        }
            break;
        case 3:
        {
            
            if(self.promotionViewModel.data.carlist.count>1){
                
            PromotionMoreTableViewHeaderFooterView *view = [[PromotionMoreTableViewHeaderFooterView alloc]init];
            
            view.label.font = FontOfSize(14);
            view.label.textColor = BlackColorBBBBBB;
            
            [view.backgroundColorLabel addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [view.backgroundColorLabel setBackgroundColor:[UIColor clearColor]];
            
            [view.contentView setBackgroundColor:[UIColor whiteColor]];
            
            if (self.isShowAll) {
                view.label.text=@"点击收起";
                view.image.image = [UIImage imageNamed:@"箭头向上"];
            }else{
                view.label.text=@"加载更多";
                view.image.image = [UIImage imageNamed:@"箭头向下"];
            }
        
        
            return view;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

-(void)headerViewClicked:(UIButton*)button{
    if(self.isShowAll){
        self.isShowAll = false;
        [self.tableView reloadData];
    }else{
         self.isShowAll = YES;
        [self.tableView reloadData];
    }
    
}

///设置tableview的值
-(void)setContentStyle:(PromotionPTableViewCell *)cell :(NSString *)info{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    cell.content.numberOfLines = 0;
    paragraphStyle.headIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:cell.content.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    cell.content.attributedText = [[NSAttributedString alloc] initWithString:info attributes:attributes];
}

#pragma 关于图片计算的值
///计算图片的列数
-(NSInteger)picCount{
    int i = self.promotionViewModel.data.picinfo.count%2;
    if (i>0) {
        return (self.promotionViewModel.data.picinfo.count/2)+1;
    }else{
        return (self.promotionViewModel.data.picinfo.count/2);
    }
}

//初始化列表
-(void)initPhotos{
    if(!self.photos){
        self.photos = [[NSMutableArray alloc]init];
        [self.promotionViewModel.data.picinfo enumerateObjectsUsingBlock:^(PromotionPrcinfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:obj.picurl];
            [self.photos addObject:photo];
        }];
    }
}

//跳转图片
-(void)jump2photo:(NSInteger) count{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    //    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos;
    // 当前选中的值
    pickerBrowser.currentIndex = count;
    // 展示控制器
    // 加入这个方法，可以使得条转方法变快
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       //跳转界面
                       [pickerBrowser showPickerVc:[Tool currentViewController]];
                   });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)askPrise:(UIButton *)sender{
    [ClueIdObject setClueId:xunjia_15];
    AskForPriceViewController *vc = [[AskForPriceViewController alloc] init];
    vc.delearId = self.dealerId;
//    vc.carTypeName = self.promotionViewModel.data.
    [URLNavigation pushViewController:vc animated:YES];
}

-(void)makeCall:(UIButton *)sender{
    [PhoneCallWebView showWithTel:self.promotionViewModel.data.dealerinfo.servicePhone];
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
