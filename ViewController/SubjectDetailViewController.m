//
//  SubjectDetailViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SubjectDetailViewController.h"

#import "HomeViewController.h"
//#import "InfoDetailsViewController.h"
#import "SubscribeDetailViewController.h"
#import "ArtInfoViewController.h"
#import "MediaDetailViewModel.h"
#import "InfoContentModel.h"
#import "PTableViewCell.h"
#import "ImgTableViewCell.h"
#import "RelateCarTableViewCell.h"
#import "PublicNormalTableViewCell.h"
#import "CarDeptViewController.h"
#import "RecommendTableViewCell.h"
#import "ZiMeiTiRelateCarTableViewCell.h"

#import "TableViewHeaderFooterView.h"
#import "TableViewFooterView.h"
#import "TableSubjectTopHeaderFooterView.h"
#import "ShareTableViewHeaderFooterView.h"
#import "CarDeptViewController.h"

#import "InfoRelateTypesModel.h"
#import "RelateTypeCarTableViewCell.h"
#import "InfoDetailFont.h"
#import "InfoTableView.h"
#import "KouBeiArtModel.h"
#import "BrowseKouBeiArtModel.h"

#import "SubjectAuthorModel.h"
#import "SubjectUserModel.H"

#import "Utils.h"
//图片
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"

#import "MyUMShare.h"

#import "SaveFlow.h"
#import "UITableView+UITableViewTopView.h"

#import "DeliverModel.h"
#import "ReadRecordModel.h"
#import "MatchModel.h"
#import "DeliverData.h"

#import "SubjectAndSaveObject.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"


#import "ArtPopView.h"
#import "ShareModel.h"
#import "SaveFlow.h"
#import "SharePlatform.h"

#import "ToastUtils.h"

//评论

#import "MyCommentTableViewCell.h"
#import "DoubleCommentTableViewCell.h"
#import "DoubleSingleCommentTableViewCell.h"
#import "CommentView.h"
#import "CommiteListViewModel.h"
#import "CommiteModel.h"

#import "AddCommentViewModel.h"
#import "UIImage+GIF.h"
#import "IQKeyboardManager.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface SubjectDetailViewController ()

@property(nonatomic,strong)NSMutableDictionary*testHList;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *bookingButton;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)MediaDetailViewModel *model;

@property(nonatomic,strong)NSMutableArray<InfoContentModel> *contentList;

@property(nonatomic,strong)UITableView *tableView;

//文字
@property(nonatomic,retain)NSString *p;
@property(nonatomic,retain)NSString *s;
//图片
@property(nonatomic,retain)NSString *i;

@property(nonatomic,strong)NSArray<InfoNewSonModel> *sonModel;
@property(nonatomic,strong)NSMutableArray<InfoArticleModel> *articleList;

@property(nonatomic,strong)NSArray<InfoRelateTypesModel> *relatetypes;

@property(nonatomic,strong)NSMutableArray<MatchModel> *match;

///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;

//头部图片
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *nameImageView;

@property(nonatomic,strong)DeliverModel *deliverModel;
@property(nonatomic,strong)DeliverData *deliverData;

@property(nonatomic,strong)SubjectAndSaveObject *subjectTool;

//弹出控件
@property(nonatomic,strong)ArtPopView *artPopView;

@property(nonatomic,strong)ToastUtils *toastUtils;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) CommentView *sendCommentView;
@property (weak, nonatomic) IBOutlet UIButton *shoucangButton;

@property (nonatomic,strong) CommiteListViewModel *commiteViewModel;
@property (nonatomic,strong) AddCommentViewModel *addCommentViewModel;

///上一个被评论的id
@property (nonatomic,copy) NSString *pid;
//评论页数
@property (nonatomic,assign) NSInteger commitPage;
@property (nonatomic,copy)NSMutableArray *commitList;
//资讯页面底部到顶部的切换
//@property (nonatomic,assign)bool isToBottom;
//记录当前用户滑动的位置
//@property (nonatomic,assign)CGPoint userScrollPoint;

@property (weak, nonatomic) IBOutlet UIView *pinglunView;

@property (nonatomic, assign) CGFloat scrollViewHeight;

@property (nonatomic, assign) bool isUserCommite;

@end

@implementation SubjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.testHList = [NSMutableDictionary dictionary];
    self.articleList = [[NSMutableArray<InfoArticleModel> alloc] init];
    self.contentList = [[NSMutableArray<InfoContentModel> alloc]init];
    self.match = [[NSMutableArray<MatchModel> alloc]init];
    
    self.p =@"p";
    self.s =@"strong";
    self.i =@"img";
    self.commitPage = 1;
//    self.isToBottom = YES;
    self.isUserCommite = false;
    
    [self showbackButtonwithTitle:@""];
    
    //默认为0
 
    self.messageLabel.text = @"0";
    self.messageLabel.layer.cornerRadius=self.messageLabel.frame.size.width/2;//裁成圆角
    self.messageLabel.layer.masksToBounds=YES;//隐藏裁剪掉的部分

    [self.bottomBarView setTopLine];
    [self showSingleButton];
    [self initTableView];
    //self.tableView.scrollToTopViewShow = YES;
    [self initdata];
    [self initCommite];
    [self.view insertSubview:self.pinglunView aboveSubview:self.tableView];
}

-(void)initTitleView{
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*(kwidth/2-44*2-30), 40)];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.lineBreakMode =NSLineBreakByTruncatingMiddle;
    
    
    UIView*view = [[UIView alloc]init];
    [self.titleView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self.titleView);
    }];
    [view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerY.equalTo(view);
        make.right.equalTo(view.mas_right);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    self.nameLabel.text =self.model.data.authorName;
    
    self.nameImageView = [[UIImageView alloc] init];
    self.nameImageView.layer.cornerRadius = 16;
    self.nameImageView.layer.masksToBounds = YES;
    
    [self.nameImageView setImageWithURL:[NSURL URLWithString:self.model.data.authorPic] placeholderImage:[UIImage imageNamed:@"pic_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [view addSubview:self.nameImageView];
    
    [self.nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameLabel.mas_left).offset(-5);
        make.centerY.equalTo(view);
        make.left.equalTo(view);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.titleView.hidden = YES;
    //    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topclick:)];
    //
    //    [self.titleView addGestureRecognizer:tapRecognizer];
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        //这边是头部点击事件
        [self_weak_ jumpToZMT];
    }];
    [self.titleView addGestureRecognizer:tap];

    
}

