//
//  PublicPraiseCheXingTableView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicPraiseCheXingTableView.h"

#import "PublicPraiseTableViewCell.h"
#import "KouBeiModel.h"
#import "KouBeiContentModel.h"
#import "KouBeiPicModel.h"
#import "PublicPraiseDetailViewController.h"
#import "PublicPraiseHeaderView.h"

#import "ZLPhotoPickerBrowserViewController.h"

static int count = 10000;
@interface PublicPraiseCheXingTableView()

@property(nonatomic,strong)NSMutableArray<KouBeiModel> *koubei;
///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;

@property(nonatomic,strong) PublicPraiseHeaderView *headView;

@end

@implementation PublicPraiseCheXingTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.isFirstTab = NO;
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.backgroundColor = [UIColor whiteColor];
         self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self registerNib:[UINib nibWithNibName:@"PublicPraiseTableViewCell" bundle:nil] forCellReuseIdentifier:@"PublicPraiseTableViewCell"];
        
        
        [self registerNib:[UINib nibWithNibName:@"PublicPraiseHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PublicPraiseHeaderView"];
        
        self.page =1;
        
        self.koubei= [[NSMutableArray<KouBeiModel> alloc]init];
        self.model = [PublisPraiseCheXingViewModel SceneModel];
        self.model.request.page = self.page;
        
        
        self.topViewModel = [PublicPraiseTopCheXingViewModel SceneModel];
         @weakify(self);
        //下拉更新
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
             @strongify(self);
            self.page =1;
            self.model.request.page = self.page;
            self.model.request.startRequest  =YES;
            self.headView=nil;
           
        }];
    
        
        //状态判断
        [[RACObserve(self.model.request,state)
          filter:^BOOL(id value) {
               @strongify(self);
              return self.model.request.failed;
          }]subscribeNext:^(id x) {
               @strongify(self);
              [self showNetLost];
              [self.mj_header endRefreshing];
              [self.mj_footer endRefreshing];
          }];
        
        
