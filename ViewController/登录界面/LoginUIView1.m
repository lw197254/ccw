//
//  LoginUIView1.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "LoginUIView1.h"

#import "TabBarViewController.h"
#import "LoginViewModel.h"
#import "ForgetPasswordViewController.h"
#import "RegistViewController.h"
#import "Timer.h"
//#import "UMSocial.h"
#import "WebViewController.h"
#import "NewPasswordViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UserSujectDB.h"

#import "ThirdLoginObject.h"

#import "UserInfo.h"




@interface LoginUIView1()
#pragma 账号密码登录
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)confirmClicked:(id)sender;
- (IBAction)forgetPasswordClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *thirdLoginView;

@property(nonatomic,strong)Timer*timer;



@property (weak, nonatomic) IBOutlet UIButton *weiChatLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *QQLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaLoginButton;

@property(nonatomic,assign)NSInteger currentPage;


@property (weak, nonatomic) IBOutlet UILabel *fastLogin;


@property(nonatomic,strong)LoginViewModel*viewModel;

@property(nonatomic,strong)UserSujectDB *userDB;

@property(nonatomic,strong)ThirdLoginObject*thirdLogin;

@end

@implementation LoginUIView1


-(instancetype)init{
    if (self = [super init]) {
        [[NSBundle mainBundle]loadNibNamed:@"LoginUIView1" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self viewDidLoad];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle]loadNibNamed:@"LoginUIView1" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self viewDidLoad];
    }
    return self;
}
-(UserSujectDB *)userDB{
    if (!_userDB) {
        NSLog(@"初始化 %@",self.class);
        _userDB = [[UserSujectDB alloc] init];
    }
    return _userDB;
}

//-(void)loginSuccess:(LoginSuccessBlock)successBlock{
//    if (self.loginSuccessBlock != successBlock) {
//        self.loginSuccessBlock = successBlock;
//    }
//}

// 3. 在此方法中设置点击label后要触发的操作
- (void)labelClick {
    if (self.showDelagate) {
        [self.showDelagate changeView:@"rightView"];
    }
}

