//
//  ArtInfoViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/9/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ArtInfoViewController.h"

#import "SubscribeDetailViewController.h"
#import "InfoDetailsViewController.h"
#import "ShadowLoginViewController.h"

#import "CommiteModel.h"

#import "InfoViewModel.h"
#import "CommiteListViewModel.h"
#import "AddCommentViewModel.h"
#import "MediaDetailViewModel.h"

#import "InfoDetailFont.h"
#import "IQKeyboardManager.h"
#import "DeliverData.h"
#import "UIImage+GIF.h"
#import "SaveFlow.h"
#import "SharePlatform.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "MyUMShare.h"
#import "UITableView+UITableViewTopView.h"
#import "SubjectAndSaveObject.h"


#import "CommentView.h"
#import "InfoTableView.h"
#import "ArtPopView.h"
#import "Utils.h"

#import "KouBeiArtModel.h"
#import "BrowseKouBeiArtModel.h"
#import "SubjectAuthorModel.h"
#import "SubjectUserModel.H"
#import "DeliverModel.h"
#import "ReadRecordModel.h"
#import "ShareModel.h"


#import "MediaArtInfoTableView.h"
#import "NormalArtTableView.h"
#import "TitleView.h"

#import "CommitListTableView.h"
#import "ToastUtils.h"

@interface ArtInfoViewController ()<ArtPopViewDelegate>

///存放图片的数组
@property (nonatomic,strong)NSMutableArray *photos;
//弹出控件
@property (nonatomic,strong)ArtPopView *artPopView;
@property (nonatomic,strong)MediaDetailViewModel *mediaModel;
@property (nonatomic,strong)InfoViewModel *infoModel;
@property (nonatomic,strong)CommiteListViewModel *commiteViewModel;
@property (nonatomic,copy)NSMutableArray *commitList;
@property (nonatomic,strong)NSString *authorId;
@property (nonatomic,strong)CommitListTableView *commitTableView;
@property (nonatomic,strong)SubjectAndSaveObject *subjectTool;
@property (nonatomic,strong)CommentView *sendCommentView;
@property (nonatomic,strong)AddCommentViewModel *addCommentViewModel;

@property (nonatomic,strong)ToastUtils *toastUtils;

//用户的位置
@property(nonatomic,assign)CGPoint userPoint;
//header的位置
@property(nonatomic,assign)CGPoint headerPoint;
//滑动方向 false 向下 true 向上
@property(nonatomic,assign)bool isScroll2User;
///上一个被评论的id
@property (nonatomic,copy) NSString *pid;

//文字
@property(nonatomic,retain)NSString *p;
@property(nonatomic,retain)NSString *s;
//图片
@property(nonatomic,retain)NSString *i;

@end

@implementation ArtInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.p =@"p";
    self.s =@"strong";
    self.i =@"img";
    
    self.topTableView.hidden = YES;
    
    [self showSingleButton];
    [self initTableView];
    [self initdata];
    [self initCommite];
  
    [self.view insertSubview:self.bottomView aboveSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable =NO;


    if ([self.artType isEqualToString:zimeiti]) {
        NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self.mediaModel.data.authorId];
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
      [self updateView];

}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable =YES;
    [self.sendCommentView.messageTextView resignFirstResponder];
    self.sendCommentView = nil;
}

#pragma 主界面

-(void)showSingleButton{
    
    if (!self.shareButton) {
        self.shareButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"ic_morebutton"] with:25.0f];
        [self.shareButton setImage:[UIImage imageNamed:@"ic_morebuttonSelected.png"] forState:UIControlStateHighlighted];
        [self.shareButton  addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self.mediaModel.data.authorId];
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


