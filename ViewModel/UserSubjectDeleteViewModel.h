//
//  UserSubjectDeleteViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserSubjectDeleteRequest.h"
@class SubjectUserModel;

@interface UserSubjectDeleteViewModel : FatherViewModel
@property(nonatomic,strong)UserSubjectDeleteRequest *request;
@property(nonatomic,strong)NSString *msg;

@property(nonatomic,copy)SubjectUserModel *model;
@end