- (void)viewDidLoad {
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
   
    // 2. 将点击事件添加到label上
    [self.fastLogin addGestureRecognizer:labelTapGestureRecognizer];
    self.fastLogin.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    [self confignormalLoginData];
    
    [self thirdLoginRAC];
    
    ///根据微信是否安装调整布局
    if ([WXApi isWXAppInstalled]) {
        
        self.weiChatLoginButton.hidden = NO;
       [self.thirdLoginView distributeSpacingHorizontallySpaceEqualWith:@[self.sinaLoginButton,self.QQLoginButton,self.weiChatLoginButton]  withLeftSpaceBaifenbi:8.0/13];
        
    }else{
        self.weiChatLoginButton.hidden = YES;
        
        [self.thirdLoginView distributeSpacingHorizontallySpaceEqualWith:@[self.sinaLoginButton,self.QQLoginButton]  withLeftSpaceBaifenbi:8.0/13];
    }
    
}
-(void)confignormalLoginData{
    
    if ([UserModel shareInstance].mobile.isNotEmpty) {
        self.accountField.text = [UserModel shareInstance].mobile;
    }
    self.accountField.keyboardType = UIKeyboardTypePhonePad;
    @weakify(self);
    [[RACSignal combineLatest:@[self.accountField.rac_textSignal,self.passwordField.rac_textSignal] reduce:^(NSString*acount,NSString*password){
        return @(acount.isNotEmpty&&password.isNotEmpty);
    }]subscribeNext:^(NSNumber *res) {
        @strongify(self);
        if (res.boolValue == NO) {
            
            self.confirmButton.enabled = NO;
            
        }else{
            
            self.confirmButton.enabled = YES;
            
        }
    }];
    
    //登录
    [[RACObserve(self.viewModel.loginRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.loginRequest.succeed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         NSDictionary*dict =self.viewModel.loginRequest.output;
         NSLog(@"%@",dict);
         [[UserModel shareInstance] mergeFromDictionary:dict[@"data"] useKeyMapping:NO];
         self.viewModel.userInfoRequest.uid = [UserModel shareInstance].uid;
         [UserModel shareInstance].loginType = LoginTypeCheChengWang;
         [[UserModel shareInstance]updateToUserdefault];
         self.viewModel.userInfoRequest.startRequest = YES;
         
     }];
    
    [[RACObserve(self.viewModel.userInfoRequest,state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.userInfoRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          [[UserModel shareInstance] mergeFromDictionary:self.viewModel.userInfoRequest.output[@"data"] useKeyMapping:YES];
          
          [[DialogUtil sharedInstance]showDlg:self textOnly:@"成功"];
          [self loginSucess];
      }];
    
}
-(void)loginSucess{
    
    [UserInfo setUserName:[UserModel shareInstance].nickname];
    [UserInfo setUserPhone:[UserModel shareInstance].mobile];
    ///唯一一次请求同步数据
    [self.userDB setUpSubjectList];
    [self.userDB setUpCollectionList];
    
    @weakify(self)
    [[RACObserve(self.userDB, isCollection)filter:^BOOL(id value) {
        return self.userDB.isCollection;
    }]
     subscribeNext:^(id x) {
         @strongify(self)
         if (x) {
             if (self.showDelagate) {
                 //list数据返回了
                 NSLog(@"list数据返回");
                 [self.showDelagate loginSucess];;
             }
         }
//         }else{
//             // 张宇账号问题 13770370357 密码：123456 登录成功不跳转，拿不到collection的数据
//             if (self.showDelagate) {
//                 //list数据返回了
//                 NSLog(@"list数据返回");
//                 [self.showDelagate loginSucess];;
//             }
//         }
     }];
}


- (IBAction)confirmClicked:(id)sender {
    
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString*phoneNumber = [_accountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*password = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(!phoneNumber.isNotEmpty){
        [AlertView showAlertWithMessage:@"手机号不能为空"];
        return;
    }else if (![ZhengZeBianMa checkPhoneNumInputWithStr:phoneNumber]) {
        [AlertView showAlertWithMessage:@"手机号错误"];
        return;
    }
    if(!password.isNotEmpty){
        [AlertView showAlertWithMessage:@"密码不能为空"];
        return;
    }
    
    [MobClick event:findpage_login];
    
    self.viewModel.loginRequest.mobile =phoneNumber;
    self.viewModel.loginRequest.pwd =password;
    
    self.viewModel.loginRequest.startRequest = YES;
    [UserModel shareInstance].mobile =self.viewModel.loginRequest.mobile;
    [[UserModel shareInstance] updateToUserdefault];
    
}

- (IBAction)forgetPasswordClicked:(id)sender {
    if (self.showDelagate) {
        [self.showDelagate forgetPassword:self.accountField.text];
    }
    [MobClick event:findpage_frogetpassword];
    
    
}

//#pragma mark 手机号快捷登录
//- (IBAction)getPassCodeClicked:(UIButton*)sender {
//
//    [self.mobileField resignFirstResponder];
//    [self.passcodeField resignFirstResponder];
//    if (![ZhengZeBianMa checkPhoneNumInputWithStr: self.mobileField.text] ) {
//        [AlertView showAlertWithMessage:@"手机号码不正确"];
//        return;
//    }
//    self.viewModel.codeRequest.mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
//    self.viewModel.codeRequest.startRequest = YES;
//    sender.enabled = NO;
//    self.timer = [Timer timerWithTimeInerval:60 repeatBlock:^(NSString *time) {
//        [sender setTitle:time forState:UIControlStateNormal];
//        //       sender.titleLabel.text = time;
//    } finishedRepeat:^(NSString *title) {
//        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
//        //        sender.titleLabel.text = @"获取验证码";
//        sender.enabled = YES;
//    } ];
//}
//
//-(void)configFastLoginData{
//
//    self.mobileField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 1)];
//    self.mobileField.leftViewMode = UITextFieldViewModeAlways;
//
//    self.passcodeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 1)];
//    self.passcodeField.leftViewMode = UITextFieldViewModeAlways;
//
//    if ([UserModel shareInstance].mobile.isNotEmpty) {
//        self.mobileField.text = [UserModel shareInstance].mobile;
//    }
//
//    @weakify(self);
//    [[RACSignal combineLatest:@[self.mobileField.rac_textSignal,self.passcodeField.rac_textSignal] reduce:^(NSString*mobile,NSString*passCode){
//        return @(mobile.isNotEmpty&&passCode.isNotEmpty);
//    }]subscribeNext:^(NSNumber* enabled) {
//        @strongify(self);
//        if (enabled.boolValue) {
//            [self.fastLogin setBackgroundColor:LightBlueColor];
//        }else{
//            [self.fastLogin setBackgroundColor:[LightBlueColor colorWithAlphaComponent:0.3]];
//        }
//
//    }];
//    [[RACObserve(self.viewModel.codeRequest, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          return self.viewModel.codeRequest.succeed;
//      }]subscribeNext:^(id x) {
//
//          [AlertView showAlertWithMessage:@"验证码已发送"];
//
//      }];
//    [[RACObserve(self.viewModel.codeRequest, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          return self.viewModel.codeRequest.failed;
//      }]subscribeNext:^(id x) {
//          [self.timer stopTimer];
//          self.getPasscodeButton.enabled = YES;
//
//      }];
//    [[RACObserve(self.viewModel.fastLoginRequest, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          return  self.viewModel.fastLoginRequest.succeed;
//      }]subscribeNext:^(id x) {
//          @strongify(self);
//          [[UserModel shareInstance]mergeFromDictionary:self.viewModel.fastLoginRequest.output[@"data"] useKeyMapping:YES];
//          NSObject*obj =self.viewModel.fastLoginRequest.output[@"data"][@"set_pwd"] ;
//          if (obj.isNotEmpty&& ([obj isEqual:@"1"]||[obj isEqual:@(1)])) {
//
//              NewPasswordViewController*password = [[NewPasswordViewController alloc]init];
//              password.isFastLogin = YES;
//              password.mobile = self.mobileField.text;
//
//              [self.rt_navigationController pushViewController:password animated:YES];
//              return ;
//          }else{
//
//
//              [self loginSucess];
//          }
//      }];
//
//}
//
//- (IBAction)fastLoginClicked:(UIButton *)sender {
//    NSString*phoneNumber = [_mobileField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString*passcode = [_passcodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//    if(!phoneNumber.isNotEmpty){
//        [AlertView showAlertWithMessage:@"手机号不能为空"];
//        return;
//    }else if (![ZhengZeBianMa checkPhoneNumInputWithStr:phoneNumber]) {
//        [AlertView showAlertWithMessage:@"手机号错误"];
//        return;
//    }
//    if(!passcode.isNotEmpty){
//        [AlertView showAlertWithMessage:@"验证码不能为空"];
//        return;
//    }
//    [self.mobileField resignFirstResponder];
//    [self.passcodeField resignFirstResponder];
//
//    self.viewModel.fastLoginRequest.mobile =phoneNumber;
//    self.viewModel.fastLoginRequest.code =passcode;
//
//    self.viewModel.fastLoginRequest.startRequest = YES;
//    [UserModel shareInstance].mobile =self.viewModel.fastLoginRequest.mobile;
//    [[UserModel shareInstance] updateToUserdefault];
//
//}
- (IBAction)securyTextChanged:(UIButton *)sender {
    sender.selected  =!sender.selected;
    self.passwordField.secureTextEntry =  !sender.selected;
}

- (IBAction)userProtocolClicked:(UIButton *)sender {
    WebViewController*web = [[WebViewController alloc]init];
    web.titleString = @"用户协议";
    //  web.urlString = [NSString stringWithFormat:@"%@/protocol",WebViewHead];
//    [self.rt_navigationController pushViewController:web animated:YES];
}



//#pragma mark 第三方登录
////是否展示第三方登录界面
//- (IBAction)thirdLoginClicked:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if (sender.selected ==YES) {
//          self.thirdLoginViewHeightConstraint.constant = 67;
//        [UIView animateWithDuration:0.25 animations:^{
//
//            [self.thirdLoginSuperView layoutIfNeeded];
//
//
//        }completion:^(BOOL finished) {
//        }] ;
//
//
//    }else{
//          self.thirdLoginViewHeightConstraint.constant = 0;
//        [UIView animateWithDuration:0.25 animations:^{
//
//             [self.thirdLoginSuperView layoutIfNeeded];
//
//
//        }completion:^(BOOL finished) {
//
//        }] ;
//
//    }
//}


-(void)thirdLoginRAC{
    
    
    [[RACObserve(self.viewModel.thirdLoginRequest,state)
      filter:^BOOL(id value) {
         
          return self.viewModel.thirdLoginRequest.succeed;
      }]
     subscribeNext:^(id x) {
         
         NSDictionary*dict = [self.viewModel.thirdLoginRequest.output valueForKey:@"data"];
         
         if (dict!=nil) {
             [[UserModel shareInstance]mergeFromDictionary:dict useKeyMapping:YES];
             self.viewModel.userInfoRequest.uid = [UserModel shareInstance].uid;
             self.viewModel.userInfoRequest.startRequest = YES;
         }
     }];

}
-(void)handelThirdLoginWithLoginType:(SSDKPlatformType)type unionTypeName:(NSString*)unionTypeName{
    
    ///https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN
    
    
    
    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state==SSDKResponseStateSuccess&&user.credential){
            
            ///rawData是原始数据
            NSDictionary * doc = user.rawData;
            NSString*unionid;
            
            if (type==SSDKPlatformTypeSinaWeibo) {
                unionid = user.uid;
            }else {
                unionid = [doc objectForKey:@"unionid"];
                if (!unionid.isNotEmpty) {
                    unionid = user.uid;
                }
            }
            
            ///男
            NSString*gender = [NSString stringWithFormat:@"%ld",(long)GenderMan] ;
            
            if (user.gender==SSDKGenderFemale) {
                gender = [NSString stringWithFormat:@"%ld",(long)GenderWomen] ;
            }
            //           NSDictionary*data = [NSDictionary dictionaryWithObjectsAndKeys:unionid,@"userId",user.nickname,@"nickname",user.icon,@"img",user.gender,@"gender",sourceData[@"city"],@"city",sourceData[@"province"],@"province", nil];
            
            self.viewModel.thirdLoginRequest.unionTypeName = unionTypeName;
            self.viewModel.thirdLoginRequest.unionId = unionid;
            self.viewModel.thirdLoginRequest.nickname = user.nickname;
            self.viewModel.thirdLoginRequest.sex = gender;
            self.viewModel.thirdLoginRequest.head = user.icon;
            //           self.viewModel.thirdLoginRequest.data = data;
            
            
            [UserModel shareInstance].loginType = LoginTypeThirdSource;
            [[UserModel shareInstance]updateToUserdefault];
            
            
            if (type == SSDKPlatformTypeQQ) {
                [self unionIDRequestWithToken:user.credential.token];
            }else{
                self.viewModel.thirdLoginRequest.startRequest = YES;
         
            }
        }else{
            [[DialogUtil sharedInstance]showDlg:self textOnly: @"登录失败"];
        }
    }];
    
    
}
-(IBAction)weixinLoginClicked:(UIButton*)button{
    [MobClick event:wechatlogin];
    

    [self handelThirdLoginWithLoginType:SSDKPlatformSubTypeWechatTimeline unionTypeName:thirdLoginTypeWechat];

}