-(void)initTableView{
 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 0)];
    [self.view addSubview:view];
    
    if ([self.artType isEqualToString:zimeiti]) {
        self.tableView = [[MediaArtInfoTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
 
    }else{
        self.tableView = [[NormalArtTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }

    @weakify(self);
    [RACObserve(self.tableView, contentSize) subscribeNext:^(id x) {
        @strongify(self);
        if (self.tableView.contentSize.height!=0) {
            
            self.commitTableView.tableHeaderView.height = self.tableView.contentSize.height;
            
                if (self.commitTableView.contentSize.height<kheight && self.commitTableView.contentSize.height!=0) {
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight - self.commitTableView.contentSize.height-50-44)];
                    self.commitTableView.tableFooterView = view ;
                    
                }else{
                    
                }
            self.headerPoint = CGPointMake(0, self.tableView.contentSize.height);

        
            [self.commitTableView setTableHeaderView:self.tableView];
        }
       
    }];
    
    self.commitTableView.tableHeaderView = self.tableView;
    
    //默认为0
    self.messageLabel.text = @"0";
    self.messageLabel.layer.cornerRadius=self.messageLabel.frame.size.width/2;//裁成圆角
    self.messageLabel.layer.masksToBounds=YES;//隐藏裁剪掉的部分
}

-(void)initdata{
    self.userPoint = CGPointMake(0, 0);
    self.isScroll2User = false;
    
    if ([self.artType isEqualToString:zimeiti]) {
        self.mediaModel.request.aid = self.aid;
        self.mediaModel.request.model = @"0";
        
        if ([SaveFlow getFlowSign]) {
            self.mediaModel.request.model = @"1";
        }
        self.mediaModel.request.startRequest = YES;
 
    }else{
        self.infoModel.request.aid = self.aid;
        self.infoModel.request.model = @"0";
        
        if ([SaveFlow getFlowSign]) {
            self.infoModel.request.model = @"1";
        }
        self.infoModel.request.startRequest = YES;
    }
    
}


-(void)initCommite{
    self.commiteViewModel.request.aid = self.aid;
    self.commiteViewModel.request.page = 1;
    self.commiteViewModel.request.startRequest = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 点击事件

- (IBAction)scrollButton:(UIButton *)sender {
    if (self.commitTableView.contentOffset.y != 0) {
        [self.commitTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.isScroll2User = false;
    }
}

-(void)commentSend{
    self.addCommentViewModel.request.pid = self.pid;
    self.addCommentViewModel.request.aid = self.aid;
    self.addCommentViewModel.request.uid = [UserModel shareInstance].uid;
    self.addCommentViewModel.request.type = self.artType;
    self.addCommentViewModel.request.content = self.sendCommentView.messageTextView.text;
    self.addCommentViewModel.request.startRequest = YES;
    [self.sendCommentView dismiss];
}

///commentSend的方法是发送信息
-(void)cellCommentMessage:(UIButton *)sender{
    
    CommiteModel *model = self.commitList[sender.tag];
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        @weakify(self);
        controller.loginSuccessDataBlock = ^{
             @strongify(self);
            self.pid = @"0";
            self.sendCommentView.hidden = NO;
            [self.sendCommentView.messageTextView becomeFirstResponder];
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

- (IBAction)messageClick:(UIButton *)button {
    button.highlighted = NO;
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        @weakify(self);
        controller.loginSuccessDataBlock = ^{
            @strongify(self);
            self.pid = @"0";
            self.sendCommentView.hidden = NO;
            [self.sendCommentView.messageTextView becomeFirstResponder];
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

-(void)subjectClick:(UIButton*)button {
    
    //未登录的时候先登录
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
        return;
    }
    
    if([self.bookingButton.titleLabel.textColor isEqual:BlueColor447FF5]){
        
        @weakify(self);
        self.subjectTool.subjectBlock = ^(bool isok) {
              @strongify(self);
            if (isok) {
                self.bookingButton.layer.borderColor = BlackColorEEEEEE.CGColor;
                [self.bookingButton setTitle:@"已订阅" forState:UIControlStateNormal];
                [self.bookingButton setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
            }
        };
        
        [self saveSubjectModel:self.mediaModel.data.authorId authorName:self.mediaModel.data.authorName authorPic:self.mediaModel.data.authorPic];
    }else{
        //点击不可以取消
        SubscribeDetailViewController *controller = [[SubscribeDetailViewController alloc] init];
        SubjectUserModel *model = [[SubjectUserModel alloc] init];
        model.authorName = self.mediaModel.data.authorName;
        model.imgurl = self.mediaModel.data.authorPic;
        model.authorId = self.mediaModel.data.authorId;
        
        controller.model = model;
        
        [URLNavigation pushViewController:controller animated:YES];
    }
}


-(void)moreButtonClicked:(UIButton*)button{
    [self initPopView];
}


- (IBAction)jump2commite:(id)sender {
    
    if (self.commiteViewModel.data.list.count!=0) {

        if (self.isScroll2User) {
            [self.commitTableView  setContentOffset:self.userPoint animated:NO];
            self.isScroll2User = false;
        }else{
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.commitTableView scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionTop animated:NO];
            self.isScroll2User = YES;
        }
    }else{
        //无评论的时候直接弹出效果
        if (self.isScroll2User) {
            [self.commitTableView  setContentOffset:self.userPoint animated:NO];
            self.isScroll2User = false;
        }else{
            [self.commitTableView  setContentOffset:CGPointMake(0, self.commitTableView.tableHeaderView.height-kheight) animated:NO];
            self.isScroll2User = YES;
            [self.messageButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
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
            @weakify(self);
            controller.loginSuccessDataBlock = ^{
                @strongify(self);
                [self updateView];
            };
           [URLNavigation pushViewController:controller animated:YES];
        }
    }
}
- (IBAction)share:(id)sender {
    self.artPopView.artPopViewType = ArtPopViewTypeShare;
    [self.artPopView show];
}

//跳转去自媒体的方法
-(void)jumpToZMT{
    //    NSLog(@"tap");
    SubscribeDetailViewController *controller = [[SubscribeDetailViewController alloc] init];
    SubjectUserModel *model = [[SubjectUserModel alloc] init];
    
    NSArray*array =  [SubjectUserModel findByColumn:@"authorId" value: self.mediaModel.data.authorId]  ;
    
    if (array.count) {
        model = array[0];
    }else{
        model.authorName = self.mediaModel.data.authorName;
        model.imgurl = self.mediaModel.data.authorPic;
        model.authorId = self.mediaModel.data.authorId;
    }
    
    controller.model = model;
    
    [URLNavigation pushViewController:controller animated:YES];
}

-(void)shareButtonClicked:(UIButton*)button{
    [self initPopView];
}

#pragma 功能

///这边是用来重新登录并且绘制界面
-(void)updateView{
    //头部订阅刷新
    NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
    if ( [records count] ) {
        [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];
    }
    
    if ([self.artType isEqualToString:zimeiti]) {
        //刷新头部
        MediaArtInfoTableView* temp_table = (MediaArtInfoTableView*)self.tableView;
        [temp_table.headview rebuildSubject];
    }else{
        
    }
}

-(void)saveBrowesModel{
    BrowseKouBeiArtModel *model = [[BrowseKouBeiArtModel alloc] init];
    
    if ([self.artType isEqualToString:zimeiti]) {
        model.pic = self.mediaModel.data.thumb;
        model.name = self.mediaModel.data.title;
        model.views = self.mediaModel.data.click;
        model.time = self.mediaModel.data.inputtime;
        model.authorName = self.mediaModel.data.authorName;
        model.id = self.mediaModel.data.id;
        model.tag = artInfo;
        model.arttype = self.artType;
    }else{
        model.pic = self.infoModel.data.thumb;
        model.name = self.infoModel.data.title;
        model.views = self.infoModel.data.click;
        model.time = self.infoModel.data.inputtime;
        model.authorName = self.infoModel.data.authorName;
        model.id = self.infoModel.data.id;
        model.tag = artInfo;
        model.arttype = self.artType;
    }
    
    if([model.id isNotEmpty]){
        [model save];
    }
    
}

-(void)deleteBrowesModel:(BrowseKouBeiArtModel *) model{
    BrowseKouBeiArtModel *temp = model;
    [temp deleteSelf];
}


-(void)saveSubjectModel:(NSString*) authorId authorName:(NSString *)name authorPic:(NSString *)pic{
    SubjectUserModel *model = [[SubjectUserModel alloc] init];
    model.authorId = authorId;
    model.authorName = name;
    model.imgurl = pic;
    [self.subjectTool SubjectSaveObject:model];
}

//本地收藏
-(void)saveModel{
    KouBeiArtModel *art = [[KouBeiArtModel alloc]init];
    
    
    if ([self.artType isEqualToString:zimeiti]) {
        art.imgurl = self.mediaModel.data.thumb;
        art.title = self.mediaModel.data.title;
        art.click = self.mediaModel.data.click;
        art.authorName = self.mediaModel.data.authorName;
        art.colId = self.mediaModel.data.id;
        art.tag = artInfo;
        art.artType = zimeiti;
    }else{
        art.imgurl = self.infoModel.data.thumb;
        art.title = self.infoModel.data.title;
        art.click = self.infoModel.data.click;
        art.authorName = self.infoModel.data.authorName;
        art.colId = self.infoModel.data.id;
        art.tag = artInfo;
        art.artType = wenzhang;
    }

    @weakify(self);
    self.subjectTool.infoBlock = ^(bool isok) {
        @strongify(self);
            if (isok) {
                [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];
                [self showSaveSuccess];
            }else{
                [self showSaveSuccessWithTitle:@"收藏失败"];
            }
    };
    [self.subjectTool InfoSaveObject:art typeid:artInfo];
}

//删除订阅
-(void)deleteMode{
    NSArray *art = [KouBeiArtModel findByColumn:@"colId" value:self.aid];
    if ([art count]) {
        KouBeiArtModel *temp = art[0];
        
        @weakify(self);
        self.subjectTool.infoBlock = ^(bool isok) {
            @strongify(self);
            if (isok) {
                [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteBlack"] forState:UIControlStateNormal];
                
                [self showSaveRemove];
            }else{
                [self showSaveSuccessWithTitle:@"取消失败"];
            }
        };
        [self.subjectTool InfoMoveObject:temp typeid:artInfo];
    }
}
#pragma ArtPopView delegate

-(void)changeFont:(NSInteger)type{
    [InfoDetailFont shareInstance].fontStyle = type;
}

//分享
-(void)Handleclick:(ShareModel *)model{
    
    if ([model.tag isEqualToString:@"1"]) {
    
    if ([self.artType isEqualToString:zimeiti]) {
        ///组织内容
        __block NSString*content;
        [ self.mediaModel.data.content enumerateObjectsUsingBlock:^(InfoContentModel* contentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([contentModel.type isEqualToString:self.p]||[contentModel.type isEqualToString:self.s]) {
                
                content = contentModel.value;
                *stop = YES;
                
            }
        }];
        
        if (!content.isNotEmpty) {
            content = self.mediaModel.data.title;
        }
        
        if ([model.name isEqualToString:@"微信"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeWechat title:self.mediaModel.data.title conent:content artUrl:self.mediaModel.data.arcurl picUrl:self.mediaModel.data.thumb];
        }
        
        if ([model.name isEqualToString:@"朋友圈"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.mediaModel.data.title conent:content artUrl:self.mediaModel.data.arcurl picUrl:self.mediaModel.data.thumb];
        }
        
        if ([model.name isEqualToString:@"QQ好友"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeQQ title:self.mediaModel.data.title conent:content artUrl:self.mediaModel.data.arcurl picUrl:self.mediaModel.data.thumb];
        }
        
        if ([model.name isEqualToString:@"QQ空间"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.mediaModel.data.title conent:content artUrl:self.mediaModel.data.arcurl picUrl:self.mediaModel.data.thumb];
        }
        
    }else{
        ///组织内容
        __block NSString*content;
        [ self.infoModel.data.content enumerateObjectsUsingBlock:^(InfoContentModel* contentModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([contentModel.type isEqualToString:self.p]||[contentModel.type isEqualToString:self.s]) {
                
                content = contentModel.value;
                *stop = YES;
                
            }
        }];
        
        if (!content.isNotEmpty) {
            content = self.infoModel.data.title;
        }
        
        if ([model.name isEqualToString:@"微信"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeWechat title:self.infoModel.data.title conent:content artUrl:self.infoModel.data.arcurl picUrl:self.infoModel.data.thumb];
        }
        
        if ([model.name isEqualToString:@"朋友圈"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.infoModel.data.title conent:content artUrl:self.infoModel.data.arcurl picUrl:self.infoModel.data.thumb];
        }
        
        if ([model.name isEqualToString:@"QQ好友"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeQQ title:self.infoModel.data.title conent:content artUrl:self.infoModel.data.arcurl picUrl:self.infoModel.data.thumb];
        }
        
        if ([model.name isEqualToString:@"QQ空间"]) {
            [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.infoModel.data.title conent:content artUrl:self.infoModel.data.arcurl picUrl:self.infoModel.data.thumb];
        }
    }

    }else{
   
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


#pragma scrollview方法

//头部滑动显示
//这个不是代理方法 后来人注意
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
        if (self.commitList.count>0) {
            if (scrollView.contentOffset.y == 0) {
            
            }else if (scrollView.contentOffset.y+1<self.headerPoint.y){
              
                if (self.headerPoint.y -scrollView.contentOffset.y+1 <kheight) {
             
                }else{
                    self.userPoint = scrollView.contentOffset;
                    self.isScroll2User = false;
                }
                
            }
        }
    
        if ([self.artType isEqualToString:zimeiti]) {
            if (scrollView.contentOffset.y > [self.tableView headerViewForSection:0].frame.size.height) {
                self.navigationItem.titleView.hidden = NO;
                self.topTableView.hidden = NO;
                if (self.navigationItem.rightBarButtonItems.count!=2) {
                    [self showRightButton];
                }
            }else{
                self.topTableView.hidden = YES;
                self.navigationItem.titleView.hidden = YES;
                if (self.navigationItem.rightBarButtonItems.count!=1) {
                    [self showSingleButton];
                }
            }
        }else{
            if (scrollView.contentOffset.y > [self.tableView headerViewForSection:0].frame.size.height) {
                self.topTableView.hidden = NO;
              
            }else{
                self.topTableView.hidden = YES;
            }
        }

}

#pragma 其余界面
-(void) initPopView{
    self.artPopView.artPopViewType = ArtPopViewTypeSetting;
    [self.artPopView show];
}

-(void)initTitleView{
    TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, 2*(kwidth/2-44*2-30), 40)];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.lineBreakMode =NSLineBreakByTruncatingMiddle;
    
    
    UIView*view = [[UIView alloc]init];
    [titleView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(titleView);
    }];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerY.equalTo(view);
        make.right.equalTo(view.mas_right);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    nameLabel.text =self.mediaModel.data.authorName;
    
    UIImageView *nameImageView = [[UIImageView alloc] init];
    nameImageView.layer.cornerRadius = 16;
    nameImageView.layer.masksToBounds = YES;
    
    [nameImageView setImageWithURL:[NSURL URLWithString:self.mediaModel.data.authorPic] placeholderImage:[UIImage imageNamed:@"pic_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [view addSubview:nameImageView];
    
    [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameLabel.mas_left).offset(-5);
        make.centerY.equalTo(view);
        make.left.equalTo(view);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    
    self.navigationItem.titleView = titleView;
    self.navigationItem.titleView.hidden = YES;
 
    @weakify(self)
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        //这边是头部点击事件
        [self jumpToZMT];
    }];
    [titleView addGestureRecognizer:tap];
    
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    [[GCDQueue globalQueue]queueBlock:^{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // do nothing
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            @strongify(self);
            if (!error) {
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }
        }];
        
    }];
}


#pragma 懒加载
-(ToastUtils *)toastUtils{
    if (!_toastUtils) {
        _toastUtils = [[ToastUtils alloc]init];
    }
    return _toastUtils;
}


-(SubjectAndSaveObject *)subjectTool{
    if(!_subjectTool){
        _subjectTool = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectTool;
}

-(NSMutableArray *)commitList{
    if (!_commitList) {
        _commitList = [NSMutableArray arrayWithCapacity:5];
    }
    return _commitList;
    
}

-(CommitListTableView *)commitTableView{
    if (!_commitTableView) {
        _commitTableView = [[CommitListTableView alloc] initWithFrame:CGRectMake(0,0,kwidth , kheight) style:UITableViewStylePlain];
        [self.view addSubview:_commitTableView];
        [self.view insertSubview:self.topTableView aboveSubview:_commitTableView];
        [_commitTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
            
        }];
        
        //防止计数器循环引用
        __weak ArtInfoViewController *blockSelf = self;
 
         
        _commitTableView.block = ^(UIScrollView *srollview) {
            __strong ArtInfoViewController *strongObj = blockSelf;
            if (strongObj) {
            [strongObj scrollViewDidScroll:srollview];
            }
        };
 
        _commitTableView.messageBlock = ^(UIButton *button) {
            __strong ArtInfoViewController *strongObj = blockSelf;
            if (strongObj) {
                [strongObj cellCommentMessage:button];
            }

        };
    }
    return _commitTableView;
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
        @weakify(_sendCommentView);
        [_sendCommentView dismiss:^{
            @strongify(self);
            @strongify(_sendCommentView);
//            NSString*str  = [self.sendCommentView.messageTextView.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
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
    
        @weakify(self);
        @weakify(_commiteViewModel);
        [[RACObserve(_commiteViewModel, data)
          filter:^BOOL(id value) {
              @strongify(_commiteViewModel);
              return  _commiteViewModel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
              @strongify(self);
              @strongify(_commiteViewModel);
              NSLog(@"请求了一次");
              if (_commiteViewModel.data.page_count>0) {
                  self.messageLabel.text = [NSString  stringWithFormat:@"%ld",self.commiteViewModel.data.page_count];

                  if (self.commitTableView.mj_footer == NULL) {
                      
                      
                      @weakify(self);
                      @weakify(_commiteViewModel);
                      self.commitTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                          @strongify(self);
                          @strongify(_commiteViewModel);
                         _commiteViewModel.request.page++;
                          [self.commitTableView.mj_footer beginRefreshing];
                          self.commiteViewModel.request.startRequest = YES;
                      }];
                  }



                  if (_commiteViewModel.request.page == 1) {
                      if (_commiteViewModel.data.totalpage == _commiteViewModel.request.page) {
                          [self.commitList removeAllObjects];
                          [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                          [self.commitTableView.mj_footer endRefreshingWithNoMoreData];
                          ((MJRefreshAutoNormalFooter*)self.commitTableView.mj_footer).stateLabel.text = @"";
                      }else{
                          [self.commitList removeAllObjects];
                          _commiteViewModel.request.page++;
                          [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                          [self.commitTableView.mj_footer endRefreshing];
                      }
                  }else{
                      if (_commiteViewModel.data.totalpage == _commiteViewModel.request.page) {
                          [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                          [self.commitTableView.mj_footer endRefreshingWithNoMoreData];
                          ((MJRefreshAutoNormalFooter*)self.commitTableView.mj_footer).stateLabel.text = @"";
                      }else if(_commiteViewModel.data.totalpage > _commiteViewModel.request.page){
                            _commiteViewModel.request.page++;;
                          [self.commitList addObjectsFromArray:self.commiteViewModel.data.list];
                          [self.commitTableView.mj_footer endRefreshing];
                      }else{
                          [self.commitTableView.mj_footer endRefreshingWithNoMoreData];
                          ((MJRefreshAutoNormalFooter*)self.commitTableView.mj_footer).stateLabel.text = @"";
                      }
                  }


                  self.commitTableView.commitList = [self.commitList copy];
                  [self.commitTableView reloadData];


              }else{
              }

          }];
    }
    return _commiteViewModel;
}


-(InfoViewModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [InfoViewModel SceneModel];
        @weakify(self);
        @weakify(_infoModel);
        [[RACObserve(_infoModel, data)filter:^BOOL(id value) {
            @strongify(_infoModel);
            return _infoModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            @strongify(_infoModel);
            [self.tableView dismissWithOutDataView];
            NormalArtTableView* temp_table = (NormalArtTableView*)self.tableView;
            [temp_table setMediaData:_infoModel.data];
            
            NSArray *browse = [BrowseKouBeiArtModel findByColumn:@"id" value:self.aid];
            if (![browse count]) {
                if(![self.aid isEqualToString:@""]){
                    [self saveBrowesModel];
                }
            }else{
                [self deleteBrowesModel:browse[0]];
                [self saveBrowesModel];
            }
        }];
        
        [[RACObserve(_infoModel, request)filter:^BOOL(id value) {
            @strongify(_infoModel);
            return _infoModel.request.failed;
        }]subscribeNext:^(id x) {
              @strongify(self);
            [self.tableView showNetLost];
            self.shareButton.userInteractionEnabled = NO;
        }];
        
        [RACObserve([InfoDetailFont shareInstance], fontStyle)subscribeNext:^(id x) {
             @strongify(self);
            [self.tableView reloadData];
        }];
    }
    return _infoModel;
}

-(MediaDetailViewModel *)mediaModel{
    if (!_mediaModel) {
        _mediaModel = [MediaDetailViewModel SceneModel];
        
        @weakify(self);
        @weakify(_mediaModel);
        [[RACObserve(_mediaModel, data)filter:^BOOL(id value) {
            @strongify(_mediaModel);
            return _mediaModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            @strongify(_mediaModel);
            [self.tableView dismissWithOutDataView];
            [self initTitleView];
            MediaArtInfoTableView* temp_table = (MediaArtInfoTableView*)self.tableView;
            [temp_table setMediaData:_mediaModel.data];


            NSArray *browse = [BrowseKouBeiArtModel findByColumn:@"id" value:self.aid];
            if (![browse count]) {
                if(![self.aid isEqualToString:@""]){
                    [self saveBrowesModel];
                }
            }else{
                [self deleteBrowesModel:browse[0]];
                [self saveBrowesModel];
            }

        }];

        [[RACObserve(_mediaModel, request)filter:^BOOL(id value) {
             @strongify(_mediaModel);
            return _mediaModel.request.failed;
        }]subscribeNext:^(id x) {
             @strongify(self);
            [self.tableView showNetLost];
            self.shareButton.userInteractionEnabled = NO;
        }];

        [RACObserve([InfoDetailFont shareInstance], fontStyle)subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView reloadData];
        }];
    }
    return _mediaModel;
}

/// 初始化弹出的界面
-(ArtPopView *)artPopView{
    if (!_artPopView) {
        _artPopView = [[ArtPopView alloc] init];
        _artPopView.delegate = self;
        _artPopView.shareItems = [SharePlatform getSharePlatforms];
        
        //第一版本
        NSMutableArray *comm = [NSMutableArray arrayWithCapacity:3];
        
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

-(AddCommentViewModel *)addCommentViewModel{
    if (!_addCommentViewModel) {
        _addCommentViewModel = [AddCommentViewModel SceneModel];
        
        @weakify(self);
        @weakify(_addCommentViewModel);
        [[RACObserve(_addCommentViewModel.request,state)
          filter:^BOOL(id value) {
              @strongify(_addCommentViewModel);
              return _addCommentViewModel.request.succeed;
          }]subscribeNext:^(id x) {
               @strongify(self);
              if (x) {
                  //发送成功后清除编辑文字
                  NSLog(@"请求了又一次");
                  self.commiteViewModel.request.page = 1;
                  self.sendCommentView.messageTextView.text =@"";
                  self.sendCommentView.sendButton.enabled = NO;
                  [self.sendCommentView setHidden:YES];
                  self.commiteViewModel.request.startRequest = YES;
              }else{
                  
              }
          }];
    }
    return _addCommentViewModel;
}


@end