//一个按钮
-(void)showSingleButton{
    
    if (!self.shareButton) {
        
        self.shareButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"ic_morebutton"] with:25.0f];
        
        [self.shareButton setImage:[UIImage imageNamed:@"ic_morebuttonSelected.png"] forState:UIControlStateHighlighted];
        [self.shareButton  addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
   
    UIBarButtonItem*shareItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    
    self.navigationItem.rightBarButtonItems =@[shareItem];
    
}

//两个按钮
-(void)showRightButton{
 
    UIBarButtonItem*shareItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    
    self.bookingButton = [[UIButton alloc]initNavigationButtonWithTitle:@"+ 订阅" color:BlueColor447FF5 height:26];
    self.bookingButton.titleLabel.font = [UIFont systemFontOfSize:11];

    
    self.bookingButton.contentMode = UIViewContentModeCenter;
    [self.bookingButton  addTarget:self action:@selector(subjectClick:) forControlEvents:UIControlEventTouchUpInside];
    self.bookingButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
 
    UIBarButtonItem*bookItem = [[UIBarButtonItem alloc]initWithCustomView:self.bookingButton];

 
    
    self.bookingButton.layer.borderWidth =1;
    self.bookingButton.layer.cornerRadius = 3;
    self.bookingButton.layer.masksToBounds = YES;
    NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self.model.data.authorId];
    if (browse.count==0) {
        self.bookingButton.layer.borderColor = BlueColor447FF5.CGColor;
        [self.bookingButton setBackgroundColor:[UIColor whiteColor]];
        [self.bookingButton setTitle:@"+ 订阅" forState:UIControlStateNormal];
        [self.bookingButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
    }else{
        self.bookingButton.layer.borderColor = BlackColorEEEEEE.CGColor;
        [self.bookingButton setBackgroundColor:[UIColor whiteColor]];
        [self.bookingButton setTitle:@"已订阅" forState:UIControlStateNormal];
        [self.bookingButton setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
    }
    
    [bookItem setImageInsets:UIEdgeInsetsMake(0, 15, 0, -15)];

    self.navigationItem.rightBarButtonItems =@[shareItem,bookItem];
}

-(void)initCommite{

    self.commiteViewModel.request.aid = self.aid;
    self.commiteViewModel.request.page = self.commitPage;
    
    @weakify(self);
    [[RACObserve(self.commiteViewModel, data)
    filter:^BOOL(id value) {
        return  self.commiteViewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        
        NSLog(@"请求了一次");
        if (self.commiteViewModel.data.page_count>0) {
            self.messageLabel.text = [NSString  stringWithFormat:@"%ld",self.commiteViewModel.data.page_count];
            
            if (self.tableView.mj_footer == NULL) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                    self.commiteViewModel.request.page = self.commitPage;
                    [self.tableView.mj_footer beginRefreshing];
                    self.commiteViewModel.request.startRequest = YES;
                }];
            }
            
            
            
            if (self.commitPage == 1) {
                if (self.commiteViewModel.data.totalpage == self.commitPage) {
                    [self.commitList removeAllObjects];
                    [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
                }else{
                    [self.commitList removeAllObjects];
                    self.commitPage++;
                    [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                if (self.commiteViewModel.data.totalpage == self.commitPage) {
                    [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
                }else{
                    self.commitPage++;
                    [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            
//            [self.tableView reloadData];
        }
        
   
        
        
        [self.tableView reloadData];
        
        if (self.isUserCommite) {
            [self.messageButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
       
       
    }];
    self.commiteViewModel.request.startRequest = YES;
}

-(void)initdata{
    self.model = [MediaDetailViewModel SceneModel];
    self.model.request.aid = self.aid;
    self.model.request.model = @"0";
    
    if ([SaveFlow getFlowSign]) {
        self.model.request.model = @"1";
    }
    @weakify(self);
    self.model.request.startRequest = YES;
    [[RACObserve(self.model, data)filter:^BOOL(id value) {
        @strongify(self);
        return self.model.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView dismissWithOutDataView];
        self.shareButton.userInteractionEnabled = YES;
        self.contentList = [self.model.data.content copy];
        
        self.sonModel = self.model.data.carRecommedList;
        self.match = self.model.data.match;
        
        [self.deliverData setinfo:self.contentList matches:self.match];
//        if (!self.listInfo) {
//            self.listInfo = [[PicShowModel alloc]init];
        
            self.listInfo.thumb = self.model.data.thumb;
            self.listInfo.authorName  = self.model.data.authorName;
            self.listInfo.title = self.model.data.title;
            self.listInfo.click  = self.model.data.click;
            self.listInfo.inputtime = self.model.data.inputtime;
            self.listInfo.id = self.model.data.id;
            
            
//        }


        
        self.articleList = [self.model.data.articleList copy];
        self.articleList = [self.deliverModel deliverInfoArticleModel:self.articleList];
        self.relatetypes = self.model.data.relatetypes;
        [self initPhotos];
        
        [self initTitleView];
        
       
        [self saveReadModel];
        
        NSArray *browse = [BrowseKouBeiArtModel findByColumn:@"id" value:self.aid];
        if (![browse count]) {
            if(![self.aid isEqualToString:@""]){
                [self saveBrowesModel];
            }
        }else{
            [self deleteBrowesModel:browse[0]];
            [self saveBrowesModel];
        }
        //[self.tableView layoutIfNeeded];
        [self.tableView reloadData];
    }];
    [[RACObserve(self.model, request)filter:^BOOL(id value) {
        @strongify(self);
        return self.model.request.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView showNetLost];
        self.shareButton.userInteractionEnabled = NO;
        //[self.tableView layoutIfNeeded];
    }];
    [RACObserve([InfoDetailFont shareInstance], fontStyle)subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        //[self.tableView layoutIfNeeded];
    }];

    [[RACObserve(self.addCommentViewModel.request,state)
      filter:^BOOL(id value) {
          return self.addCommentViewModel.request.succeed;
      }]subscribeNext:^(id x) {
          if (x) {
              //发送成功后清除编辑文字
              
              NSLog(@"请求了一次又一次");
              self_weak_.commitPage = 1;
              self_weak_.sendCommentView.messageTextView.text =@"";
              self_weak_.sendCommentView.sendButton.enabled = NO;
              [self_weak_.sendCommentView setHidden:YES];
              self_weak_.commiteViewModel.request.page = self_weak_.commitPage;
              self_weak_.commiteViewModel.request.startRequest = YES;
          }else{
              
          }
      }];
    
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableToTopViewShow =YES;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
   
//    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight)];
//    self.tableView.tableFooterView = tableFooterView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
    }]; 
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PTableViewCell" bundle:nil] forCellReuseIdentifier:@"PTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImgTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RelateCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"RelateCarTableViewCell"];
    
    [self.tableView registerNib:nibFromClass(RecommendTableViewCell) forCellReuseIdentifier:classNameFromClass(RecommendTableViewCell)];
    
    [self.tableView registerNib:nibFromClass(PublicNormalTableViewCell)
         forCellReuseIdentifier:classNameFromClass(PublicNormalTableViewCell)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShareTableViewHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ShareTableViewHeaderFooterView"];
    
    [self.tableView registerNib:nibFromClass(RelateTypeCarTableViewCell) forCellReuseIdentifier:@"RelateTypeCarTableViewCell"];
    
    [self.tableView registerNib:nibFromClass(ZiMeiTiRelateCarTableViewCell) forCellReuseIdentifier:classNameFromClass(ZiMeiTiRelateCarTableViewCell)];
    
    [self.tableView registerClass:[TableSubjectTopHeaderFooterView class]  forHeaderFooterViewReuseIdentifier:classNameFromClass(TableSubjectTopHeaderFooterView)];
    
    //评论
    [self.tableView registerNib:nibFromClass(MyCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(MyCommentTableViewCell)];
    
    [self.tableView registerNib:nibFromClass(DoubleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleCommentTableViewCell)];
    
    [self.tableView registerNib:nibFromClass(DoubleSingleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell)];
    
    [self.view insertSubview:self.bottomBarView aboveSubview:self.tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.commiteViewModel.data.isNotEmpty) {
        return 4;
    }
    
    if (self.model.data.isNotEmpty ) {
        return 3;
    }

    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            if ([self.contentList isNotEmpty]) {
                return self.contentList.count;
            }else{
                return 0;
            }
        }
            break;
        case 1:
        {
            if ([self.relatetypes isNotEmpty]) {
                return self.relatetypes.count;
            }else{
                return 0;
            }
            
        }
            break;
        case 2:
        {
            if ([self.articleList isNotEmpty]) {
                return self.articleList.count;
            }else{
                return 0;
            }
        }
            break;
            //这边是评论条数
        case 3:{
            if (self.commitList.count>0) {
                return self.commitList.count;
            }else{
                return 0;
            }
            
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 ) {
        InfoContentModel *content = self.contentList[indexPath.row];
//        if ([content.type isEqualToString:self.i]) {
//            InfoContentModel *content = self.contentList[indexPath.row];
//            if ([content.width intValue]>0) {
//                return kwidth*[content.high intValue] / [content.width intValue];
//            }
//            return UITableViewAutomaticDimension;
//        }
        if ([content.type isEqualToString:self.i]) {
            //            InfoContentModel *content = self.contentList[indexPath.row];
            //            if ([content.width integerValue] > 0) {
            //                return kwidth*[content.high intValue] / [content.width intValue];
            //            }else{
            //                return (kwidth-30)*3/4;
            //            }
            
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey: content.value];
            
            // 没有找到已下载的图片就使用默认的占位图，当然高度也是默认的高度了，除了高度不固定的文字部分。
            if (!image) {
                image = [UIImage imageNamed:@"默认图片330_165.png"];
            }
            
            //手动计算cell
            CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
            return imgHeight;
        }

    }else if(indexPath.section == 1){
        return 95;
    }else if(indexPath.section == 2){
        return 95;
    }else if(indexPath.section == 3){
        return UITableViewAutomaticDimension;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
//        InfoContentModel *content = self.contentList[indexPath.row];
//        if ([content.type isEqualToString:self.i]) {
//            InfoContentModel *content = self.contentList[indexPath.row];
//            if ([content.width intValue]>0) {
//                return kwidth*[content.high intValue] / [content.width intValue];
//            }
            return 150;
           
//        }
    }else if(indexPath.section == 1){
        return 95;
    }else if(indexPath.section == 2){
        return 95;
    }else if(indexPath.section == 3){
        return 200;
    }
    return 44;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        InfoContentModel *content = self.contentList[indexPath.row];
        if ([content.type isEqualToString:self.p]||[content.type isEqualToString:self.s]) {
            PTableViewCell *titlecell = [tableView dequeueReusableCellWithIdentifier:@"PTableViewCell" forIndexPath:indexPath];
            [titlecell setMatch:self.match];
            [titlecell setinfo:content];
    
            titlecell.selectionStyle = UITableViewCellSelectionStyleNone;
            return titlecell;
        }else{
         
            ImgTableViewCell *imgcell = [tableView dequeueReusableCellWithIdentifier:@"ImgTableViewCell" forIndexPath:indexPath];
          
            NSString *imgURL = [content.value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
//                NSString *imgURL = @"http://qnwww2.autoimg.cn/youchuang/g17/M03/7C/29/autohomecar__wKjBxlnDjCKAcFS2AABonIAUVIo077.jpg?imageView2/2/w/752|watermark/2/text/QUzpopHpgZMNCuaxvei9puS5i-Wutg==/font/5b6u6L2v6ZuF6buR/fontsize/270/fill/d2hpdGU=/dissolve/100/gravity/SouthEast/dx/5/dy/5";
// 
//            imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
// 
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
            
            if ( !cachedImage ) {
                [self downloadImage:imgURL forIndexPath:indexPath];
                // [imgcell.btn setBackgroundImage:[UIImage imageNamed:@"默认图片330_165.png"] forState:UIControlStateNormal];
                [imgcell.img setImage:[UIImage imageNamed:@"默认图片330_165.png"] ];
            } else {
                if (cachedImage.images !=NULL) {
                    //这边是gif
                    
                    NSData *data =UIImageJPEGRepresentation(cachedImage, 1.0);
                    UIImage *gifImage = [UIImage sd_animatedGIFWithData:data];
                     imgcell.img.image = gifImage;
                }else{
                    [imgcell.img setImage:cachedImage ];
                }
            }
            
            imgcell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return imgcell;

        }
    }else if(indexPath.section ==1){
        ZiMeiTiRelateCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiMeiTiRelateCarTableViewCell"];
        InfoRelateTypesModel *content = self.relatetypes[indexPath.row];
        [cell setData:content];
        [cell setArtType:self.arttype];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row != self.relatetypes.count-1) {
            [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
       
        
        return cell;
    }else if(indexPath.section ==2){
        InfoArticleModel *content = self.articleList[indexPath.row];
        
        if ([content.artType isEqualToString:zimeiti]) {
            PublicNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicNormalTableViewCell" forIndexPath:indexPath];
            [cell setData:content];
            if (indexPath.row != self.articleList.count-1) {
                [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTableViewCell" forIndexPath:indexPath];
            [cell.img setImageWithURL:[NSURL URLWithString:content.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            cell.title.text = content.title;
            cell.title.numberOfLines = 0;
            cell.view.text = content.click;
            cell.time.text = content.inputtime;
            
            if (indexPath.row != self.articleList.count-1) {
                [cell setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(indexPath.section == 3){
        CommiteModel *model = self.commitList[indexPath.row];
        if (![model.recontent isNotEmpty]) {
            MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(MyCommentTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setMessageModel:model];
            [cell setMessageModelIndex:indexPath.row];
            [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else{
            
            if (model.maxnum>2) {
                DoubleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleCommentTableViewCell) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell setMessageModel:model];
                [cell setMessageModelIndex:indexPath.row];
                [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
                 
                return cell;
            }else{
                
                DoubleSingleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell) forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell setMessageModel:model];
                [cell setMessageModelIndex:indexPath.row];
                [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
               
              
                return cell;
            }
            
        }
    }
    
    return nil;
}
///点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        InfoContentModel *content = self.contentList[indexPath.row];
        
        if ([content.type isEqualToString:self.i]) {
            int count = 0;
            for (ZLPhotoPickerBrowserPhoto *photo in self.photos) {
                if([photo.photoURL.absoluteString isEqual:content.value]){
                    break;
                }
                count++;
            }
            [self jump2photo:count];
        }
        
    }else if(indexPath.section == 1){
        //车系详情
        InfoRelateTypesModel *model = self.relatetypes[indexPath.row];
        CarDeptViewController *controller =[[CarDeptViewController alloc] init];
        //UIViewController *controller = [[UIViewController alloc] init];
        controller.chexiid = model.typeid;
        controller.picture = model.picurl;
        [URLNavigation pushViewController:controller animated:YES];
        
    }else if(indexPath.section == 2){
       
        //UIViewController *controller = [[UIViewController alloc] init];
        InfoArticleModel *art = self.articleList[indexPath.row];
        if ([art.artType isEqualToString:zimeiti]) {
            //文章详情
            SubjectDetailViewController *controller = [[SubjectDetailViewController alloc] init];
            controller.aid = art.id;
            PicShowModel *model = [[PicShowModel alloc] init];
            
            model.artType = zimeiti;
            model.thumb = art.thumb;
            model.title = art.title;
            model.click = art.click;
            model.inputtime = art.inputtime;
            model.authorName = art.authorName;
            model.id = art.id;
            
            controller.listInfo = model;
            [URLNavigation pushViewController:controller animated:YES];
        }else{
            //文章详情
            ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
            controller.aid = art.id;
//            PicShowModel *model = [[PicShowModel alloc] init];
            
            
            controller.artType = wenzhang;
//            model.thumb = art.thumb;
//            model.title = art.title;
//            model.click = art.click;
//            model.inputtime = art.inputtime;
//            model.authorName = art.authorName;
//            model.id = art.id;
//
//            controller.listInfo = model;
            [URLNavigation pushViewController:controller animated:YES];
        }
       
        if ([art.isRead isEqualToString:notread]) {
            art.isRead = isread;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
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

//初始化列表
-(void)initPhotos{
    if(!self.photos){
        self.photos = [[NSMutableArray alloc]init];
        for (InfoContentModel *model in self.contentList) {
            if([model.type isEqualToString:@"img"]){
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:model.value];
                [self.photos addObject:photo];
            }
        }
    }
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        ShareTableViewHeaderFooterView *footView = [[ShareTableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 160)];
        footView.shareUrl = self.model.data.arcurl;
        footView.title = self.model.data.title;
        footView.model = self.model.data;
        footView.thumb = self.listInfo.thumb;
        
        footView.contentView.backgroundColor = [UIColor whiteColor];
        return footView;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
            view.backgroundColor =BlackColorF1F1F1;
            return view;
            //        TableViewFooterView *footView = [[TableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 10)];
            //            footView.image.hidden =YES;
            ////        footView.label.text = @"查看相关车型对比";
            ////        footView.label.textColor =LabelTextblueColor;
            ////        footView.label.font = [UIFont italicSystemFontOfSize:14];
            ////
            ////        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap)];
            ////            [tapRecognizer setNumberOfTapsRequired:1];
            ////        [footView addGestureRecognizer:tapRecognizer];
            ////        footView.userInteractionEnabled =YES;
            //        footView.label.backgroundColor = cutlineback;
            //        return footView;
        }
    }else if(section ==2){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
        view.backgroundColor =BlackColorF1F1F1;
        return view;
    }
    return nil;
}

-(void)handlTap{
    CarDeptViewController *controller = [[CarDeptViewController alloc] init];
    controller.chexiid = self.model.data.brandTypeId;
    controller.picture = self.listInfo.thumb;
    [URLNavigation pushViewController:controller animated:YES];
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.model.data.isNotEmpty) {
            TableSubjectTopHeaderFooterView *headview =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSubjectTopHeaderFooterView"];
            headview.subjectObject = self.subjectTool;
      
            [headview setInfoData:self.model.data];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            @weakify(self)
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                //这边是头部点击事件
                [self_weak_ jumpToZMT];
            }];
            [headview addGestureRecognizer:tap];
            
            return headview;
        }
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.label.text = @"相关车系";
            [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headview.label);
                make.bottom.equalTo(headview);
            }];
            headview.noimage =YES;
            headview.image.hidden =NO;
           [headview.image setBackgroundColor:BlackColor333333];
            headview.label.textColor =BlackColor333333;
            headview.contentView.backgroundColor = [UIColor whiteColor];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }else if(section ==2){
        if (self.articleList.count>0) {
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.noimage =YES;
            headview.image.hidden =NO;
            headview.label.text = @"相关文章";
           [headview.image setBackgroundColor:BlackColor333333];
            [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headview.label);
                make.bottom.equalTo(headview);
            }];
            headview.label.textColor =BlackColor333333;
            headview.contentView.backgroundColor = [UIColor whiteColor];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }else if(section == 3){
        if (self.commitList.count>0) {
            TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
            headview.noimage =YES;
            headview.image.hidden =NO;
            headview.label.text = @"评论";
           [headview.image setBackgroundColor:BlackColor333333];
            [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headview.label);
                make.bottom.equalTo(headview);

            }];
                headview.label.textColor =BlackColor333333;
            headview.contentView.backgroundColor = [UIColor whiteColor];
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            return headview;
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (self.model.data.title.length>10) {
            return 150;
        }else{
            return 120;
        }
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            return 25;
        }return 0.000001;
    }else if(section ==2){
        return 25;
    }else if(section ==3){
        if (self.commitList.count>0){
        return 25;
        }
    }
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 160;
    }else if(section ==1){
        if (self.relatetypes.count>0) {
            return 10;
        }return 0.0001;
    }else if(section ==2){
        if (self.commitList.count>0) {
            return 10;
        }return 0.0001;
    }
    return 0.0001;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)shareButtonClicked:(UIButton*)button{
    [self initPopView];
}


///这边是用来重新登录并且绘制界面
-(void)updateView{
    
    if ([[UserModel shareInstance].uid isNotEmpty]){
    //头部按钮
    NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
    if ( [records count] ) {
//        [self.artPopView.commonItems enumerateObjectsUsingBlock:^(ShareModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.name isEqualToString:@"收藏"]) {
//                obj.imageName = @"ic_已收藏";
//            }
//            *stop = NO;
//        }];
        
        [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];

    }
    
        
        
    //头部订阅刷新
        [self.tableView reloadData];
    }
}

//本地收藏
-(void)saveModel{
    KouBeiArtModel *art = [[KouBeiArtModel alloc]init];
    
    if ([self.listInfo isNotEmpty]) {
        art.imgurl = self.listInfo.thumb;
        art.title = self.listInfo.title;
        art.click = self.listInfo.click;
        art.authorName = self.listInfo.authorName;
        
        art.colId = self.listInfo.id;
        art.tag = artInfo;
        art.artType = self.listInfo.artType;

        
        @weakify(self)
        self.subjectTool.infoBlock = ^(bool isok) {
            if (isok) {
//                [self_weak_.artPopView.commonItems enumerateObjectsUsingBlock:^(ShareModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.name isEqualToString:@"收藏"]) {
//                        obj.imageName = @"ic_已收藏";
//                    }
//                    *stop = NO;
//                }];
                [self_weak_.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];
                [self_weak_ showSaveSuccess];
            }else{
                [self_weak_ showSaveSuccessWithTitle:@"收藏失败"];
            }
        };
        [self.subjectTool InfoSaveObject:art typeid:artInfo];
    }
    
}

-(void)saveBrowesModel{
    BrowseKouBeiArtModel *model = [[BrowseKouBeiArtModel alloc] init];
    
    model.pic = self.listInfo.thumb;
    model.name = self.listInfo.title;
    model.views = self.listInfo.click;
    model.time = self.listInfo.inputtime;
    model.authorName = self.listInfo.authorName;
    model.id = self.listInfo.id;
    model.tag = artInfo;
    model.arttype = self.listInfo.artType;
    
    if([model.id isNotEmpty]){
        [model save];
    }
    
}

//保存阅读信息
-(void)saveReadModel{
    NSArray *model = [ReadRecordModel findByColumn:@"id" value:self.listInfo.id];

    if (![model count]) {
        ReadRecordModel *model = [[ReadRecordModel alloc] init];
        model.id = self.listInfo.id;
        [model save];
    }
    
}

-(void)deleteBrowesModel:(BrowseKouBeiArtModel *) model{
    BrowseKouBeiArtModel *temp = model;
    [temp deleteSelf];
}

//删除订阅
-(void)deleteMode{
    NSArray *art = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
    if ([art count]) {
        KouBeiArtModel *temp = art[0];

        @weakify(self)
        self.subjectTool.infoBlock = ^(bool isok) {
            if (isok) {
                
//                [self_weak_.artPopView.commonItems enumerateObjectsUsingBlock:^(ShareModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj.name isEqualToString:@"收藏"]) {
//                        obj.imageName = @"ic_收藏";
//                    }
//                    *stop = NO;
//                }];
                [self_weak_.shoucangButton setImage:[UIImage imageNamed:@"favouriteBlack"] forState:UIControlStateNormal];

                [self_weak_ showSaveRemove];
            }else{
                [self_weak_ showSaveSuccessWithTitle:@"取消失败"];
            }
        };
        [self.subjectTool InfoMoveObject:temp typeid:artInfo];
    }
}


//头部滑动显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
 
    if (scrollView.contentOffset.y > [self tableView:self.tableView heightForHeaderInSection:0]) {
        self.navigationItem.titleView.hidden = NO;
        if (self.navigationItem.rightBarButtonItems.count!=2) {
            [self showRightButton];
        }
    }else{
        self.navigationItem.titleView.hidden = YES;
        if (self.navigationItem.rightBarButtonItems.count!=1) {
            [self showSingleButton];
        }
  
    }
    
    if ([self.tableView headerViewForSection:3].frame.origin.y!=0) {
        self.scrollViewHeight = [self.tableView headerViewForSection:3].frame.origin.y;
        NSLog(@"不为0");
       
    }else{
        NSLog(@"为0");
    }

    if (scrollView.contentOffset.y < self.scrollViewHeight) {
            [self.pinglunView setHidden:YES];
//            self.isToBottom = NO;
            NSLog(@"1");
    }else{
        if (self.scrollViewHeight ==0) {
            [self.pinglunView setHidden:YES];
//            self.isToBottom = NO;
            NSLog(@"2");
        }else{
            [self.pinglunView setHidden:NO];

//            self.isToBottom = YES;
            NSLog(@"3");
        }
    }
    

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y<[self.tableView headerViewForSection:3].frame.origin.y) {
////        self.userScrollPoint = [self.tableView headerViewForSection:3].frame.origin;
//        self.isToBottom = NO;
//
//    }else{
//        self.userScrollPoint = scrollView.contentOffset;
//        self.isToBottom = YES;
//    }

}

