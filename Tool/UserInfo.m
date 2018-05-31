//
//  UserInfo.m
//  chechengwang
//
//  Created by 严琪 on 17/3/24.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//
//  保存用户询价信息
#import "UserInfo.h"

@implementation UserInfo

+(void)setUserName:(NSString *) username{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setObject:username forKey:@"username"];
    // 3.立刻同步
    [results synchronize];
}


+(NSString *)getUserName{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results stringForKey:@"username"];
}


+(void)setUserPhone:(NSString *) userphone{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setObject:userphone forKey:@"userphone"];
    // 3.立刻同步
    [results synchronize];
}


+(NSString *)getUserPhone{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results stringForKey:@"userphone"];
}



@end
