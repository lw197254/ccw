//
//  ShadowLoginViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"
#import "ThirdLoginObject.h"


typedef void(^LoginSuccessBlock)(void);
typedef void(^LoginSuccessDataBlock)(void);

@protocol ShadowLoginViewControllerDelegate

@optional
//切换view
-(void)changeView:(NSString *)viewName;
//登录成功
-(void)loginSucess;
//忘记密码
-(void)forgetPassword:(NSString *)mobil;

@end

@interface ShadowLoginViewController : ParentViewController

@property (copy, nonatomic) LoginSuccessBlock loginSuccessBlock;
@property (copy, nonatomic) LoginSuccessDataBlock loginSuccessDataBlock;

-(void)loginSuccess:(LoginSuccessBlock)successBlock;
@end
