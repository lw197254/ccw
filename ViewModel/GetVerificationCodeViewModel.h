//
//  GetVerificationCodeViewModel.h
//  TMC_convenientTravel
//
//  Created by Mr.Yan on 16/5/21.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "GetVerificationCodeRequest.h"
#import "ForgetPasswordRequest.h"
#import "CheckcodeRequest.h"
@interface GetVerificationCodeViewModel : FatherViewModel
@property(nonatomic,strong)GetVerificationCodeRequest *codeRequest;
@property(nonatomic,strong)ForgetPasswordRequest *passwordRequest;
@property(nonatomic,strong)CheckcodeRequest *checkCodeRequest;
@end
