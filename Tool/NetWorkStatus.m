//
//  NetWorkStatus.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/6.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NetWorkStatus.h"

@implementation NetWorkStatus

+(void)setIsWifi:(NSString *) wifi{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setValue:wifi forKey:@"iswifi"];
    // 3.立刻同步
    [results synchronize];
    
}

+(NSString *)getIsWifi{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results valueForKey:@"iswifi"];
}



@end
