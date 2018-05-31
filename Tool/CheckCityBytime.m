
//
//  CheckCityBytime.m
//  chechengwang
//
//  Created by 严琪 on 2017/11/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CheckCityBytime.h"
#import "Location.h"
#import "CustomAlertView.h"

#define Ktime @"time"

@implementation CheckCityBytime

-(void)setNearlyTime:(NSString *)nearlyTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存值(key值同名的时候会覆盖的)
    [defaults setObject:nearlyTime forKey:Ktime];
    //立即保存
    [defaults synchronize];
}


-(NSString *)getCurrentTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"YYYYMMddhhmm"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年-月-日  时：分：秒=====================",DateTime);
    return DateTime;
}

//取值
-(NSString *)getRecordTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *DateTime = [defaults objectForKey:Ktime];
    NSLog(@"%@============年-月-日  时：分：秒=====================",DateTime);
    return DateTime;
}

//YES需要展示 NO不需要展示 1为 分钟
-(bool)checkByTime:(NSInteger) compareValue{
    
    if (![[self getRecordTime] isNotEmpty]) {
        [self setNearlyTime:[self getCurrentTime]];
        return NO;
    }
    
    if ([self compareTimebyRecordTime:[self getRecordTime] andSecondTime:[self getCurrentTime] compareData:compareValue]) {
//        [self setNearlyTime:[self getCurrentTime]];

        return YES;
    }
    return NO;
}

-(bool)compareTimebyRecordTime:(NSString *)recordTime andSecondTime:(NSString *)currentTime compareData:(NSInteger) compare{
     //先比较year
    if ([[recordTime substringToIndex:@"yyyymmdd".length] intValue]!= [[currentTime substringToIndex:@"yyyymmdd".length] intValue]) {
        return YES;
    }
    
    //在比较小时time
    if ([[currentTime substringFromIndex:@"yyyymmdd".length] intValue]-[[recordTime substringFromIndex:@"yyyymmdd".length] intValue]>compare) {
        return YES;
    }
    
    
    
    return NO;
}



@end
