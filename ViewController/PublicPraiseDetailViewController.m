//
//  PublicPraiseDetailViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicPraiseDetailViewController.h"
#import "PublicPraiseDetailTableViewCell.h"
#import "PublisPraiseDetailViewModel.h"
#import "KouBeiDetailContentModel.h"
#import "PublisPraiseTableViewCell.h"
#import "KouBeiDBModel.h"
#import "BrowseKouBeiDBModel.h"

#import "KouBeiPicsTableViewHeaderFooterView.h"


#import "SubjectAndSaveObject.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"

#import "MyOwnShareView.h"


static NSString *_id =@"PublicPraiseDetailTableViewCell";
static NSString *_imageid =@"PublisPraiseTableViewCell";
@interface PublicPraiseDetailViewController ()

@property(nonatomic,strong)PublisPraiseDetailViewModel *model;
@property(nonatomic,strong)UIButton* shareButton;
@property(nonatomic,strong)UIButton* favouriteButton;
@property(nonatomic,strong)NSArray<KouBeiDetailContentModel> *contents;
@property(nonatomic,strong)NSArray<KouBeiDetailPicModel> *pic;
@property(nonatomic,strong)NSMutableArray<KouBeiDetailPicModel> *rightList;

@property(nonatomic,strong)SubjectAndSaveObject *subjectObject;

//弹出控件
@property(nonatomic,strong) MyOwnShareView *shareView;

@end

@implementation PublicPraiseDetailViewController

-(MyOwnShareView *)shareView{
    if(!_shareView){
        _shareView = [[MyOwnShareView alloc] init];
    }
    return _shareView;
}

-(SubjectAndSaveObject *)subjectObject{
    if (!_subjectObject) {
        _subjectObject = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightList = [[NSMutableArray<KouBeiDetailPicModel> alloc]init];

   
    [self initTable];
    [self initData];
    
    [self showRightButton];

    
    [self setTitle:@"口碑详情"];
}
-(void)showRightButton{
    
    //    //头部两个按钮
    
    self.shareButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"shareBlack.png"]];
     [self.shareButton setImage:[UIImage imageNamed:@"shareBlackSelected.png"] forState:UIControlStateHighlighted];
    
    [self.shareButton  addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.favouriteButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"favouriteBlack.png"]];
    self.favouriteButton.tag = 1;
    [self.favouriteButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateSelected];
    [self.favouriteButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateHighlighted];
    [self.favouriteButton addTarget:self action:@selector(favouriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.favouriteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.shareButton.userInteractionEnabled = NO;
    self.favouriteButton.userInteractionEnabled = NO;
    UIBarButtonItem*shareItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    UIBarButtonItem*favouriteItem = [[UIBarButtonItem alloc]initWithCustomView:self.favouriteButton];
    
    
    
    self.navigationItem.rightBarButtonItems =@[shareItem,favouriteItem];
    
    
}


-(void)initData{
    self.model = [PublisPraiseDetailViewModel SceneModel];
    self.model.request.koubeiId = self.koubeiId;
    self.model.request.startRequest =YES;
        @weakify(self);
    [[RACObserve(self.model, data)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.model.data.isNotEmpty;
     }]subscribeNext:^(id x) {
          @strongify(self);
         [self initHeadDate];
         self.contents = self.model.data.contents;
         self.pic = self.model.data.pic;
         //[self rebuildList];
         NSArray *browse = [BrowseKouBeiDBModel findByColumn:@"id" value:self.koubeiId];
         if (! [browse count] ) {
             [self saveBrowesModel];
         }else{
             [self deleteBrowesModel:browse[0]];
             [self saveBrowesModel];
         }
         [self.tableView dismissWithOutDataView];
         self.favouriteButton.userInteractionEnabled = YES;
         self.shareButton.userInteractionEnabled = YES;
         [self.tableView reloadData];
     }];
    [[RACObserve(self.model, request)
      filter:^BOOL(id value) {
           @strongify(self);
          return self.model.request.failed;
      }]subscribeNext:^(id x) {
           @strongify(self);
          [self.tableView showNetLost];

          self.favouriteButton.userInteractionEnabled = NO;
          self.shareButton.userInteractionEnabled = NO;
      }];

}

