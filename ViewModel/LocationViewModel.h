//
//  LocationViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/2.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "GetCityIdRequest.h"
@interface LocationViewModel : FatherViewModel
@property(nonatomic,strong)GetCityIdRequest*request;
@property(nonatomic,copy)NSString*cityId;
@end
