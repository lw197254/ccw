//
//  ConditionSelectCarSeriesViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "FindCarByGroupByCarTypeGetCarListModel.h"
#import "ConditionSelectCarSeriesRequest.h"
@interface ConditionSelectCarSeriesViewModel : FatherViewModel

@property(nonatomic,strong)FindCarByGroupByCarTypeGetCarListModel*model;
@property(nonatomic,strong)ConditionSelectCarSeriesRequest*request;
@end
