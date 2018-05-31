//
//  UserSubjectiListViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"

#import "UserSubjectRequest.h"
#import "SubjectUserList.h"
#import "SubjectUserModel.h"

#import "SubjectAuthorModel.h"

@interface UserSubjectListViewModel : FatherViewModel

@property(nonatomic,strong)UserSubjectRequest *request;
@property(nonatomic,strong)SubjectUserList *data;

@end