-(IBAction)sinaLoginClicked:(UIButton*)button{
    [MobClick event:sinalogin];
    //  AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    //    request.redirectURI = sinaShareCallBack;
    //    request.scope = @"all";
    //    request.userInfo = @{@"SSO_From": classNameFromClass([self class]),
    //                         @"Other_Info_1": [NSNumber numberWithInt:123],
    //                         @"Other_Info_2": @[@"obj1", @"obj2"],
    //                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    [WeiboSDK sendRequest:request];
    
    [self handelThirdLoginWithLoginType:SSDKPlatformTypeSinaWeibo unionTypeName:thirdLoginTypeWeibo];
    
    //    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
    //
    //    } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
    //
    //    }];
    
}




-(IBAction)QQLoginClicked:(UIButton*)button{
    // SSDKPlatformSubTypeQQFriend
    [MobClick event:qqlogin];
    
    
    
    [self handelThirdLoginWithLoginType:SSDKPlatformTypeQQ unionTypeName:thirdLoginTypeQQ];
    //  [ ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
    //
    //      if (result&&userInfo.sourceData.isNotEmpty) {
    //          NSDictionary*sourceData = userInfo.sourceData;
    //
    //
    ////      city = "\U5a01\U6d77";
    ////      figureurl = "http://qzapp.qlogo.cn/qzapp/1105697503/89A1226E6D87A029F42D7437D2A42822/30";
    ////      "figureurl_1" = "http://qzapp.qlogo.cn/qzapp/1105697503/89A1226E6D87A029F42D7437D2A42822/50";
    ////      "figureurl_2" = "http://qzapp.qlogo.cn/qzapp/1105697503/89A1226E6D87A029F42D7437D2A42822/100";
    ////      "figureurl_qq_1" = "http://q.qlogo.cn/qqapp/1105697503/89A1226E6D87A029F42D7437D2A42822/40";
    ////      "figureurl_qq_2" = "http://q.qlogo.cn/qqapp/1105697503/89A1226E6D87A029F42D7437D2A42822/100";
    ////      gender = "\U7537";
    ////      "is_lost" = 0;
    ////      "is_yellow_vip" = 0;
    ////      "is_yellow_year_vip" = 0;
    ////      level = 0;
    ////      msg = "";
    ////      nickname = "\U5fe7\U4f24\U8fd8\U662f\U5feb\U4e50";
    ////      province = "\U5c71\U4e1c";
    ////      ret = 0;
    //          NSString*uid =sourceData[@"uid"];
    //           NSDictionary*data = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"userId",sourceData[@"nickname"],@"nickname",sourceData[@"figureurl_qq_1"],@"img",sourceData[@"gender"],@"gender",sourceData[@"city"],@"city",sourceData[@"province"],@"province", nil];
    ////      vip = 0;
    ////      "yellow_vip_level" = 0;
    //          self.viewModel.thirdLoginRequest.thirdType = thirdLoginTypeQQ;
    //          self.viewModel.thirdLoginRequest.signUserId = uid;
    //          self.viewModel.thirdLoginRequest.data = data;
    //          self.viewModel.thirdLoginRequest.startRequest = YES;
    //      }
    //   }];
    ////    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeMobileQQ];
    ////
    ////    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    ////
    ////    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    ////
    ////        NSLog(@"response is %@",response);
    ////
    ////        if (response.responseCode == UMSResponseCodeSuccess) {
    ////
    ////            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
    ////
    ////            NSLog(@"=========%@",snsAccount.accessToken);
    ////
    ////        }
    ////
    ////    });
    
}

-(void)unionIDRequestWithToken:(NSString*)token{
    NSDictionary*dict = @{@"access_token":token,@"unionid":@"1"};
    AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"https://graph.qq.com/oauth2.0/me" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData* data = responseObject;
        NSMutableString*response=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSRange unionIdRange =   [response rangeOfString:@"unionid"];
        
        
        NSString*unionid = [response substringFromIndex: unionIdRange.location+@"\":\"".length+@"unionid".length];
        unionid = [[unionid componentsSeparatedByString:@"\""]firstObject];
        self.viewModel.thirdLoginRequest.unionId = unionid;
        self.viewModel.thirdLoginRequest.startRequest = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DialogView sharedInstance]showDlg:self textOnly:@"网络或服务器故障"];
    }];
    
}
-(LoginViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [LoginViewModel SceneModel];
    }
    return _viewModel;
}



-(ThirdLoginObject*)thirdLogin{
    if (!_thirdLogin) {
        _thirdLogin = [[ThirdLoginObject alloc]init];
    }
    return _thirdLogin;
}



@end
