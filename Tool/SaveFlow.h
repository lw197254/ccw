//
//  SaveFlow.h
//  chechengwang
//
//  Created by 严琪 on 17/2/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//
////这边是节省流量使用的公共方法
#import <Foundation/Foundation.h>

@interface SaveFlow : NSObject
+(void)setFlowSign:(bool) sign;
+(bool)getFlowSign;
@end
