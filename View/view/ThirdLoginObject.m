//
//  ThirdLogin.m
//  chechengwang
//
//  Created by 刘伟 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ThirdLoginObject.h"



#import "LoginViewModel.h"






#import <ShareSDK/ShareSDK.h>
#import <ShareSDKCoreService/ShareSDKCoreService.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "UserSujectDB.h"

//
//  LoginViewController.m
//  TMC_lutao
//
//  Created by 刘伟 on 16/3/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

@interface ThirdLoginObject()<WeiboSDKDelegate,TencentSessionDelegate>

#pragma 账号密码登录



@property(nonatomic,strong)LoginViewModel*viewModel;

@property(nonatomic,strong)UserSujectDB *userDB;
@end

@implementation ThirdLoginObject

-(UserSujectDB *)userDB{
    if (!_userDB) {
        NSLog(@"初始化 %@",self.class);
        _userDB = [[UserSujectDB alloc] init];
    }
    return _userDB;
}


-(void)confignormalLoginData{
    
   
    @weakify(self);
    
    [[RACObserve(self.viewModel.userInfoRequest,state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.userInfoRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          [[UserModel shareInstance] mergeFromDictionary:self.viewModel.userInfoRequest.output[@"data"] useKeyMapping:YES];
          [self loginSucess];
             }];
    
}
-(void)loginWithLoginDetailType:(ThirdLoginType)type{
    switch (type) {
      
        case ThirdLoginTypeQQ:
            [self QQLoginClicked:nil];
            break;
        case ThirdLoginTypeWeichat:
            [self weixinLoginClicked:nil];
            
            break;
        case ThirdLoginTypeSina:
            [self sinaLoginClicked:nil];
            break;
            
        default:
            break;
    }
}
-(void)loginSucess{
    
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
             if (self.loginSuccessDataBlock) {
                 //list数据返回了
                 NSLog(@"list数据返回");
                 self.loginSuccessDataBlock();
             }
         }
     }];
    
    
   
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
    
}







-(void)thirdLoginRAC{
    @weakify(self);
    [[RACObserve(self.viewModel.thirdLoginRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.thirdLoginRequest.succeed;
      }]
     subscribeNext:^(id x) {
         @strongify(self);
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
            [[DialogUtil sharedInstance]showDlg:[Tool currentViewController].view textOnly: @"登录失败"];
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
        [[DialogView sharedInstance]showDlg:[Tool currentViewController].view textOnly:@"网络或服务器故障"];
    }];
    
}
-(LoginViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [LoginViewModel SceneModel];
        _viewModel = [LoginViewModel SceneModel];
        [self confignormalLoginData];
        
        [self thirdLoginRAC];
    }
    return _viewModel;
}

@end


