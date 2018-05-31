//
//  HomeSecondViewModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "HomelistSecondRequest.h"
#import "HomeModel.h"
@interface HomeSecondViewModel : FatherViewModel
@property(nonatomic,strong)HomelistSecondRequest *request;
@property(nonatomic,strong)HomeModel *data;
@end
