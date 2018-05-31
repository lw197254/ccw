//
//  OtherViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/2/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "OtherViewController.h"
#import "CollectionViewController.h"
#import "BrowseViewController.h"
#import "TagsViewController.h"

#import "OtherTableViewCell.h"
#import "AboutUSViewController.h"
#import "FeedBackViewController.h"
#import "MySubscribeViewController.h"
#import "SetUpViewController.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"
#import "UserInfoViewController.h"
#import "ThirdLoginObject.h"
#import "DialogView.h"

#import "SaveFlow.h"
#import "UserModel.h"

#import "ReadRecordModel.h"
#import "VerticalImageTitleButton.h"
#import "MessageCenterViewController.h"
#import "GetUserPushDynamicViewModel.h"
#import "MyDynamicViewModel.h"
#import "ReBackViewModel.h"
#import "JPUSHService.h"


@interface OtherViewController ()
//@property (weak, nonatomic) IBOutlet UIView *mySubscribe;
//
//@property (weak, nonatomic) IBOutlet UIView *myCollection;
//@property (weak, nonatomic) IBOutlet UIView *browseHistroy;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegistButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;
@property (weak, nonatomic) IBOutlet VerticalImageTitleButton *weichatLoginButton;
@property (weak, nonatomic) IBOutlet VerticalImageTitleButton *QQLoginButton;
@property (weak, nonatomic) IBOutlet VerticalImageTitleButton *sinaLoginButton;
@property (weak, nonatomic) IBOutlet UIView *thirdLoginContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLoginContentViewHeightConstraint;
@property (strong,nonatomic) MyDynamicViewModel *myDynamicViewModel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
#define like @"我的喜好"
#define favirate @"我的收藏"
#define subscribe @"我的订阅"
#define history @"浏览历史"
#define judgeUs @"给我评分"
#define aboutUs @"关于我们"

#define feedBack @"意见反馈"

#define icon @"icon"
#define title @"title"

@property(nonatomic,assign)bool isSwitch;

//列表数据
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)ThirdLoginObject*thirdLogin;
//缓存大小
@property(nonatomic,strong)NSString *acaheSize;
//缓存的cell的位置
@property(nonatomic,strong)NSIndexPath *cellPath;

@property(nonatomic,strong)GetUserPushDynamicViewModel *viewModel;
@property(nonatomic,strong)ReBackViewModel *rebackViewModel;
@property(nonatomic,assign)CGFloat headbackgroundImageHeight;


@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIImage*image = [UIImage imageNamed:@"我的头部背景.png"];
    self.headerBackgroundImageView.image = [image stretchableImageWithLeftCapWidth:320/2 topCapHeight:10];
    // Do any additional setup after loading the view from its nib.
    
    self.redLabel.layer.cornerRadius=self.redLabel.frame.size.width/2;//裁成圆角
    self.redLabel.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    
    [self.redLabel setHidden:YES];
    
    [self configThirdLoginUI];
   
   
    
    [self addViewEvent];
    //    self.acaheSize = [self memory];
    [self initTable];