//跳转去自媒体的方法
-(void)jumpToZMT{
//    NSLog(@"tap");
    SubscribeDetailViewController *controller = [[SubscribeDetailViewController alloc] init];
    SubjectUserModel *model = [[SubjectUserModel alloc] init];
    
    NSArray*array =  [SubjectUserModel findByColumn:@"authorId" value: self.model.data.authorId]  ;
    
    if (array.count) {
        model = array[0];
    }else{
        model.authorName = self.model.data.authorName;
        model.imgurl = self.model.data.authorPic;
        model.authorId = self.model.data.authorId;
    }

    controller.model = model;
    
    [URLNavigation pushViewController:controller animated:YES];
}


- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    // 利用 SDWebImage 框架提供的功能下载图片
    
//    NSString *temp_url = @"http://qnwww2.autoimg.cn/youchuang/g17/M03/7C/29/autohomecar__wKjBxlnDjCKAcFS2AABonIAUVIo077.jpg?imageView2/2/w/752|watermark/2/text/QUzpopHpgZMNCuaxvei9puS5i-Wutg==/font/5b6u6L2v6ZuF6buR/fontsize/270/fill/d2hpdGU=/dissolve/100/gravity/SouthEast/dx/5/dy/5";
// 
//    
//    imageURL = [temp_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[GCDQueue globalQueue]queueBlock:^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // do nothing
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            
            
            if (!error) {
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self_weak_.tableView reloadData];
                });
                
            }
        }];
        
    }];
}


