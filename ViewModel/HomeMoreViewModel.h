//
//  HomeMoreViewModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "HomeModel.h"
#import "HomelistMoreRequest.h"

@interface HomeMoreViewModel : FatherViewModel
@property(nonatomic,strong)HomelistMoreRequest *request;
@property(nonatomic,strong)HomeModel *data;
@end 

