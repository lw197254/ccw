//
//  CarViKiViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/15.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CarViKiRequest.h"
#import "CarViKiModel.h"
@interface CarViKiViewModel : FatherViewModel
@property(nonatomic,strong)CarViKiRequest*request;

@property(nonatomic,strong)CarViKiModel *model;
@end
