//
//  BrandIntroduceViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "BrandIntroduceRequest.h"
#import "BrandIntroduceModel.h"
@interface BrandIntroduceViewModel : FatherViewModel
@property(nonatomic,strong)BrandIntroduceRequest*request;

@property(nonatomic,strong)BrandIntroduceModel*model;
@end
