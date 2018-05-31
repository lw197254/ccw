//
//  SubscribeDetailViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "SubscribeDetailRequest.h"
#import "SubscribeDetailModel.h"

#import "DeliverModel.h"

@interface SubscribeDetailViewModel : FatherViewModel
@property(nonatomic,strong)SubscribeDetailRequest *request;
@property(nonatomic,strong)SubscribeDetailModel *model;
@property(nonatomic,strong)NSMutableArray<SubscribeDetailArticleModel*>*showList;

@property(nonatomic,strong)DeliverModel *deliverModel;
@end