/// 初始化弹出的界面
-(ArtPopView *)artPopView{
    if (!_artPopView) {
        _artPopView = [[ArtPopView alloc] init];
        _artPopView.delegate = self;
        _artPopView.shareItems = [SharePlatform getSharePlatforms];
        
        //第一版本
        NSMutableArray *comm = [NSMutableArray arrayWithCapacity:3];
        
//        ShareModel *model = [[ShareModel alloc] init]; 
        
        //头部按钮
//        NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
//        model.name = @"收藏";
//        if ( [records count] ) {
//            //已经存在了
//            model.imageName = @"ic_已收藏";
//        }else{
//            //没有存在
//            model.imageName = @"ic_收藏";
//        }
//        
//        [comm addObject:model];
        
        ShareModel *model1 = [[ShareModel alloc] init];
        model1.name = @"字号设置";
        model1.imageName = @"ic_字号";
        [comm addObject:model1];
        
        ShareModel *model2 = [[ShareModel alloc] init];
        model2.name = @"省流量模式";
        if ([SaveFlow getFlowSign]) {
            model2.imageName = @"ic_已开启省流量";
        }else{
            model2.imageName = @"ic_省流量";
        }
        
        [comm addObject:model2];
        
        _artPopView.commonItems = [comm copy];
        
          }
    return _artPopView;
}

