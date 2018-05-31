//
//  CarDeptViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CarDeptRequest.h"
#import "CarDeptModel.h"

@interface CarDeptViewModel : FatherViewModel
@property(nonatomic,strong)CarDeptRequest *request;
@property(nonatomic,strong)CarDeptModel *data;

@end
