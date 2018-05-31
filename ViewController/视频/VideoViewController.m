//
//  VideoViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoViewController.h"

#import "ShadowLoginViewController.h"

#import "ZFPlayerView.h"
#import "ZFPlayerModel.h"
#import "VideoDetailViewModel.h"
#import "AddCommentViewModel.h"

#import "VideoDetailModel.h"
#import "BrowseKouBeiArtModel.h"

#import "CommitListTableView.h"
#import "CommiteListModel.h"
#import "CommiteModel.h"
#import "CommentView.h"
#import "KouBeiArtModel.h"
#import "SubjectAndSaveObject.h"

#import "VideoTableView.h"
#import "IQKeyboardManager.h"
#import "VideoAutoPlay.h"

#import "UINavigationController+ZFPlayerRotation.m"

@interface VideoViewController ()<ZFPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;

@property (nonatomic, strong) VideoDetailViewModel *viewModel;
@property (nonatomic, strong) VideoDetailModel *localData;
@property (nonatomic, strong) NSMutableArray *commitList;

@property (nonatomic, strong) VideoTableView *videoTableView;
@property (nonatomic, strong) CommitListTableView *commitTableView;
@property (nonatomic, strong) CommentView *sendCommentView;
@property (nonatomic, strong) AddCommentViewModel *addCommentViewModel;

@property (nonatomic, strong) NSString *artType;
@property (nonatomic, strong) SubjectAndSaveObject *subjectTool;

///上一个被评论的id
@property (nonatomic,copy) NSString *pid;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"视频"];
    
    self.artType = @"3";
   
    self.navigationController.navigationBarHidden = YES;
    self.viewModel.request.id = self.baseModel.id;
    self.viewModel.request.startRequest = YES;
    
    self.viewModel.videoCommentrequest.aid = self.baseModel.id;
    self.viewModel.videoCommentrequest.page = 1;
    self.viewModel.videoCommentrequest.startRequest = YES;
    
    self.commitTableView.tableHeaderView = self.videoTableView;
    
    @weakify(self)
    [RACObserve(self.videoTableView, contentSize) subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"VideoViewController contentSize:%f",self.videoTableView.contentSize.height);
        self.commitTableView.tableHeaderView.height = self.videoTableView.contentSize.height;
        [self.commitTableView setTableHeaderView:self.videoTableView];
    }];
   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable =NO;
    [self updateView];
    self.playerView.playerPushedOrPresented = NO;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable =YES;
    [self.sendCommentView.messageTextView resignFirstResponder];
    self.sendCommentView = nil;
 
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.localData.info.title;
        _playerModel.videoURL         = [NSURL URLWithString:self.localData.info.sd_mp4];
        _playerModel.placeholderImageURLString = self.localData.info.big_img_url;
        _playerModel.fatherView       = self.fatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
//        _playerView.hasDownload    = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}

#pragma 代理方法
-(void)zf_playerScreenChange{
      NSLog(@"屏幕被切换了");
}

-(void)zf_playerBackAction{
    [self.rt_navigationController popViewControllerAnimated:YES];
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
}

#pragma 点击事件

- (IBAction)shoucang:(id)sender {
    //头部按钮
    NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.viewModel.data.info.id];
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

