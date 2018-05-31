//
//  CobubTongJi.h
//  chechengwang
//
//  Created by 严琪 on 2017/7/10.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CobubTongJi : NSObject
///发送客户信息
-(void)postClientData;
///发送历史信息
-(void)postActivityData;
///关闭循环发送
-(void)cancelPostInterval;
@end
