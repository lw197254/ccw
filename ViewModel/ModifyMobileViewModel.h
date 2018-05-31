//
//  ModifyMobileViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CheckMobileRequest.h"
#import "ModifyMobileRequest.h"
#import "GetVerificationCodeRequest.h"
@interface ModifyMobileViewModel : FatherViewModel
@property(nonatomic,strong)CheckMobileRequest*checkMobileRequest;
@property(nonatomic,strong)GetVerificationCodeRequest*codeRequest;
@property(nonatomic,strong)ModifyMobileRequest*request;
@end
