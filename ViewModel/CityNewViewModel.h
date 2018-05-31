//
//  CityNewViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/15.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CityNewRequest.h"
#import "ProvinceListNewModel.h"
@interface CityNewViewModel : FatherViewModel
@property(nonatomic,strong)CityNewRequest *request;
@property(nonatomic,strong)ProvinceListNewModel *model;
@end
