//
//  UserInfo.h
//  chechengwang
//
//  Created by 严琪 on 17/3/24.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+(void)setUserName:(NSString *) username;
+(NSString *)getUserName;

+(void)setUserPhone:(NSString *) userphone;
+(NSString *)getUserPhone;

@end
