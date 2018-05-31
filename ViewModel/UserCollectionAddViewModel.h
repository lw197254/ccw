//
//  UserCollectionAddRequest.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserCollectionAddRequest.h"

@interface UserCollectionAddViewModel : FatherViewModel
@property(nonatomic,strong)UserCollectionAddRequest *request;
@property(nonatomic,copy)NSString *msg;
@property(nonatomic,copy)NSString *subid;
//操作的数据
@property(nonatomic,strong)NSObject *model;
@property(nonatomic,copy)NSString *ids;
@end
