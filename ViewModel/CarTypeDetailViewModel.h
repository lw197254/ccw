//
//  CarTypeDetailViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CarTypeRequest.h"
#import "CarTypeDetailModel.h"
@interface CarTypeDetailViewModel : FatherViewModel
@property(nonatomic,strong)CarTypeRequest*request;
@property(nonatomic,strong)CarTypeDetailModel*model;
@end
