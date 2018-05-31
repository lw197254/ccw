//
//  ParameterViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "ParameterRequest.h"
#import "ParameterCarSeariesRequest.h"
@interface ParameterViewModel : FatherViewModel
@property(nonatomic,strong)ParameterRequest*request;
@property(nonatomic,strong)ParameterCarSeariesRequest*carSeariesRequest;
@property(nonatomic,strong)NSArray*mapArray;
@property(nonatomic,strong)NSArray*data;
@end
