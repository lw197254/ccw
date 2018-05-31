//
//  UserPushViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserPushCountRequest.h"


@interface UserPushViewModel : FatherViewModel
@property(nonatomic, strong)UserPushCountRequest *request;
@end
