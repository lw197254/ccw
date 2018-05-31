//
//  CompanyInfoViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CompanyInfoModel.h"
#import "CompanyInfoRequest.h"
@interface CompanyInfoViewModel : FatherViewModel
@property(nonatomic,strong)CompanyInfoRequest*request;

@property(nonatomic,strong)CompanyInfoModel*model;
@end