//        //状态判断
//        [[RACObserve(self.model.request,state)
//          filter:^BOOL(id value) {
//               @strongify(self);
//              return self.model.request.succeed;
//          }]subscribeNext:^(id x) {
//               @strongify(self);
//              
//          }];
        
        [[RACObserve(self.model, data)
          filter:^BOOL(id value) {
               @strongify(self);
              return self.model.data.isNotEmpty;
          }]subscribeNext:^(id x) {
             @strongify(self);
              [self.mj_header endRefreshing];
              [self.mj_footer endRefreshing];
              
              [self.koubei addObjectsFromArray:self.model.data.koubei];
              
              if (self.koubei.count==0) {
                  [self showWithOutDataViewWithTitle:@"暂无口碑数据"];
              }else if(self.model.data.koubei
                       .count<6){
                 
                  [self.mj_footer endRefreshingWithNoMoreData];
                  ((MJRefreshAutoNormalFooter*)self.mj_footer).stateLabel.text = @"";
                  [self reloadData];
              }else{
                  
                  if (self.mj_footer == NULL) {
                      
                      self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                          @strongify(self);
                          self.model.request.page = self.page;
                          self.model.request.startRequest  =YES;
                          
                      }];
                  }
                  
                  self.page++;
                  [self reloadData];
              }

              
         
          }];
        
        //首页请求
        [[RACObserve(self.topViewModel, data)
          filter:^BOOL(id value) {
               @strongify(self);
              return self.topViewModel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
               @strongify(self);
              [self.koubei addObjectsFromArray:self.topViewModel.data.koubei];
              if (self.koubei.count==0) {
                  [self showWithOutDataViewWithTitle:@"暂无口碑数据"];
              }else if(self.topViewModel.data.koubei
                       .count<6){
                  
                  [self.mj_footer endRefreshingWithNoMoreData];
                  ((MJRefreshAutoNormalFooter*)self.mj_footer).stateLabel.text = @"";
                  [self reloadData];
              }else{
                  //上拉加载
                  if (self.mj_footer == NULL) {
                      
                      self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                          @strongify(self);
                          self.model.request.page = self.page;
                          self.model.request.startRequest  =YES;
                          
                      }];
                  }
                  
                 self.page++;
                [self reloadData];
              }
             
             
              [self.mj_header endRefreshing];
              [self.mj_footer endRefreshing];
          }];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.koubei.count>0) {
        return 1;
    }
    return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.koubei.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id = @"PublicPraiseTableViewCell";
    PublicPraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id forIndexPath:indexPath];
    KouBeiModel *model = self.koubei[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.userName.text = model.username;
    cell.time.text = model.datetime;
    cell.sees.text = model.click_count;
    cell.price.text = model.price;
    if ([model.oil integerValue] >0) {
         cell.oil.text =  [NSString stringWithFormat:@"%@L/100km",model.oil];
    }else{
         cell.oil.text =  @"- / -";
    }
   
    cell.place.text = model.address;
    cell.carTypeLabel.text = model.car_brand_son_type_name;
   
    
    switch (model.content.count) {
        case 0:
            
            break;
        case 1:
            [cell.firstbutton setTitle:((KouBeiContentModel *)model.content[0]).cate_menu forState:UIControlStateNormal];
            [self setContentStyle:cell.goodComment :((KouBeiContentModel *)model.content[0]).cate_content];
            
            cell.badCommentString = @"";
           
            
            break;
        case 2:
            
            [cell.firstbutton setTitle:((KouBeiContentModel *)model.content[0]).cate_menu forState:UIControlStateNormal];
            [self setContentStyle:cell.goodComment :((KouBeiContentModel *)model.content[0]).cate_content];
            
            [cell.secondbutton setTitle:((KouBeiContentModel *)model.content[1]).cate_menu forState:UIControlStateNormal];
            cell.badCommentString = ((KouBeiContentModel *)model.content[1]).cate_content;
            
            break;
            
        default:
            break;
    }
    
    
    
    [cell.userHead setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:[UIImage imageNamed:@"我的默认头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    switch (model.pics.count) {
        case 0:
            cell.imageTableHeightConstraint.priority = 900;
            cell.imageTable.hidden = YES;
            break;
        case 1:{
            cell.imageTableHeightConstraint.priority = 200;
            cell.imageTable.hidden = NO;
            cell.firstImage.hidden= NO;
            [cell.firstImage setImageWithURL:[NSURL URLWithString:((KouBeiPicModel *)model.pics[0]).pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.firstImage.tag = count*indexPath.row + 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [cell.firstImage addGestureRecognizer:tap];
            [tap setNumberOfTapsRequired:1];
            
            [cell.firstImage setUserInteractionEnabled:YES];
            
            cell.secondImage.hidden= YES;
            cell.thirdImage.hidden= YES;
        }
            break;
        case 2:
        {
            cell.firstImage.hidden= NO;
            cell.secondImage.hidden= NO;
            cell.imageTableHeightConstraint.priority = 200;
            cell.imageTable.hidden = NO;
            [cell.firstImage setImageWithURL:[NSURL URLWithString:((KouBeiPicModel *)model.pics[0]).pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.secondImage setImageWithURL:[NSURL URLWithString:((KouBeiPicModel *)model.pics[1]).pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.thirdImage.hidden= YES;
            
            cell.firstImage.tag = count*indexPath.row + 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [cell.firstImage addGestureRecognizer:tap];
            [tap setNumberOfTapsRequired:1];
            
            
            cell.secondImage.tag = count*indexPath.row + 1;
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [cell.secondImage addGestureRecognizer:tap1];
            [tap1 setNumberOfTapsRequired:1];
            
            [cell.firstImage setUserInteractionEnabled:YES];
            [cell.secondImage setUserInteractionEnabled:YES];
            
        }
            
            break;
        case 3:
        {
            
            cell.firstImage.hidden= NO;
            cell.secondImage.hidden= NO;
            cell.thirdImage.hidden= NO;
            cell.imageTableHeightConstraint.priority = 200;
            cell.imageTable.hidden = NO;
            [cell.firstImage setImageWithURL:[NSURL URLWithString:((KouBeiPicModel *)model.pics[0]).pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.secondImage setImageWithURL:[NSURL URLWithString:((KouBeiPicModel *)model.pics[1]).pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [cell.thirdImage setImageWithURL:[NSURL URLWithString:((KouBeiPicModel *)model.pics[2]).pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
                       
            cell.firstImage.tag = count*indexPath.row + 0;
            cell.secondImage.tag = count*indexPath.row + 1;
            
            
            
            cell.firstImage.tag = count*indexPath.row + 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [cell.firstImage addGestureRecognizer:tap];
            [tap setNumberOfTapsRequired:1];
            
            
            cell.secondImage.tag = count*indexPath.row + 1;
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [cell.secondImage addGestureRecognizer:tap1];
            [tap1 setNumberOfTapsRequired:1];
            
            
            cell.thirdImage.tag = count*indexPath.row + 2;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
            [cell.thirdImage addGestureRecognizer:tap2];
            [tap2 setNumberOfTapsRequired:1];
            
            
            [cell.firstImage setUserInteractionEnabled:YES];
            [cell.secondImage setUserInteractionEnabled:YES];
            [cell.thirdImage setUserInteractionEnabled:YES];
            
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 364;
}

///设置tableview的值
-(void)setContentStyle:(UILabel *)label :(NSString *)info{
    if (info.length==0) {
        label.text = @"";
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    label.numberOfLines = 3;
   
    paragraphStyle.headIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:label.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    label.attributedText = [[NSAttributedString alloc] initWithString:info attributes:attributes];
     label.lineBreakMode = NSLineBreakByTruncatingTail;
}

///设置tableview的值
-(void)setContentStyle:(UIButton *)button :(NSString *)info :(NSString*)useless{
    if (info.length==0) {
        button.titleLabel.text = @"";
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    button.titleLabel.numberOfLines = 3;
    paragraphStyle.headIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: button.titleLabel.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    button.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:info attributes:attributes];
     button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.isFirstTab){
        
        NSString *people = self.topViewModel.data.user_count;
        people = [people stringByAppendingString:@"人参与"];
        self.headView.commentPeopleNumberLabel.text =people;
    

         self.headView.starLabel.text = [NSString stringWithFormat:@"%@分",self.topViewModel.data.kb_average];
        
        NSString *rank = self.topViewModel.data.rank;
        rank = [rank stringByAppendingString:@"名"];
        self.headView.rankLabel.text =rank;
        
        
        NSString *car_out = self.topViewModel.data.car_count;
        car_out = [car_out stringByAppendingString:@"个车型参与"];
        self.headView.carTypeNumberLabel.text =car_out;
        return self.headView;
    }return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.isFirstTab){
        if ([self.headView isNeedShowPaiHang]) {
            return 65+75/2+self.headView.tagView.height+200;
        }else{
            return 65+75/2+self.headView.tagView.height;
        }
    } return 0.0001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
     return 0.0001;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PublicPraiseDetailViewController *controller = [[PublicPraiseDetailViewController alloc] init];
    KouBeiModel *model = self.koubei[indexPath.row];
    controller.koubeiId = model.reputation_id;
    controller.views = model.click_count;
    [URLNavigation pushViewController:controller animated:YES];
}

-(void)imageClick:(UITapGestureRecognizer *) gesture{
    NSInteger row = gesture.view.tag/count;
    NSInteger picNum = gesture.view.tag%count;
    
    
    KouBeiModel *model = self.koubei[row];
    //组成图片
    if(model.pics.count>0){
        self.photos = [[NSMutableArray alloc]init];
        for (KouBeiPicModel *pic in model.pics) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:pic.pic_url];
            [self.photos addObject:photo];
        }
    }
    
    [self jump2photo:picNum];
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



-(PublicPraiseHeaderView *)headView{
    if (!_headView) {
        _headView = [[PublicPraiseHeaderView alloc]initWithFrame:CGRectZero];
        
            _headView.seriseKB = self.topViewModel.data.seriesKbData;
            _headView.seriseModelKB = self.topViewModel.data.seriesModelKbData;
            _headView.tags = self.topViewModel.data.repTag;
            _headView.count = self.topViewModel.data.repCount;
            _headView.carname = self.topViewModel.data.brand_son_type_name;
            
            
            if ([_headView isNeedShowPaiHang]) {
                [_headView buildUpView];
                [_headView reloadSelection];
            }else{
                [_headView buildUpView];
            }
            
            if (self.topViewModel.data.repTag.count>0&&![self.topViewModel.data.repCount isEqualToString:@"0"]) {
                [_headView buildTagView];
            }
            
            if ([_headView isNeedShowPaiHang]) {
                [_headView reloadSelection];
            }
    }
    return _headView;
}

@end
