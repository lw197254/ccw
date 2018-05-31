//
//  LoginViewModel.h
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/23.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"

#import "LoginRequest.h"

#import "UserInfoRequest.h"
#import "ThirdLoginRequest.h"

@interface LoginViewModel : FatherViewModel
@property(nonatomic,strong)LoginRequest*loginRequest;

@property(nonatomic,strong)ThirdLoginRequest*thirdLoginRequest;
@property(nonatomic,strong)UserInfoRequest *userInfoRequest;
@end
