//
//  XiHaoUserViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"

#import "XiHaoUserRequest.h"
#import "XiHaoUserModel.h"

@interface XiHaoUserViewModel : FatherViewModel

@property(nonatomic,strong) XiHaoUserRequest *request;
@property(nonatomic,strong) XiHaoUserModel *data;
@end
