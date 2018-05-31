//
//  LoginViewController.h
//  TMC_lutao
//
//  Created by 刘伟 on 16/3/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

typedef void(^LoginSuccessBlock)(void);
typedef void(^LoginSuccessDataBlock)(void);
@interface LoginViewController : ParentViewController
@property (copy, nonatomic) LoginSuccessBlock loginSuccessBlock;
@property (copy, nonatomic) LoginSuccessDataBlock loginSuccessDataBlock;

-(void)loginSuccess:(LoginSuccessBlock)successBlock;


@end
