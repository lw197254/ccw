//
//  NotificationTool.h
//  chechengwang
//
//  Created by 严琪 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationTool : NSObject

//返回no 说明关闭了通知
//返回yes 说明开启了通知
-(bool)checkIfNotification;

-(bool)needShow;
@end
