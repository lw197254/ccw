//
//  XiHaoClickObject.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiHaoClickObject : NSObject
+(void)addname:(NSString *)name;
+(NSString *)getnames;
+(void)deletename:(NSString *)name;
+(void)deletAll;
@end