-(void)initTable{

    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:_id bundle:nil] forCellReuseIdentifier:_id];
    
    [self.tableView registerNib:[UINib nibWithNibName:_imageid bundle:nil] forCellReuseIdentifier:_imageid];
    
    [self.tableView registerClass:[KouBeiPicsTableViewHeaderFooterView class]forHeaderFooterViewReuseIdentifier:classNameFromClass(KouBeiPicsTableViewHeaderFooterView)];
}

-(void)initHeadDate{
    [self.userHeadimg setImageWithURL:[NSURL URLWithString:self.model.data.info.original_user_pic] placeholderImage:[UIImage imageNamed:@"我的默认头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.userHeadimg.layer setCornerRadius:self.userHeadimg.frame.size.width / 2];
    self.userHeadimg.layer.masksToBounds = YES;
    
    self.username.text = self.model.data.info.original_user_name;
    self.time.text = self.model.data.info.publish_time;
    self.carTypeName.text =  [NSString stringWithFormat:@"%@>",self.model.data.info.CAR_BRAND_TYPE_NAME];
    [self.viewnum setTitle: self.model.data.info.click_count forState:UIControlStateNormal];
    
    if ([self.model.data.oilType isEqualToString:@"3"]) {
        self.oliLabelView.text = @"当前平均电耗";
        if (![self.model.data.info.oil isEqualToString:@"0"]) {
            self.oil.text = [self.model.data.info.oil stringByAppendingString:@"kWh/100km"];
        }else{
            self.oil.text = @"-/-";
        }
    }else{
        self.oliLabelView.text = @"当前平均油耗";
        if (![self.model.data.info.oil isEqualToString:@"0"]) {
            self.oil.text = [self.model.data.info.oil stringByAppendingString:@"升/百公里"];
        }else{
            self.oil.text = @"-/-";
        }
    }
    
    
   
   
    self.licheng.text = [self.model.data.info.mileage stringByAppendingString:@"公里"];
    self.carname.text = self.model.data.info.car_brand_son_type_name;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.contents.count>0){
        return 1;
    }else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.contents.count;
    }
    return 0;
   
}

//-(void)rebuildList{
//    NSMutableArray<KouBeiDetailPicModel*> *temp = [[NSMutableArray alloc] init];
//
//    int i =0;
//    for (KouBeiDetailPicModel *model in self.pic) {
//        [temp addObject:model];
//        i++;
//        //加到第3个就关闭
//        if (i == 3) {
//            NSArray *record = [temp copy]; ;
//           [self.rightList addObject:record];
//            i=0;
//            [temp removeAllObjects];
//        }
//    }
//    
//    if(temp.count>0){
//        [self.rightList addObject:temp];
//    }
//    
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0){
    return UITableViewAutomaticDimension;
    }return 90;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        KouBeiDetailContentModel *info = (KouBeiDetailContentModel *)self.model.data.contents[indexPath.row];
        
        PublicPraiseDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *name = @"·";
        name = [name stringByAppendingString:info.category_name];
 
        
        [self setContentStyle:cell.title:name];
        [self setContentStyle:cell.content:info.content];
        return cell;
    }
//    else{
//        PublisPraiseTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:_imageid forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//      return [self buildCell:cell :indexPath.section];
//
//    }
    return nil;
}