//    self.list = @[
//  @[@{icon:like,title:like},
//  @{icon:favirate,title:favirate},
//    @{icon:subscribe,title:subscribe},
//    @{icon:history, title:history}],
//  @[@{icon:judgeUs,title:judgeUs},
//    @{icon:aboutUs,title:aboutUs},
//    @{icon:feedBack,title:feedBack},
//    ]
//  ];
    
    self.list = @[
                  @[
                    @{icon:favirate,title:favirate},
                    @{icon:subscribe,title:subscribe},
                    @{icon:history, title:history}],
                  @[@{icon:judgeUs,title:judgeUs},
                    @{icon:aboutUs,title:aboutUs},
                    @{icon:feedBack,title:feedBack},
                    ]
                  ];
    
    
    [RACObserve([UserModel shareInstance], uid)subscribeNext:^(id x) {
        if ([UserModel shareInstance].uid.isNotEmpty) {
            self.thirdLoginContentView.hidden = YES;
            self.thirdLoginContentViewHeightConstraint.constant = 0;
        }else{
            
            self.thirdLoginContentView.hidden = NO;
            self.thirdLoginContentViewHeightConstraint.constant = 110;
        }
        UIView*view = self.tableView.tableHeaderView;
        view.frame = CGRectMake(0, 0, kwidth, [self tableViewHeaderViewHeight]);
        self.headbackgroundImageHeight = self.headerBackgroundImageView.frame.size.height;
        self.tableView.tableHeaderView = view;
    }];

    [[RACSignal combineLatest:@[
                              RACObserve([UserModel shareInstance], uid),
                               RACObserve([UserModel shareInstance], nickname),RACObserve([UserModel shareInstance], mobile)] reduce:^NSNumber*(NSString*uid,NSString*nickname,NSString*mobile){
                                   return @((uid.isNotEmpty&&nickname.isNotEmpty)||(uid.isNotEmpty&&mobile.isNotEmpty));
                               }]subscribeNext:^(NSNumber* x) {                                    if ([x boolValue]) {
                                       if ([UserModel shareInstance].nickname.isNotEmpty) {
                                           [self.loginAndRegistButton setTitle:[UserModel shareInstance].nickname forState:UIControlStateNormal];
                                       }else if ([UserModel shareInstance].mobile.isNotEmpty){
                                           [self.loginAndRegistButton setTitle:[UserModel shareInstance].mobile forState:UIControlStateNormal];
                                       }
                                   }else{
                                      [self.loginAndRegistButton setTitle:@"账号登录" forState:UIControlStateNormal];
                                   }
                               }];
    
   
    
    [RACObserve([UserModel shareInstance], head)subscribeNext:^(id x) {
        if ([UserModel shareInstance].head.isNotEmpty) {
            UIImage*image = self.headerImageView.image;
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].head] placeholderImage:image];
          
          
        }else{
            self.headerImageView.image = [UIImage imageNamed:@"我的默认头像"];
        }
    }];
    
    [RACObserve([UserModel shareInstance], dynamicCount) subscribeNext:^(id x) {
        if ([[UserModel shareInstance].dynamicCount intValue]>0) {
            [self.redLabel setHidden:NO];
        }else{
            [self.redLabel setHidden:YES];
        }
        
    }];
   

}

-(void)configThirdLoginUI{
    self.weichatLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.sinaLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.QQLoginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([WXApi isWXAppInstalled]) {
        
        self.weichatLoginButton.hidden = NO;
        [self.thirdLoginContentView distributeSpacingHorizontallySpaceEqualWith:@[self.sinaLoginButton,self.QQLoginButton,self.weichatLoginButton]  withLeftSpaceBaifenbi:7.0/15];
        
    }else{
        self.weichatLoginButton.hidden = YES;
        
        [self.thirdLoginContentView distributeSpacingHorizontallySpaceEqualWith:@[self.sinaLoginButton,self.QQLoginButton]  withLeftSpaceBaifenbi:7.0/15];
        
    }

}
//添加头部信息
-(void)addViewEvent{
    //    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonView:)];
    //    [tapRecognizer setNumberOfTapsRequired:1];
    //    self.myCollection.tag = 0;
    //    [self.myCollection addGestureRecognizer:tapRecognizer];
    //
    //
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonView:)];
    //    [tapRecognizer setNumberOfTapsRequired:1];
    //    self.browseHistroy.tag = 1;
    //    [self.browseHistroy addGestureRecognizer:tap];
    //
    //    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonView:)];
    //    [tapRecognizer setNumberOfTapsRequired:1];
    //    self.mySubscribe.tag = 2;
    //    [self.mySubscribe addGestureRecognizer:tap2];
    
}
- (IBAction)loginAndRegistButtonClicked {
  
    if ([UserModel shareInstance].uid.isNotEmpty) {
        UserInfoViewController*vc = [[UserInfoViewController alloc]init];
        [self.rt_navigationController pushViewController:vc animated:YES];
    }else{
        ShadowLoginViewController*login = [[ShadowLoginViewController alloc]init];
        [self.rt_navigationController pushViewController:login animated:YES];
        
    }
    
}
- (IBAction)sinaLoginClicked:(UIButton *)sender {
   
    [self.thirdLogin loginWithLoginDetailType:ThirdLoginTypeSina];
}
- (IBAction)QQLoginClicked:(UIButton *)sender {
   
    [self.thirdLogin loginWithLoginDetailType:ThirdLoginTypeQQ];
}
- (IBAction)weichatLoginClicked:(UIButton *)sender {
   
    [self.thirdLogin loginWithLoginDetailType:ThirdLoginTypeWeichat];
}