-(void) initPopView{
    self.artPopView.artPopViewType = ArtPopViewTypeSetting;
    [self.artPopView show];
}



-(void)Handleclick:(ShareModel *)model{
    if ([model.tag isEqualToString:@"1"]) {
        ///组织内容
        __block NSString*content;
        [self.contentList enumerateObjectsUsingBlock:^(InfoContentModel* contentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([contentModel.type isEqualToString:self.p]||[contentModel.type isEqualToString:self.s]) {
                
                content = contentModel.value;
                *stop = YES;
                
            }
        }];
        
        if (!content.isNotEmpty) {
            content = self.model.data.title;
        }
        
        if ([model.name isEqualToString:@"微信"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeWechat title:self.model.data.title conent:content artUrl:self.model.data.arcurl picUrl:self.listInfo.thumb];
        }
        
        if ([model.name isEqualToString:@"朋友圈"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.model.data.title conent:content artUrl:self.model.data.arcurl picUrl:self.listInfo.thumb];
        }
        
        if ([model.name isEqualToString:@"QQ好友"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeQQ title:self.model.data.title conent:content artUrl:self.model.data.arcurl picUrl:self.listInfo.thumb];
        }
        
        if ([model.name isEqualToString:@"QQ空间"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.model.data.title conent:content artUrl:self.model.data.arcurl picUrl:self.listInfo.thumb];
        }
    }else{
        if ([model.name isEqualToString:@"收藏"]) {
            if([model.imageName isEqualToString:@"ic_已收藏"]){
                [self deleteMode];
            }else{
                if ([[UserModel shareInstance].uid isNotEmpty]) {
                    [self saveModel];
                }else{
                    //这边是用来重新登录并且绘制界面
                    ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
                    @weakify(self)
                    controller.loginSuccessDataBlock = ^{
                        [self_weak_ updateView];
                    };
                    [URLNavigation pushViewController:controller animated:YES];
                }
            }
        }
        
        if ([model.name isEqualToString:@"省流量模式"]) {
            if ([SaveFlow getFlowSign]) {
                [SaveFlow setFlowSign:false];
                model.imageName = @"ic_省流量";
                [self.toastUtils showWithMessage:@"已关闭省流量模式" fatherView:self.view];
            }else {
                [SaveFlow setFlowSign:true];
                model.imageName = @"ic_已开启省流量";
                [self.toastUtils showWithMessage:@"已开启省流量模式" fatherView:self.view];
            }
        }
       
    }
}
-(void)changeFont:(NSInteger)type{
    [InfoDetailFont shareInstance].fontStyle = type;
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
////    
////    //头部按钮
////    NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
////        if ( [records count] ) {
////        //已经存在了
////            [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];
////     
////    }else{
////        //没有存在
////            [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteBlack.png"] forState:UIControlStateNormal];
////    }
//
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //取消订阅的时候需要返回状态
    [self updateView];
    
    if (self.fatherControllerType == MESSAGECONTROLLER) {
        [self autojump2commite];
    }
}

