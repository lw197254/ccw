//
//  FindCarByGroupGetCarListByCarTypeViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "FindCarByGroupByCarTypeGetCarListModel.h"
#import "FindCarByGroupGetCarListByCarTypeRequest.h"

@interface FindCarByGroupGetCarListByCarTypeViewModel : FatherViewModel
@property(nonatomic,strong)FindCarByGroupByCarTypeGetCarListModel*model;
@property(nonatomic,strong)FindCarByGroupGetCarListByCarTypeRequest*request;

@end
