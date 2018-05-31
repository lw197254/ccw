//
//  PublicPraiseCarsViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "KouBeiCarsBaseModel.h"
#import "PublicPraiseCarsRequest.h"

@interface PublicPraiseCarsViewModel : FatherViewModel

@property(nonatomic,strong)PublicPraiseCarsRequest *request;
@property(nonatomic,strong)KouBeiCarsBaseModel *data;

@end