- (IBAction)messageClick:(UIButton *)button {
    button.highlighted = NO;
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        @weakify(self)
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

-(void)commentSend{
    self.addCommentViewModel.request.pid = self.pid;
    self.addCommentViewModel.request.aid = self.viewModel.data.info.id;
    self.addCommentViewModel.request.uid = [UserModel shareInstance].uid;
    self.addCommentViewModel.request.type = self.artType;
    self.addCommentViewModel.request.content = self.sendCommentView.messageTextView.text;
    self.addCommentViewModel.request.startRequest = YES;
    [self.sendCommentView dismiss];
}

- (IBAction)jump2commite:(id)sender {
    
    if (self.commitList.count!=0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.commitTableView scrollToRowAtIndexPath:scrollIndexPath
                                        atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
           //无评论的时候直接弹出效果
            [self.messageButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma 功能

-(void)playByNetWork{
    if ([[NetWorkStatus getIsWifi]  isEqual: iswifi]) {
        [self.playerView autoPlayTheVideo];
    }else{
        if ([[VideoAutoPlay getAutoPlay] isEqualToString: isnotautoPlay]) {
       
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"您当前在非Wi-Fi环境,已为您关闭自动播放";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }else{
            [self.playerView autoPlayTheVideo];
        }
       
        
    }
}

-(void)reloadPlayModel{
    self.playerModel.title            = self.localData.info.title;
    self.playerModel.videoURL         = [NSURL URLWithString:self.localData.info.sd_mp4];
    self.playerModel.placeholderImageURLString = self.localData.info.big_img_url;
    
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

-(void)updateView{
    //头部订阅刷新
    NSArray *records = [KouBeiArtModel findByColumn:@"colId" value:self.baseModel.id];
    if ( [records count] ) {
        [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];
    }
}
//头部滑动显示
//这个不是代理方法 后来人注意
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

//删除收藏
-(void)deleteMode{
    NSArray *art = [KouBeiArtModel findByColumn:@"colId" value:self.viewModel.data.info.id];
    if ([art count]) {
        KouBeiArtModel *temp = art[0];
        
        @weakify(self)
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

//本地收藏
-(void)saveModel{
    KouBeiArtModel *art = [[KouBeiArtModel alloc]init];
    
    
   
    art.imgurl = self.viewModel.data.info.big_img_url;
    art.title = self.viewModel.data.info.title;
    art.click = self.viewModel.data.info.click_count;
    art.authorName = @"车城网";
    art.colId = self.viewModel.data.info.id;
    art.tag = artInfo;
    art.artType = self.artType;
    
    
    @weakify(self)
    self.subjectTool.infoBlock = ^(bool isok) {
        @strongify(self);
        if (isok) {
            [self.shoucangButton setImage:[UIImage imageNamed:@"favouriteYellow"] forState:UIControlStateNormal];
            [self showSaveSuccess];
        }else{
            [self showSaveSuccessWithTitle:@"收藏失败"];
        }
    };
    [self.subjectTool InfoSaveObject:art typeid:myvideo];
}

///commentSend的方法是发送信息
-(void)cellCommentMessage:(UIButton *)sender{
    
    CommiteModel *model = self.commitList[sender.tag];
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        @weakify(self)
        controller.loginSuccessDataBlock = ^{
            @strongify(self);
            self.pid = @"0";
            self.sendCommentView.hidden = NO;
            [self.sendCommentView.messageTextView becomeFirstResponder];
        };
        [self.rt_navigationController pushViewController:controller animated:YES];
        return ;
    }
    
    self.sendCommentView.messageField.hidden = NO;
    self.sendCommentView.messageField.placeholder = [NSString stringWithFormat:@"回复%@的评论",model.username];
    self.sendCommentView.hidden = NO;
    self.pid = model.id;
    [self.sendCommentView.messageTextView becomeFirstResponder];
    
}

-(void)saveBrowesModel{
    BrowseKouBeiArtModel *model = [[BrowseKouBeiArtModel alloc] init];
    
    
        model.pic = self.viewModel.data.info.big_img_url;
        model.name = self.viewModel.data.info.title;
        model.views = self.viewModel.data.info.click_count;
        model.authorName = @"车城网";
        model.id = self.viewModel.data.info.id;
        model.tag = artInfo;
        model.arttype = self.artType;
    
    
    if([model.id isNotEmpty]){
        [model save];
    }
    
}

-(void)deleteBrowesModel:(BrowseKouBeiArtModel *) model{
    BrowseKouBeiArtModel *temp = model;
    [temp deleteSelf];
}

#pragma 懒加载

-(CommitListTableView *)commitTableView{
    if (!_commitTableView) {
        _commitTableView = [[CommitListTableView alloc] initWithFrame:CGRectMake(0,0,kwidth , kheight) style:UITableViewStylePlain];
        [self.view addSubview:_commitTableView];
        [_commitTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentTableView);
        }];
        
        //防止计数器循环引用
        __weak VideoViewController *blockSelf = self;
        
        _commitTableView.block = ^(UIScrollView *srollview) {
            __strong VideoViewController *strongObj = blockSelf;
            if (strongObj) {
//                [strongObj scrollViewDidScroll:srollview];
            }
        };
        
        _commitTableView.messageBlock = ^(UIButton *button) {
            __strong VideoViewController *strongObj = blockSelf;
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
 
        @weakify(_sendCommentView);
        [_sendCommentView dismiss:^{
 
            @strongify(_sendCommentView);
//            NSString*str  = [self.sendCommentView.messageTextView.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
            _sendCommentView.messageField.hidden = NO;
            _sendCommentView.messageTextView.text =@"";
            
        }];
        [_sendCommentView setHidden:YES];
    }
    return _sendCommentView;
}

-(NSMutableArray *)commitList{
    if (!_commitList) {
        _commitList = [NSMutableArray arrayWithCapacity:5];
    }
    return _commitList;
    
}

-(VideoDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [VideoDetailViewModel SceneModel];
        
        @weakify(self);
        @weakify(_viewModel);
        [[RACObserve(_viewModel, data)filter:^BOOL(id value) {
             @strongify(_viewModel);
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
             @strongify(_viewModel);
            @strongify(self);
            if (x) {
                self.localData = _viewModel.data;
                self.videoTableView.daseModel = _viewModel.data;
                [self.videoTableView reloadData];
                [self reloadPlayModel];
                [self playByNetWork];
                
                NSArray *browse = [BrowseKouBeiArtModel findByColumn:@"id" value:_viewModel.data.info.id];
 
                if (![browse count]) {
                    if(![_viewModel.data.info.id isEqualToString:@""]){
                        [self saveBrowesModel];
                    }
                }else{
                    [self deleteBrowesModel:browse[0]];
                    [self saveBrowesModel];
                }
              
            }
        }];
        
 
        [[RACObserve(_viewModel, list)filter:^BOOL(id value) {
             @strongify(_viewModel);
            return _viewModel.list.isNotEmpty;
        }]subscribeNext:^(id x) {
             @strongify(_viewModel);
            @strongify(self);
            if (x) {
                if (_viewModel.videoCommentrequest.page == 1) {
                    [self.commitList removeAllObjects];
                    [self.commitList addObjectsFromArray:_viewModel.list.list];
                }else{
                     [self.commitList addObjectsFromArray:_viewModel.list.list];
                }
                
                if (self.commitTableView.mj_footer == nil) {
                    @weakify(_viewModel);
                    @weakify(self);
                    self.commitTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        @strongify(self);
                        @strongify(_viewModel);
                        _viewModel.videoCommentrequest.page++;
                        [self.commitTableView.mj_footer beginRefreshing];
                        self.viewModel.videoCommentrequest.startRequest = YES;
                    }];
                }
                
                if (_viewModel.list.page_count<10 ||_viewModel.list.totalpage == _viewModel.videoCommentrequest.page ) {
                    [self.commitTableView.mj_footer endRefreshingWithNoMoreData];
                    ((MJRefreshAutoNormalFooter*)self.commitTableView.mj_footer).stateLabel.text = @"";
                }else{
                    [self.commitTableView.mj_footer resetNoMoreData];
                }
                
                
                self.messageLabel.text = [NSString  stringWithFormat:@"%ld",self.commitList.count];
                self.commitTableView.commitList = self.commitList;
                [self.commitTableView reloadData];
            }
        }];
        
    }
    return _viewModel;
}

-(VideoTableView *)videoTableView{
    if (!_videoTableView) {
        _videoTableView = [[VideoTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        //防止计数器循环引用
        __weak VideoViewController *blockSelf = self;
        @weakify(_videoTableView);
        _videoTableView.block = ^(VideoModel *model) {
            __strong VideoViewController *strongObj = blockSelf;
            if (strongObj) {
                
                strongObj.viewModel.request.id = model.id;
                strongObj.viewModel.request.startRequest = YES;

                strongObj.viewModel.videoCommentrequest.aid = model.id;
                strongObj.viewModel.videoCommentrequest.page = 1;
                strongObj.viewModel.videoCommentrequest.startRequest = YES;
                
            }

        };
    }
    return _videoTableView;
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
                  self.viewModel.videoCommentrequest.page = 1;
                  self.sendCommentView.messageTextView.text =@"";
                  self.sendCommentView.sendButton.enabled = NO;
                  [self.sendCommentView setHidden:YES];
                  self.viewModel.videoCommentrequest.startRequest = YES;
              }else{
                  
              }
          }];
    }
    return _addCommentViewModel;
}

-(SubjectAndSaveObject *)subjectTool{
    if(!_subjectTool){
        _subjectTool = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectTool;
}

@end
