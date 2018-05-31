//
//  HomeMenuViewModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "HomeMenuModel.h"
#import "HomeMenuRequest.h"
#import "LaunchSreenRequest.h"
@interface HomeMenuViewModel : FatherViewModel

@property(nonatomic,strong)HomeMenuRequest *request;
@property(nonatomic,strong)HomeMenuModel *data;
@property(nonatomic,strong)LaunchSreenRequest *launchSreenRequest;
@end
