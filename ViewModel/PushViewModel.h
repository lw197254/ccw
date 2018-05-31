//
//  PushViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "PushLogReqeust.h"
#import "PushUpdateDeviceRequest.h"
@interface PushViewModel : FatherViewModel
@property(nonatomic,strong)PushLogReqeust *pushLogReqeust;
@property(nonatomic,strong)PushUpdateDeviceRequest *pushUpdateDeviceRequest;
@end
