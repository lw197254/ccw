//
//  SubscribeDetailViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/4/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SubscribeDetailViewController.h"
#import "SubscribeDetailTableViewCell.h"
#import "SubscribeDetailViewModel.h"
#import "ArtInfoViewController.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"
//查看已变色
#import "ReadRecordModel.h"
#import "DeliverModel.h"
#import "SubjectAndSaveObject.h"


#define topBackgroundViewHeight 388/2+StatusHeight-20
#define  orginalHeadImageWidth 55
#define  newHeadImageWidth 30
#
@interface SubscribeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
///navigationbar半透明图
@property(nonatomic,strong)UIView*topMaskView;
///背景蓝色
@property(nonatomic,strong)UIImageView*topBackgroundView;
///title两边的图片
@property(nonatomic,strong)UIImageView*leftImageView;
@property(nonatomic,strong)UIImageView*rightImageView;
///用户名
@property(nonatomic,strong)UILabel*titleLabel;
///头像
@property(nonatomic,strong)UIImageView*headImageView;
///订阅按钮
@property(nonatomic,strong)UIButton*subscribeButton;
@property(nonatomic,strong)UIButton*customBackButton;
@property(nonatomic,strong)UIPanGestureRecognizer*pan;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)SubscribeDetailViewModel*viewModel;
@property(nonatomic,strong)UITableView*maskTableView;

@property(nonatomic,strong)DeliverModel *deliverModel;
@property(nonatomic,strong)SubjectAndSaveObject *subjectObject;


@property(nonatomic,assign)NSInteger page;
///是否订阅
@property(nonatomic,assign)BOOL isSubject;
@end

@implementation SubscribeDetailViewController

