//
//  UserCollectionDeleteViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserCollectionDeleteRequest.h"

@interface UserCollectionDeleteViewModel : FatherViewModel
@property(nonatomic,strong)UserCollectionDeleteRequest *request;
@property(nonatomic,strong)NSString *msg;

//处理的数据
@property(nonatomic,strong)NSObject *model;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,copy)NSString *ids;
@end