-(void)commentSend{
    self.addCommentViewModel.request.pid = self.pid;
    self.addCommentViewModel.request.aid = self.aid;
    self.addCommentViewModel.request.uid = [UserModel shareInstance].uid;
    self.addCommentViewModel.request.type = self.arttype;
    self.addCommentViewModel.request.content = self.sendCommentView.messageTextView.text;

    self.addCommentViewModel.request.startRequest = YES;
    
    [self.sendCommentView dismiss];
}

#pragma mark 评论点击区

///commentSend的方法是发送信息
-(void)cellCommentMessage:(UIButton *)sender{
    
    
    self.isUserCommite = true;
    
    CommiteModel *model = self.commitList[sender.tag];
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        @weakify(self)
        controller.loginSuccessDataBlock = ^{
            self_weak_.pid = @"0";
            self_weak_.sendCommentView.hidden = NO;
            [self_weak_.sendCommentView.messageTextView becomeFirstResponder];
        };
        [URLNavigation pushViewController:controller animated:YES];
        return ;
    }

    self.sendCommentView.messageField.hidden = NO;
    self.sendCommentView.messageField.placeholder = [NSString stringWithFormat:@"回复%@的评论",model.username];
    self.sendCommentView.hidden = NO;
    self.pid = model.id;
    [self.sendCommentView.messageTextView becomeFirstResponder];
    
    
}


