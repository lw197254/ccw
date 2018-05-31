//
//  ConditionSelectCarViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "ConditionSelectCarConfigRequest.h"
#import "ConditionSelectCarCountRequest.h"
#import "ConditionSelectCarResultListModel.h"
#import "ConditionSelectCarResultRequest.h"
@interface ConditionSelectCarViewModel : FatherViewModel
@property(nonatomic,strong)NSArray*data;
@property(nonatomic,strong)ConditionSelectCarConfigRequest*configRequest;
@property(nonatomic,strong)ConditionSelectCarCountRequest*countRequest;

@property(nonatomic,strong)ConditionSelectCarResultRequest*resultRequest;
///搜索结果
@property(nonatomic,strong)ConditionSelectCarResultListModel*model;
@property(nonatomic,strong)NSMutableArray<ConditonSelectCarResultModel*>* showList;
@end
