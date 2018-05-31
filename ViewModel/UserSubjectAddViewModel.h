//
//  UserSubjectAddViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserSubjectAddRequest.h"

@class  SubjectUserModel;

@interface UserSubjectAddViewModel : FatherViewModel

@property(nonatomic,strong)UserSubjectAddRequest *request;
@property(nonatomic,strong)NSString *msg;
@property(nonatomic,strong)NSString *subid;

@property(nonatomic,copy)SubjectUserModel *model;

@end