-(void)buttonView:(UITapGestureRecognizer*)tap{
    switch (tap.view.tag) {
        case 0:{

            CollectionViewController *controller = [[CollectionViewController alloc] init];
            
            [URLNavigation pushViewController:controller animated:YES];
            
        }
            break;
        case 1:
        {
            BrowseViewController *controller = [[BrowseViewController alloc] init];
            [URLNavigation pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            MySubscribeViewController *controller = [[MySubscribeViewController alloc] init];
            [URLNavigation pushViewController:controller animated:YES];
        }
        default:
            break;
    }
}

//初始化 tableview
-(void)initTable{
    
    [self.tableView registerNib:nibFromClass(OtherTableViewCell) forCellReuseIdentifier:classNameFromClass(OtherTableViewCell)];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
}

-(void)showRedType{
    
    self.myDynamicViewModel.request.uid = [UserModel shareInstance].uid;
    self.myDynamicViewModel.request.page = 1;
    self.myDynamicViewModel.request.token = [JPUSHService registrationID];
    
    
    @weakify(self);
    [[RACObserve(self.myDynamicViewModel,data)
      filter:^BOOL(id value) {
          return self.myDynamicViewModel.data.list.isNotEmpty;
      }]subscribeNext:^(id x) {
          @strongify(self);
          if (x) {
              if ([MyDynamicModel findAll].count>0) {
                  MyDynamicModel *temp = [MyDynamicModel findAll][0];
                  MyDynamicModel *first_temp = [self.myDynamicViewModel.data.list objectAtIndex:0];
                  
                  if ([temp.msg_id isEqualToString:first_temp.msg_id]) {
                      if (self.redLabel.hidden == NO) {
                          [self.redLabel setHidden:YES];
                      }
                  }else{
                      [self.redLabel setHidden:NO];
                  }
              }else{
                  [self.redLabel setHidden:NO];
              }
          }
      }];
    
    self.myDynamicViewModel.request.startRequest = YES;
    
    self.rebackViewModel.request.uid = [UserModel shareInstance].uid;
    self.rebackViewModel.request.page = 1;

     
    [[RACObserve(self.rebackViewModel,data)
     filter:^BOOL(id value) {
         return self.rebackViewModel.data.list.isNotEmpty;
     }]subscribeNext:^(id x) {
         @strongify(self);
         if (x) {

             if ([CommiteModel findAll].count>0) {
                 CommiteModel *temp = [CommiteModel findAll][0];
                 CommiteModel *first_temp = [self.rebackViewModel.data.list objectAtIndex:0];

                 if ([temp.id isEqualToString:first_temp.id]) {
                     if (self.redLabel.hidden == NO) {
                         return ;
                     }else{
                         [self.redLabel setHidden:YES];
                     }
                 }else{
                     [CommiteModel deleteAll];
                     [first_temp save];
                     [self.redLabel setHidden:NO];
                 }
             }else{
                 CommiteModel *first_temp = [self.rebackViewModel.data.list objectAtIndex:0];
                 [first_temp save];
                 [self.redLabel setHidden:NO];
                 
             }

         }
     }];

    self.rebackViewModel.request.startRequest =YES;
}


////缓存数据
//-(NSString*)memory{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths lastObject];
//    NSString *str = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:path]];
//    return str;
//}
//
////清除本地已经查看的数据
//-(void)clearReadRecord{
//    [ReadRecordModel deleteAll];
//}
//
////清除缓存数据
//-(void)CacheMemory{
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths lastObject];
//    path = [path stringByAppendingString:@"/Caches"];
//    NSString *str = [NSString stringWithFormat:@"缓存已清除%.1fM", [self folderSizeAtPath:path]];
//    NSLog(@"%@",str);
//    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
//    for (NSString *p in files) {
//        NSError *error;
//        NSString *Path = [path stringByAppendingPathComponent:p];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
//            [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
//        }
//    }
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array = self.list[section];
    return array.count;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ViewController*vc = [[ViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray*array = self.list[indexPath.section];
    NSDictionary*dict = array[indexPath.row];
    NSString*titleStr = dict[title];
    
    NSString *uid = [UserModel shareInstance].uid;
    
    
    if ([titleStr isEqual:like]) {
        
        
        TagsViewController *controller = [[TagsViewController alloc] init];
        
        [URLNavigation pushViewController:controller animated:YES];
        
    }else if ([titleStr isEqual:favirate]) {
        
        if (![uid isNotEmpty]) {
            ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
            [URLNavigation pushViewController:controller animated:YES];
            
            controller.loginSuccessBlock = ^{
                
                CollectionViewController *controller = [[CollectionViewController alloc] init];
                [URLNavigation pushViewController:controller animated:YES];
            };
            return ;
        }
        
        CollectionViewController *controller = [[CollectionViewController alloc] init];
        
        [URLNavigation pushViewController:controller animated:YES];
        
    }else if ([titleStr isEqual:subscribe]){
        
        if (![uid isNotEmpty]) {
            ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
            [URLNavigation pushViewController:controller animated:YES];
            
            controller.loginSuccessBlock = ^{
                
                MySubscribeViewController *controller = [[MySubscribeViewController alloc] init];
                [URLNavigation pushViewController:controller animated:YES];
            };
            return ;
        }
        
        MySubscribeViewController *controller = [[MySubscribeViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];

    }else if ([titleStr isEqual:history]){
        BrowseViewController *controller = [[BrowseViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
        
    }else if ([titleStr isEqual:aboutUs]){
        AboutUSViewController *controller = [[AboutUSViewController alloc] init];
        //                BuyCarCalculatorViewController*controller = [[BuyCarCalculatorViewController alloc]init];
        [URLNavigation pushViewController:controller animated:YES];
    }else if ([titleStr isEqual:feedBack]){
        FeedBackViewController *controller = [[FeedBackViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
    }else if ([titleStr isEqual:judgeUs]){
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        
      
    }
    
    //
    //}
    //break;
    //case 1:
    //{
    //
    //}
    //break;
    //case 2:
    //{
    //
    //}
    //
    //
    //    switch (indexPath.row) {
    //        case 0:
    //        {
    //            if (indexPath.section == 0) {
    //                [self showClearMemoryAlert];
    //            }else{
    //                AboutUSViewController *controller = [[AboutUSViewController alloc] init];
    ////                BuyCarCalculatorViewController*controller = [[BuyCarCalculatorViewController alloc]init];
    //                [URLNavigation pushViewController:controller animated:YES];
    //            }
    //
    //        }
    //            break;
    //        case 1:
    //        {
    //            if(indexPath.section == 0){
    //                return;
    //            }else{
    //                FeedBackViewController *controller = [[FeedBackViewController alloc] init];
    //                [URLNavigation pushViewController:controller animated:YES];
    //            }
    //        }
    //            break;
    //        default:
    //            break;
    //    }
}
- (IBAction)SettingClicked:(UIButton *)sender {
    SetUpViewController*vc = [[SetUpViewController alloc]init];
    [self.rt_navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(OtherTableViewCell) forIndexPath:indexPath];
  
    NSArray*array  = self.list[indexPath.section];
    NSDictionary*dict = array[indexPath.row];
    NSString*titleStr = dict[title];
    NSString*iconName = dict[icon];
    
    cell.titleLabel.text = titleStr;
    cell.headImageView.image = [UIImage imageNamed:iconName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        if(indexPath.row == 1){
    //            [cell.switchButton setHidden: NO];
    //            [cell.labelView setHidden:YES];
    //            [cell.switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    //            [RACObserve(self, isSwitch)subscribeNext:^(id x) {
    //                [cell.switchButton setOn:[SaveFlow getFlowSign]];
    //            }];
    //
    //        }else{
    //            self.cellPath = indexPath;
    //            //缓存大小
    //            [cell.switchButton setHidden: YES];
    //            cell.labelValue.text = self.acaheSize;
    //
    //        }
    //    }else{
    //        cell.label.text = self.secondList[indexPath.row];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        [cell.switchButton setHidden: YES];
    //        [cell.labelValue setHidden:YES];
    //        if (indexPath.row == 1) {
    //            [self setline:cell];
    //            [self setbottomline:cell];
    //        }
    //    }
    return cell;
}

-(void)switchAction:(id)sender
{
    //    UISwitch *switchButton = (UISwitch*)sender;
    //    BOOL isButtonOn = [switchButton isOn];
    //    if (isButtonOn) {
    //        [self showAlert];
    //    }else {
    //        [SaveFlow setFlowSign:false];
    //        self.isSwitch = false;
    //    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
    //    if (indexPath.section == 0 ) {
    //        if (indexPath.row == 1) {
    //            return 60;
    //        }
    //    }
    //   return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.000001;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    if (section == self.list.count-1) {
    //        return 40;
    //    }
    return 0.000001;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
    [view.contentView setBackgroundColor:[UIColor clearColor]];
    return view;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 10)];
    [view.contentView setBackgroundColor:[UIColor clearColor]];
    return view;
    
}

//清除缓存的方法
- (void)showClearMemoryAlert {
    //    NSString *title = NSLocalizedString(@"提示", nil);
    //    NSString *message = NSLocalizedString(@"确定要清除缓存吗？", nil);
    //    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    //    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    //
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //
    //    // Create the actions.
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //
    //    }];
    //
    //    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        MBProgressHUD*hud = [[MBProgressHUD alloc]initWithView:self.view];
    //        hud.removeFromSuperViewOnHide = YES;
    //        [self.view addSubview:hud];
    //       // [hud show:YES];
    //
    ////        MBProgressHUDModeIndeterminate,
    ////        /** Progress is shown using a round, pie-chart like, progress view. */
    ////        MBProgressHUDModeDeterminate,
    ////        /** Progress is shown using a horizontal progress bar */
    ////        MBProgressHUDModeDeterminateHorizontalBar,
    ////        /** Progress is shown using a ring-shaped progress view. */
    ////        MBProgressHUDModeAnnularDeterminate,
    ////        /** Shows a custom view */
    ////        MBProgressHUDModeCustomView,
    ////        /** Shows only labels */
    ////        MBProgressHUDModeText
    //
    //
    //        // Configure for text only and offset down
    //        hud.mode = MBProgressHUDModeIndeterminate;
    //         hud.labelText = @"清理中";
    //        //    hud.yOffset = 150.f;
    //        hud.removeFromSuperViewOnHide = YES;
    //       [hud showAnimated:YES whileExecutingBlock:^{
    //           [self clearReadRecord];
    //           [self CacheMemory];
    //            hud.labelText = @"清理成功";
    //       } onQueue:[GCDQueue globalQueue].dispatchQueue completionBlock:^{
    //
    //           OtherTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.cellPath];
    //           cell.labelValue.text = @"";
    //       }];
    //
    //        //[[DialogView sharedInstance]showDlg:self.view textOnly:@"清理成功"];
    //        //这边清除后补不现实任何数字
    //
    //
    //    }];
    //
    //    // Add the actions.
    //    [alertController addAction:cancelAction];
    //    [alertController addAction:otherAction];
    //
    //    [self presentViewController:alertController animated:YES completion:nil];
}

//
////清除省流量的方法
//- (void)showAlert {
//    NSString *title = NSLocalizedString(@"提示", nil);
//    NSString *message = NSLocalizedString(@"在省流量模式下,文章内容中的图片将被压缩,有可能影响阅读体验,是否确定开启省流量模式", nil);
//    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
//    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//
//    // Create the actions.
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [SaveFlow setFlowSign:false];
//        self.isSwitch = false;
//
//    }];
//
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [SaveFlow setFlowSign:true];
//        self.isSwitch = true;
//    }];
//
//    // Add the actions.
//    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
////遍历文件夹获得文件夹大小，返回多少M
//- (float)folderSizeAtPath:(NSString*) folderPath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:folderPath]) return 0;
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
//    NSString* fileName;
//    long long folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//    }
//
//   return folderSize/(1024.0*1024.0);
//}
//
//- (long long) fileSizeAtPath:(NSString*) filePath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
//    }
//    return 0;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
////设置一下线
//-(void)setbottomline:(UIView *)cell{
//        UIView *view = [[UIView alloc] init];
//        [cell addSubview:view];
//         [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.right.left.equalTo(cell);
//            make.height.mas_equalTo(1);
//        }];
//        view.backgroundColor= cutlineback;
//}
//
////设置一下线
//-(void)setline:(UIView *)cell{
//    if(cell.tag != 1){
//        UIView *view = [[UIView alloc] init];
//        [cell addSubview:view];
//        cell.tag = 1;
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.left.equalTo(cell);
//            make.height.mas_equalTo(0.5);
//        }];
//        view.backgroundColor= seperateLineColor;
//        
//    }

//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
//    if (offset.y < 0) {
//        offset.y = 0;
//         scrollView.contentOffset = offset;
//    }
    ///禁止下拉
   
   
    [self scaleImageView:self.headerBackgroundImageView orginalSize:CGSizeMake(kwidth, self.headbackgroundImageHeight) offSetY:scrollView.contentOffset.y];
}

-(void)scaleImageView:(UIImageView*)imageView orginalSize:(CGSize)orginalSize offSetY:(CGFloat)offSetY{
    if(offSetY < 0)
    {
        //获取第一个cell
        
        CGFloat imageH =orginalSize.height;
        
        CGFloat percent = (-offSetY + imageH)/imageH;
        //获得cell的尺寸
//        CGRect cellFrame = imageView.frame;
//        CGPoint cellCenter = imageView.center;
//        cellFrame.size.width = [UIScreen mainScreen].bounds.size.width *percent;
//        cellFrame.size.height = imageH *percent;
//        cellCenter.x = cellCenter.x;
//        cellCenter.y = cellFrame.size.height/2;
//        imageView.center = cellCenter;
//        imageView.bounds = cellFrame;
        
        
        imageView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, percent), 0, offSetY/4);
    }
    
}
-(NSInteger)tableViewHeaderViewHeight{
    return 260-110 + self.thirdLoginContentViewHeightConstraint.constant + StatusHeight;
}
-(ThirdLoginObject*)thirdLogin{
    if (!_thirdLogin) {
        _thirdLogin = [[ThirdLoginObject alloc]init];
    }
    return _thirdLogin;
}

- (IBAction)gotoTheMessgaeCenter:(id)sender {
    
    NSString *uid = [UserModel shareInstance].uid;
    
    if (![uid isNotEmpty]) {
            ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        
            
            controller.loginSuccessBlock = ^{
                
                MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
                
                [self.rt_navigationController pushViewController:vc animated:YES];
            };
        
            [self.rt_navigationController pushViewController:controller animated:YES];
            return ;
    }
        
    MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
    [self.rt_navigationController pushViewController:vc animated:YES];
}

-(GetUserPushDynamicViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [GetUserPushDynamicViewModel SceneModel];
    }
    return _viewModel;
}

-(ReBackViewModel *)rebackViewModel{
    if (!_rebackViewModel) {
        _rebackViewModel = [ReBackViewModel SceneModel];
    }
    return _rebackViewModel;
}

-(MyDynamicViewModel *)myDynamicViewModel{
    if (!_myDynamicViewModel) {
        _myDynamicViewModel = [MyDynamicViewModel SceneModel];
    }
    return _myDynamicViewModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    
    if ([[UserModel shareInstance].uid isNotEmpty]) {
        
        [self showRedType];
    }

}

@end