//-(PublisPraiseTableViewCell *)buildCell:(PublisPraiseTableViewCell*)cell :(NSInteger) count{
//    NSMutableArray<KouBeiDetailPicModel> *models = self.rightList[count];
//        switch (models.count) {
//            case 0:
//                [cell mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.mas_equalTo(0);
//                }];
//                cell.fristImage.hidden = YES;
//                cell.secondImage.hidden = YES;
//                cell.thirdImage.hidden = YES;
//                break;
//            case 1:
//                [cell.fristImage setImageWithURL:[NSURL URLWithString:((KouBeiDetailPicModel *)models[0]).original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                [cell.fristImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo((kwidth-30-20)/3);
//                }];
//                
//                cell.secondImage.hidden = YES;
//                cell.thirdImage.hidden = YES;
//                
//                
//                
//                break;
//            case 2:{
//                
//                KouBeiDetailPicModel *model = models[0];
//                [cell.fristImage setImageWithURL:[NSURL URLWithString:model.original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                [cell.secondImage setImageWithURL:[NSURL URLWithString:((KouBeiDetailPicModel *)models[1]).original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                [cell.fristImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo((kwidth-30-20)/3);
//                }];
//                
//                [cell.secondImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo((kwidth-30-20)/3);
//                }];
//
//                
//                cell.thirdImage.hidden = YES;
//                
//             
//                break;
//            }
//            case 3:
//                [cell.fristImage setImageWithURL:[NSURL URLWithString:((KouBeiDetailPicModel *)models[0]).original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                [cell.secondImage setImageWithURL:[NSURL URLWithString:((KouBeiDetailPicModel *)models[1]).original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                [cell.thirdImage setImageWithURL:[NSURL URLWithString:((KouBeiDetailPicModel *)models[2]).original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//                cell.fristImage.hidden = NO;
//                cell.secondImage.hidden = NO;
//                cell.thirdImage.hidden = NO;
//                
//                [cell.fristImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo((kwidth-30-20)/3);
//                }];
//                
//                [cell.secondImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo((kwidth-30-20)/3);
//                }];
//                
//                [cell.thirdImage mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo((kwidth-30-20)/3);
//                }];
//                
//                break;
//            default:
//                break;
//        }
//    
//    
//    return cell;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.pic.count>0) {
        int num = self.pic.count%3;
        if (num>0) {
            return (self.pic.count/3 + 1)*90;
        }else{
            return self.pic.count/3*90;
        }
    }
    return 0.00001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    KouBeiPicsTableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(KouBeiPicsTableViewHeaderFooterView)];
    [view setData:self.pic];
    return view;
}


///设置tableview的值
-(void)setContentStyle:(UILabel *)label :(NSString *)info{
    if([info isEqualToString:@""]){
        info = @"空";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.lineSpacing = 5;// 字体的行间距
    label.numberOfLines = 0;
    paragraphStyle.headIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:label.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    label.attributedText = [[NSAttributedString alloc] initWithString:info attributes:attributes];
}

-(void)favouriteButtonClicked:(UIButton *)button{
    
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
    NSArray *records = [KouBeiDBModel findByColumn:@"colId" value:self.koubeiId];
    if ( [records count] ) {
        self.favouriteButton.selected = YES;
    }else{
        self.favouriteButton.selected = NO;
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateView];
}

-(void)shareButtonClicked:(UIButton *)button{
    NSString *title = self.model.data.info.car_brand_son_type_name;
    title  = [title stringByAppendingString:@"怎么样?"];
    NSString *content = @"来车城网看看真相——来自";
    content = [content stringByAppendingString:self.model.data.info.original_user_name];
    content = [content stringByAppendingString:@"的点评"];
    
    self.shareView.title = title;
    self.shareView.content = content;
    self.shareView.share_url = self.model.data.arcurl;
    self.shareView.pic_url = nil;
    
    [self.shareView setMyownshareType:ShareArt];
    
    [self.shareView initPopView];

}


-(void)saveModel:(UIButton *)button{
    KouBeiDBModel *art = [[KouBeiDBModel alloc]init];
    
    art.title = self.model.data.info.car_brand_son_type_name;
    art.click = self.views;
    art.addtime = self.model.data.info.publish_time;
    art.colId = self.koubeiId;
    art.tag = koubeiInfo;

    
    [self.subjectObject InfoSaveObject:art typeid:koubeiInfo];
    
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

-(void)saveBrowesModel{
    BrowseKouBeiDBModel *model = [[BrowseKouBeiDBModel alloc] init];
    
    model.name = self.model.data.info.car_brand_son_type_name;
    model.views = self.views;
    model.time = self.model.data.info.publish_time;
    model.id = self.koubeiId;
    model.tag = koubeiInfo;
    
    [model save];
    
}

-(void)deleteBrowesModel:(BrowseKouBeiDBModel *) model{
    BrowseKouBeiDBModel *temp = model;
    [temp deleteSelf];
}


-(void)deleteMode:(UIButton *)button{
    NSArray *art = [KouBeiDBModel findByColumn:@"colId" value:self.koubeiId];
    if ([art count]) {
        KouBeiDBModel *temp = art[0];
        [self.subjectObject InfoMoveObject:temp typeid:koubeiInfo];
        @weakify(self)
        self.subjectObject.infoBlock = ^(bool isok) {
            if (isok) {
                [self_weak_ showSaveRemove];
                button.selected =NO;
            }else{
                [self_weak_ showSaveSuccessWithTitle:@"收藏失败"];
            }
        };

    }
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
