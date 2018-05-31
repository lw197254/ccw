//
//  getUserPushDynamicViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/31.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "CheckMyDynamic.h"

@interface GetUserPushDynamicViewModel : FatherViewModel
@property(nonatomic,strong)CheckMyDynamic *request;
@property(nonatomic,copy)NSString *count;
@end
