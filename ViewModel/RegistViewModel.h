//
//  RegistViewModel.h
//  12123
//
//  Created by 刘伟 on 2016/9/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "RegistRequest.h"
#import "GetVerificationCodeRequest.h"
#import "CheckMobileRequest.h"
#import "UserInfoRequest.h"
@interface RegistViewModel : FatherViewModel
@property(nonatomic,strong)RegistRequest*registRequest;
@property(nonatomic,strong)GetVerificationCodeRequest*codeRequest;
@property(nonatomic,strong)CheckMobileRequest*checkMobileRequest;
@property(nonatomic,strong)UserInfoRequest *userInfoRequest;
@end
