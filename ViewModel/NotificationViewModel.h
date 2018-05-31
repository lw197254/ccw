//
//  NotificationViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"

#import "NotificationModel.h"
#import "NotificationRequest.h"

@interface NotificationViewModel : FatherViewModel
@property(nonatomic,strong)NotificationRequest *request;
@property(nonatomic,strong)NotificationModel *data;
@end