-(SubjectAndSaveObject *)subjectObject{
    if (!_subjectObject) {
        _subjectObject = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden= YES;
    self.navigationController.navigationBar.translucent = YES;
    self.deliverModel = [[DeliverModel alloc] init];
 

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewModel = [SubscribeDetailViewModel SceneModel];
    self.viewModel.deliverModel = self.deliverModel;
    
    [self configUI];
    
    [self addRAC];
   //    [self.tableView bringSubviewToFront:self.tableView.mj_header];
//    self.tableView.mj_header.transform = CGAffineTransformMakeTranslation(0, topBackgroundViewHeight);
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.showList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubscribeDetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(SubscribeDetailTableViewCell)];
    SubscribeDetailArticleModel*model = self.viewModel.showList[indexPath.row];
    PicShowModel*pic = [[PicShowModel alloc]init];
    pic.authorName = model.authorName;
    pic.artType = @"2";
    pic.id = model.id;
    pic.title = model.title;
    pic.thumb = model.thumb;
    pic.inputtime = model.addtime;
    pic.click = model.click;
    pic.isRead = model.isRead;
    [cell setData:pic];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     SubscribeDetailArticleModel*model = self.self.viewModel.showList[indexPath.row];
//    PicShowModel*pic = [[PicShowModel alloc]init];
//    pic.authorName = model.authorName;
//    pic.artType = @"2";
//    pic.id = model.id;
//    pic.title = model.title;
//    pic.thumb = model.thumb;
//    pic.inputtime = model.addtime;
//    pic.click = model.click;
//    pic.isRead = model.isRead;
    ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
    controller.aid = model.id;
    controller.artType = zimeiti;
    [URLNavigation pushViewController:controller animated:YES];
    
    if ([model.isRead isEqualToString:notread]) {
        model.isRead = isread;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190/2;
}
-(void)addRAC{
    @weakify(self);
   
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
         @strongify(self);
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (self.viewModel.showList.count > 0) {
           
             self.page ++;
            
            [self.tableView dismissWithOutDataView];
            if (self.tableView.mj_footer==nil) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    @strongify(self);
                    [self footerRefresh];
                }];
            }

            NSLog(@"%@",self.tableView.mj_footer);
            
            if (self.viewModel.model.list.count==0 || self.viewModel.model.list.count == self.viewModel.model.page_count) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
            }
           
        }else{
            [self.tableView showWithOutDataViewWithTitle:@"暂无内容"];
            [self.tableView.withoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tableView).with.offset(topBackgroundViewHeight);
                
                make.height.equalTo(self.tableView).with.offset(-topBackgroundViewHeight);
                
                make.centerX.width.equalTo(self.tableView);
            }];

        }
        
        [self.tableView reloadData];
   
    }];
    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.request.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (self.viewModel.showList.count > 0) {
            
        }else{
            [self.tableView showNetLost];
            [self.tableView.withoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tableView).with.offset(topBackgroundViewHeight);
                
                 make.height.equalTo(self.tableView).with.offset(-topBackgroundViewHeight);
              
                make.centerX.width.equalTo(self.tableView);
            }];
            [self.tableView reloadData];
        }
        
    }];

    
   
}
-(void)configUI{
   
    
    //[self.view addSubview:self.topBackgroundView];
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight) style:UITableViewStylePlain];
    @weakify(self);
    self.tableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRefresh];
    }];
   
    [self.tableView registerNib:nibFromClass(SubscribeDetailTableViewCell) forCellReuseIdentifier:classNameFromClass(SubscribeDetailTableViewCell)];
    self.topBackgroundView.frame = CGRectMake(0, 0, kwidth, topBackgroundViewHeight);
    UIView*view = [[UIView alloc]initWithFrame:self.topBackgroundView.frame];
    [view addSubview:self.topBackgroundView];
    self.tableView.tableHeaderView = view;
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
 
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (@available(iOS 11.0, *)) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.owningView);
            } else {
                // Fallback on earlier versions
                make.edges.equalTo(self.view);
            }
    }];
    
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInset:UIEdgeInsetsMake(-StatusHeight, 0, 0, 0)];
    }  
   
    
    [self.view addSubview:self.topMaskView];

        [self.topMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.mas_equalTo(44+StatusHeight);
        }];

    
      // [self.topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
      //  make.left.right.top.equalTo(self.view);
       // make.height.mas_equalTo(topBackgroundViewHeight);
    //}];
    [self.view addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(StatusHeight+44);
         make.size.mas_equalTo(CGSizeMake(orginalHeadImageWidth, orginalHeadImageWidth));
       // make.top.equalTo(self.topBackgroundView).with.offset(20);
    }];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
         make.top.equalTo(self.headImageView.mas_bottom).with.offset(8);
    }];
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.rightImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).with.offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(10);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.view addSubview:self.subscribeButton];
    [self.subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
        make.centerX.equalTo(self.topBackgroundView);
        make.size.mas_equalTo(CGSizeMake(150/2, 56/2));
    }];
     self.customBackButton= [Tool createButtonWithImage:[UIImage imageNamed:@"backWhite"] target:self action:@selector(leftButtonTouch) tag:0];
    [self.view addSubview:self.customBackButton];
    [self.customBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(StatusHeight);
    }];
    [self.customBackButton setContentEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
    NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self.model.authorId];
    if (browse.count==0) {
        self.isSubject = NO;
    }else{
         self.isSubject = YES;
    }
    self.maskTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topBackgroundViewHeight, kwidth, kheight) style:UITableViewStylePlain];
    [self.view addSubview:self.maskTableView];
    self.maskTableView.backgroundColor = [UIColor clearColor];
    self.maskTableView.userInteractionEnabled = NO;
    self.maskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
   
    

   ///通过监听contentOffset来修改 self.maskTableView.contentOffset来实现一个伪照的下拉刷新效果
    self.maskTableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
    }];
    [RACObserve(self.tableView, contentOffset)subscribeNext:^(id x) {
        @strongify(self);
        ((CustomRefreshGifHeader*) self.maskTableView.mj_header).isDraging = self.tableView.isDragging;
        self.maskTableView.contentOffset = self.tableView.contentOffset;
    }];
    
    //头像增加白色边框
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;

    

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self adjustTipMaskViewWithScrollViewContentOffSetY:scrollView.contentOffset.y];
    [self scaleHeaderImageWithScrollViewOffSetY:scrollView.contentOffset.y];
}
-(void)scaleHeaderImageWithScrollViewOffSetY:(CGFloat)offSetY{
    
    if(offSetY < 0)
    {
        //获取第一个cell
        
        CGFloat imageH =topBackgroundViewHeight;
        
        CGFloat percent = (-offSetY + imageH)/imageH;
        //获得cell的尺寸
        CGRect cellFrame = self.topBackgroundView.frame;
        CGPoint cellCenter = self.topBackgroundView.center;
        cellFrame.size.width = [UIScreen mainScreen].bounds.size.width *percent;
        cellFrame.size.height = imageH *percent;
        cellCenter.x = cellCenter.x;
        cellCenter.y = imageH * 0.5 + offSetY * 0.5;
        self.topBackgroundView.center = cellCenter;
        self.topBackgroundView.bounds = cellFrame;
        
        
        //获得topbackimage的尺寸
        //获得offset
        
    }
    
}