//按钮发表评论的方法
- (IBAction)commiteMessage:(id)sender {
    
    
    self.isUserCommite = true;
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        @weakify(self)
        controller.loginSuccessDataBlock = ^{
            self_weak_.pid = @"0";
            self_weak_.sendCommentView.hidden = NO;
            [self_weak_.sendCommentView.messageTextView becomeFirstResponder];
        };
        [URLNavigation pushViewController:controller animated:YES];
        return ;
    }
 
    self.sendCommentView.messageTextView.text=@"";
    self.sendCommentView.messageField.placeholder = @"请填写评论内容";
    self.pid = @"0";
    self.sendCommentView.hidden = NO;
   [self.sendCommentView.messageTextView becomeFirstResponder];

}

//自动跳转
-(void)autojump2commite{
    
    if (self.commiteViewModel.data.list.count!=0) {
        
//        if (self.isToBottom ) {
        
           [self reBuildFooterView];
            
            [self.tableView layoutIfNeeded];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                        atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                [self.tableView layoutIfNeeded];
                
             
                
//                self.isToBottom = NO;
            });
//
//        }else{
//            self.isToBottom = YES;
//            [self.tableView scrollsToTop];
////            [self.tableView setContentOffset:self.userScrollPoint animated:NO];
//
//        }
    }else{
        
        if (self.articleList.count>0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.articleList.count-1 inSection:2];
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }else if(self.relatetypes.count>0){
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.relatetypes.count-1 inSection:1];
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }

    }
}

- (IBAction)jump2commite:(id)sender {
    
    if (self.commiteViewModel.data.list.count!=0) {

//        if (self.isToBottom ) {
        
        [self reBuildFooterView];
            [self.tableView layoutIfNeeded];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                        atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                [self.tableView layoutIfNeeded];
                
                [self reBuildFooterView];
                
//                self.isToBottom = NO;
            });
            
