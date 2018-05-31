//
//  NotificationTool.m
//  chechengwang
//
//  Created by 严琪 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NotificationTool.h"

#import "PopTimeModel.h"

#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)


@implementation NotificationTool
-(bool)checkIfNotification{
    bool obj = [[NSUserDefaults standardUserDefaults] boolForKey:@"NotificationTool"];
    if(!obj){
        NSLog(@"设置NotificationTool");
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationTool" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }

    
    if (IOS8) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            return  NO;
        }
    }else{ // ios7 一下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            return  NO;
        }  
    }
    return YES;
}


-(bool)needShow{
    if ([PopTimeModel findAll].count) {
        PopTimeModel *model = [PopTimeModel findAll][0];
        return [self compareOneDay:model.currentTime withAnotherDay:[NSDate date]];
    }
    return YES;
}

-(bool)compareOneDay:(NSString *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateA toDate:dateB options:0];
    
    if (dateCom.day>=7) {
        return YES;
    }else{
        return NO;
    }
    
//    NSComparisonResult result = [dateA compare:dateB];
//    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
//    if (result == NSOrderedDescending) {
//        //NSLog(@"Date1  is in the future");
//        return 1;
//    }
//    else if (result == NSOrderedAscending){
//        //NSLog(@"Date1 is in the past");
//        return -1;
//    }
//    //NSLog(@"Both dates are the same");
//    return 0;
    
}
@end