-(void)adjustTipMaskViewWithScrollViewContentOffSetY:(CGFloat)offSetY{
    
    CGFloat scale;
    if (offSetY > topBackgroundViewHeight-44-StatusHeight) {
        scale = 0;
    }else{
         scale = (-offSetY+topBackgroundViewHeight-44-StatusHeight)/(topBackgroundViewHeight-44-StatusHeight);
        scale = fabs(scale);
    }
    if (scale >1.0) {
        scale = 1.0;
    }
    if (offSetY <= 0) {
         scale = 1.0;
    }
    
    if (offSetY<0) {
        offSetY=0;
    }
    
    CGFloat topHeight = topBackgroundViewHeight-offSetY;
    
    if (topHeight <64) {
        offSetY = topBackgroundViewHeight-64;
    }
  // self.topBackgroundView.transform = CGAffineTransformMakeTranslation(0, -offSetY);
    
    NSLog(@"offSetY:%f",offSetY);
    
    ///头像坐标转换
    CGFloat newScale = scale*(orginalHeadImageWidth-newHeadImageWidth)*1.0/orginalHeadImageWidth + 1.0*newHeadImageWidth/orginalHeadImageWidth;
    CGFloat titleWidth = [self.titleLabel systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].width;
    CGFloat headerImageViewOffSetY =self.headImageView.centerY-( (scale)*(self.headImageView.centerY-(44/2+StatusHeight)) + (44/2+StatusHeight));
    self.headImageView.transform = CGAffineTransformScale( CGAffineTransformMakeTranslation(-(1-scale)*(titleWidth/2+newHeadImageWidth/2+5),-headerImageViewOffSetY) , newScale, newScale);
    
    ///tableview坐标转换
       //self.tableView.transform =CGAffineTransformScale( CGAffineTransformMakeTranslation(0,- offSetY) , 1, (kheight-topBackgroundViewHeight+offSetY)*1.0/kheight-topBackgroundViewHeight);
    //self.tableView.frame = CGRectMake(0, topBackgroundViewHeight- offSetY, kwidth, kheight-topBackgroundViewHeight+offSetY);
    
    ///title坐标转换 title 颜色变换
   CGFloat titleOffSetY =self.titleLabel.centerY- ((self.titleLabel.centerY -(StatusHeight+44/2))*(scale)+(StatusHeight+44/2));
    self.titleLabel.transform = CGAffineTransformMakeTranslation(0,-titleOffSetY);
    self.leftImageView.transform = CGAffineTransformMakeTranslation(0,-titleOffSetY);
    self.rightImageView.transform = CGAffineTransformMakeTranslation(0,-titleOffSetY);
    self.leftImageView.alpha = scale;
    self.rightImageView.alpha = scale;
     self.titleLabel.textColor = [UIColor colorWithRed:1.0*scale green:1.0*scale blue:1.0*scale alpha:1];
    
    [self setTitleLabelText:self.titleLabel.text shadowColor:[UIColor colorWithRed:1.0*(6+16)/255 green:1.0*(5+5*16)/255 blue:1.0*(13*16+4)/255 alpha:0.4*scale]];
    ////WhiteColor6499FF
//    UIColor* borderColor = [UIColor colorWithRed:1.0*(4+16*6)/255 green:1.0*(9+9*16)/255 blue:1.0*(15*16+15)/255 alpha:1.0*scale];
//    
//    self.subscribeButton.layer.borderColor = borderColor.CGColor;
    //订阅按钮颜色与坐标变换
    CGSize titleSize;
    if (self.isSubject) {
       titleSize  = [[self.subscribeButton titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(999999.0f, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.subscribeButton.titleLabel.font} context:nil].size;
        
        if (offSetY == 0) {
            self.subscribeButton.layer.borderColor = WhiteColor6499FF.CGColor;
            self.subscribeButton.layer.borderWidth = 1.0;
        }else{
            self.subscribeButton.layer.borderColor = BlackColorCCCCCC.CGColor;
            self.subscribeButton.layer.borderWidth = 1.0;
        }
        
        
    }else{
       titleSize  = [[self.subscribeButton titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(999999.0f, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.subscribeButton.titleLabel.font} context:nil].size;
        self.subscribeButton.backgroundColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:scale];
        
        if (offSetY == 0) {
            self.subscribeButton.layer.borderColor = [UIColor whiteColor].CGColor;
            self.subscribeButton.layer.borderWidth = 1.0;
        }else{
            self.subscribeButton.layer.borderColor = BlueColor447FF5.CGColor;
            self.subscribeButton.layer.borderWidth = 1.0;
        }
    }
    
    // [self.subscribeButton.titleLabel systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].width;
    CGFloat subscribeButtonWidth = titleSize.width;
     CGFloat subscribeButtonOffSetY =self.subscribeButton.centerY- ((self.subscribeButton.centerY -(StatusHeight+44/2))*(scale)+(StatusHeight+44/2));
    
  
    
    CGFloat subscribeButtonOffSetX;
    
    if (offSetY < 15) {
         subscribeButtonOffSetX =self.subscribeButton.centerX- ((self.subscribeButton.centerX -(kwidth- 15-subscribeButtonWidth/2))*(scale)+(kwidth- 15-subscribeButtonWidth/2)-offSetY);
    }else {
         subscribeButtonOffSetX =self.subscribeButton.centerX- ((self.subscribeButton.centerX -(kwidth- 15-subscribeButtonWidth/2))*(scale)+(kwidth- 15-subscribeButtonWidth/2)-15);
    }
   
   
    self.subscribeButton.transform = CGAffineTransformMakeTranslation(-subscribeButtonOffSetX,-subscribeButtonOffSetY);
   ///navigitionbar的背景图透明度变换
    
    self.topMaskView.alpha = 1-scale;
     
     
  ///返回按钮变换
    if(scale < 0.5){
         [self.customBackButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    }else{
         [self.customBackButton setImage:[UIImage imageNamed:@"backWhite"] forState:UIControlStateNormal];
    }
   
    
    //self.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
    
}
-(void)setIsSubject:(BOOL)isSubject{
    if (isSubject!=_isSubject) {
        _isSubject = isSubject;
    }
    if (isSubject) {
       
        
         [self.subscribeButton setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
        [self.subscribeButton setTitle:@"已订阅" forState:UIControlStateNormal];
        self.subscribeButton.layer.borderColor = WhiteColor6499FF.CGColor;
        self.subscribeButton.layer.borderWidth = 1;
          self.subscribeButton.backgroundColor =[UIColor clearColor];
       
    }else{
        self.subscribeButton.backgroundColor =[UIColor whiteColor];
        
        
        
        
        self.subscribeButton.layer.borderWidth = 0;
        [self.subscribeButton setTitle:@"+订阅" forState:UIControlStateNormal];
       
        [self.subscribeButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];

    }
    [self adjustTipMaskViewWithScrollViewContentOffSetY:self.tableView.contentOffset.y];
}
-(void)subcribeButtonClicked:(UIButton*)button{
    //未登录的时候先登录
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
        
        controller.loginSuccessDataBlock = ^{
            NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self.model.authorId];
            if (browse.count==0) {
                self.isSubject = NO;
            }else{
                self.isSubject = YES;
            }
            [self adjustTipMaskViewWithScrollViewContentOffSetY:self.tableView.contentOffset.y];

        };
        return;
    }

    if (self.isSubject==NO) {
        
        @weakify(self)
        self.subjectObject.subjectBlock = ^(bool isok) {
            @strongify(self);
            if(isok){
                [self showSaveSuccessWithTitle:@"订阅成功"];
                self.isSubject = YES;
              //  [self adjustTipMaskViewWithScrollViewContentOffSetY:self.tableView.contentOffset.y];
            }else{
                 [self showSaveSuccessWithTitle:@"订阅失败"];
            }
        };
        
        [self.subjectObject SubjectSaveObject:self.model];
      
    }else{
      NSArray*array =  [SubjectUserModel findByColumn:@"authorId" value:self.model.authorId]  ;
        [array enumerateObjectsUsingBlock:^(SubjectUserModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            @weakify(self)
            self.subjectObject.subjectBlock = ^(bool isok) {
                 @strongify(self);
                if(isok){
                    self.isSubject = NO;
                    [self adjustTipMaskViewWithScrollViewContentOffSetY:self.tableView.contentOffset.y];
                    [self showSaveRemoveWithTitle:@"取消订阅"];
                }else{
                     [self showSaveSuccessWithTitle:@"取消订阅失败"];
                }
            };
            
            [self.subjectObject SubjectMoveObject:obj];

        }];
    }
}
-(void)headerRefresh{
     self.viewModel.request.authorId = self.model.authorId;
    self.viewModel.request.page = 1;
    self.page = 1;
    self.viewModel.request.startRequest = YES;
    
}
-(void)footerRefresh{
    self.viewModel.request.page =  self.page;
    self.viewModel.request.authorId = self.model.authorId;
    self.viewModel.request.startRequest = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray*array =  [SubjectUserModel findByColumn:@"authorId" value:self.model.authorId]  ;
    if (array.count==0) {
        self.isSubject = NO;
         [self adjustTipMaskViewWithScrollViewContentOffSetY:self.tableView.contentOffset.y];
    }
   
    
    
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//   [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationController.navigationBar.translucent = NO;
//}
-(UIImageView*)topBackgroundView{
    if (!_topBackgroundView) {
        
        _topBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"subscribeBackgroundImage"]];
        
        
    }
    return _topBackgroundView;
}
-(void)setTitleLabelText:(NSString*)text shadowColor:(UIColor*)shadowColor{
    if (text.length==0) {
        self.titleLabel.text = @"";
        return;
    }
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 3;
    shadow.shadowOffset = CGSizeMake(1, 2);
    if (shadowColor==nil) {
       shadow.shadowColor = [UIColor colorWithString:@"#1655D4 0.4"];
    }else{
        shadow.shadowColor =shadowColor;
    }
   
    
      NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSShadowAttributeName: shadow }];
    self.titleLabel.attributedText = attributedText;
}
-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [Tool createLabelWithTitle:self.model.authorName textColor:[UIColor whiteColor] tag:0];
        _titleLabel.font = FontOfSize(16);
       
        [self setTitleLabelText:self.model.authorName shadowColor:nil];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
}
-(UIButton*)subscribeButton{
    if (!_subscribeButton) {
        
        _subscribeButton = [Tool createButtonWithTitle:@"已订阅" titleColor:BlackColorA1C1FF target:self action:@selector(subcribeButtonClicked:) ];
        _subscribeButton.backgroundColor = [UIColor clearColor];
        _subscribeButton.titleLabel.font = FontOfSize(14);
        _subscribeButton.layer.cornerRadius = 3;
        _subscribeButton.layer.masksToBounds = YES;
        
        
        _subscribeButton.tintColor = [UIColor clearColor];
        
       
       
       
        
    }
    return _subscribeButton;
}
-(UIView*)topMaskView{
    if (!_topMaskView) {
        _topMaskView = [[UIView alloc]init];
        _topMaskView.backgroundColor = [UIColor whiteColor];
        _topMaskView.alpha = 0;
        UIView*line = [Tool createLine];
        [_topMaskView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_topMaskView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _topMaskView;
}
-(UIImageView*)leftImageView{
    if (!_leftImageView) {
        _leftImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"subcribeLeft" ]];
    }
    return _leftImageView;
}
-(UIImageView*)rightImageView{
    if (!_rightImageView) {
        _rightImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"subcribeRight" ]];
    }
    return _rightImageView;
}
-(UIImageView*)headImageView{
    if (!_headImageView) {
        _headImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_head" ]];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgurl] placeholderImage:[UIImage imageNamed:@"pic_head" ]];
        _headImageView.layer.cornerRadius = orginalHeadImageWidth/2;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
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