//        }else{
//            self.isToBottom = YES;
//
//
//        }
    }else{
        
        if (self.articleList.count>0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.articleList.count-1 inSection:2];
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }else if(self.relatetypes.count>0){
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.relatetypes.count-1 inSection:1];
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }

        [self.commitButton  sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
    }
}
- (IBAction)shoucang:(id)sender {
    
    
    //头部按钮
    NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
    if ( [records count] ) {
        //已经存在了
        [self deleteMode];
        
    }else{
        //没有存在
        if ([[UserModel shareInstance].uid isNotEmpty]) {
            [self saveModel];
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
- (IBAction)share:(id)sender {
      self.artPopView.artPopViewType = ArtPopViewTypeShare;
      [self.artPopView show];
}

#pragma 界面头部订阅

-(void)subjectClick:(UIButton*)button {
    
    //未登录的时候先登录
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
        return;
    }
    
    if([self.bookingButton.titleLabel.textColor isEqual:BlueColor447FF5]){
        
        @weakify(self)
        self.subjectTool.subjectBlock = ^(bool isok) {
            if (isok) {
                self_weak_.bookingButton.layer.borderColor = BlackColorEEEEEE.CGColor;
                [self_weak_.bookingButton setTitle:@"已订阅" forState:UIControlStateNormal];
                [self_weak_.bookingButton setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
            }
        };
        
        [self saveSubjectModel:self.model.data.authorId authorName:self.model.data.authorName authorPic:self.model.data.authorPic];
    }else{
        //点击不可以取消
        SubscribeDetailViewController *controller = [[SubscribeDetailViewController alloc] init];
        SubjectUserModel *model = [[SubjectUserModel alloc] init];
        model.authorName = self.model.data.authorName;
        model.imgurl = self.model.data.authorPic;
        model.authorId = self.model.data.authorId;
        
        controller.model = model;
        
        [URLNavigation pushViewController:controller animated:YES];
    }
}

-(void)saveSubjectModel:(NSString*) authorId authorName:(NSString *)name authorPic:(NSString *)pic{
    SubjectUserModel *model = [[SubjectUserModel alloc] init];
    model.authorId = authorId;
    model.authorName = name;
    model.imgurl = pic;
    [self.subjectTool SubjectSaveObject:model];
}

//重新绘制界面
-(void)reBuildFooterView{
    
    
    __block CGFloat height = 0;
    NSInteger section = 3;
    
    [self.commitList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath*indexPath =[NSIndexPath indexPathForRow:idx inSection:section];
        CommiteModel *model = self.commitList[indexPath.row];
        if (![model.recontent isNotEmpty]) {
            height+= [self.tableView fd_heightForCellWithIdentifier:classNameFromClass(MyCommentTableViewCell) cacheByIndexPath:indexPath configuration:^(MyCommentTableViewCell* cell) {
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setMessageModel:model];
                [cell setMessageModelIndex:indexPath.row];
                [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
                if (indexPath.row == self.commitList.count - 1) {
                    [cell setBottomLineShow:NO];
                }
            }];
            
        }else{
            if (model.maxnum>2) {
                height+= [self.tableView fd_heightForCellWithIdentifier:classNameFromClass(DoubleCommentTableViewCell) cacheByIndexPath:indexPath configuration:^(DoubleCommentTableViewCell* cell) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell setMessageModel:model];
                    [cell setMessageModelIndex:indexPath.row];
                    [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
                    if (indexPath.row == self.commitList.count - 1) {
                        [cell setBottomLineShow:NO];
                    }
                }];
                
                
            }else{
                height+= [self.tableView fd_heightForCellWithIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell) cacheByIndexPath:indexPath configuration:^(DoubleSingleCommentTableViewCell* cell) {
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell setMessageModel:model];
                    [cell setMessageModelIndex:indexPath.row];
                    [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
                    if (indexPath.row == self.commitList.count - 1) {
                        [cell setBottomLineShow:NO];
                    }
                }];
            }
        }
        
    }];
    
    
    
    NSLog(@"最终 %lf",height);
    
    if(height < kheight){
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight-height-64-50-50-20)];
        //        [tableFooterView setBackgroundColor:[UIColor redColor]];
        self.tableView.tableFooterView = tableFooterView;
    }else{
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //        [tableFooterView setBackgroundColor:[UIColor redColor]];
        self.tableView.tableFooterView = tableFooterView;
    }
    
    [self.tableView reloadData];
}

#pragma mark 懒加载
-(SubjectAndSaveObject *)subjectTool{
    if(!_subjectTool){
        _subjectTool = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectTool;
}

-(DeliverModel *)deliverModel{
    if (!_deliverModel) {
        _deliverModel = [[DeliverModel alloc] init];
    }
    return _deliverModel;
}

-(DeliverData *)deliverData{
    if (!_deliverData) {
        _deliverData = [[DeliverData alloc] init];
    }
    return _deliverData;
}


-(ToastUtils *)toastUtils{
    if (!_toastUtils) {
        _toastUtils = [[ToastUtils alloc]init];
    }
    return _toastUtils;
}

-(CommentView *)sendCommentView{
    if (!_sendCommentView) {
        _sendCommentView = [[CommentView alloc]init];
        [[UIApplication sharedApplication].keyWindow addSubview:_sendCommentView ];
        _sendCommentView.messageField.placeholder = @"请填写评论内容";
   
        [_sendCommentView.sendButton addTarget:self action:@selector(commentSend) forControlEvents:UIControlEventTouchUpInside];
        [_sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        @weakify(self);
        [_sendCommentView dismiss:^{
            @strongify(self);
            NSString*str  = [self.sendCommentView.messageTextView.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
              self.tableView.tableToTopViewShow = YES;
            _sendCommentView.messageField.hidden = NO;
            _sendCommentView.messageTextView.text =@"";
//            [_sendCommentView.messageField becomeFirstResponder];
            //            if (str.length > 0) {
            //                self.commentField.text = [NSString stringWithFormat:@"[草稿]%@",str];
            //            }else{
            //                self.commentField.text =@"";
            //            }
            
        }];
        [_sendCommentView setHidden:YES];
    }
    return _sendCommentView;
}

-(CommiteListViewModel *)commiteViewModel{
    if (!_commiteViewModel) {
        _commiteViewModel = [CommiteListViewModel SceneModel];
    }
    return _commiteViewModel;
}

-(AddCommentViewModel *)addCommentViewModel{
    if (!_addCommentViewModel) {
        _addCommentViewModel = [AddCommentViewModel SceneModel];
    }
    return _addCommentViewModel;
}

-(NSMutableArray *)commitList{
    if (!_commitList) {
        _commitList = [NSMutableArray arrayWithCapacity:5];
    }
    return _commitList;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable =NO;
    
    NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self.model.data.authorId];
    if (browse.count==0) {
        self.bookingButton.layer.borderColor = BlueColor447FF5.CGColor;
        [self.bookingButton setBackgroundColor:[UIColor whiteColor]];
        [self.bookingButton setTitle:@"+ 订阅" forState:UIControlStateNormal];
        [self.bookingButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
    }else{
        self.bookingButton.layer.borderColor = BlackColorEEEEEE.CGColor;
        [self.bookingButton setBackgroundColor:[UIColor whiteColor]];
        [self.bookingButton setTitle:@"已订阅" forState:UIControlStateNormal];
        [self.bookingButton setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
    }
 
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable =YES;
    [self.sendCommentView.messageTextView resignFirstResponder];
    self.sendCommentView = nil;
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
