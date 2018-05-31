//
//  Tool.m
//  CarAssistantsTest
//
//  Created by 刘伟 on 15/5/11.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//
#define CC_MD5_DIGEST_LENGTH 16
#import "Tool.h"
#import "UIImageView+AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "CommonFunc.h"
#import "NSData+Encryption.h"
#import "NSString+AES128.h"
#import <ImageIO/ImageIO.h>

#import "UICKeyChainStore.h"
#import <AdSupport/AdSupport.h>

@implementation Tool
+(UIButton*)createButtonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor frame:(CGRect)frame target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FontOfSize(17);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    button.tag = tag;
    return button;
}
+(UILabel*)createLabelWithTitle:(NSString*)text frame:(CGRect)frame textColor:(UIColor*)textColor tag:(NSInteger)tag{
    UILabel*label = [[UILabel alloc]init];
    label.text = text;
    label.tag = tag;
    label.frame = frame;
    label.font = FontOfSize(15);

    label.textColor = textColor;
    return label;
}
+(UILabel*)createLabelWhichTextFontIsthreteenWithTitie:(NSString*)title{
   UILabel*label= [Tool createLabelWithTitle:title];
    label.font = FontOfSize(15);
    return label;
}
+(UIButton*)createButtonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action backgroundImage:(UIImage*)backgroundImage highLightedBackgroundImage:(UIImage*)highLightedBackgroundImage{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highLightedBackgroundImage forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = FontOfSize(17);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectZero;
    return button;
   
}
+(UIButton*)createButtonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action {
  UIButton*button = [Tool createButtonWithTitle:title titleColor:titleColor frame:CGRectZero target:target action:action tag:0];
    return button;
}
+(UIButton*)createButtonWithImage:(UIImage*)image target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = FontOfSize(17);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectZero;
    button.tag = tag;
    button.layer.shadowColor = (__bridge CGColorRef)([UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]);
    return button;

}
+(UIView*)createLine{
    UIView*view = [[UIView alloc]init];
    view.backgroundColor = BlackColorE3E3E3;
    return view;
}
+(UILabel*)createLineLabel{
    UILabel*label = [Tool createLabelWithTitle:@"" frame:CGRectMake(0, 0, kwidth, 0.1) textColor:nil tag:0];
    label.backgroundColor = [UIColor colorWithRed:206.0/255 green:208.0/255 blue:210.0/255 alpha:1];
    return label;
}
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
+(UILabel*)createLabelWhichTextFontIsTwelf{
    UILabel*label = [Tool createLabelWithTitle:@""];
    label.font = FontOfSize(14);
    return label;
}
+(UILabel*)createLabelWithTitle:(NSString *)text textColor:(UIColor *)textColor tag:(NSInteger)tag{
    UILabel*label = [[UILabel alloc]init];
    label.text = text;
    label.tag = tag;
//    label.frame = CGRectMake(0, 0, 60, 30);
    label.font = FontOfSize(15);
    
    label.textColor = textColor;
//[label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//     [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return label;
}
+(UILabel*)createLabelWithTitle:(NSString *)text{
    UILabel*label = [Tool createLabelWithTitle:text textColor:[UIColor blackColor] tag:0];
    return label;
}//+(AttributedLabel*)createAttributeLabelWithTitle:(NSString *)text frame:(CGRect)frame textColor:(UIColor *)textColor tag:(NSInteger)tag{
//    AttributedLabel*label = [[AttributedLabel alloc]init];
//    label.text = text;
//    label.tag = tag;
//    label.frame = frame;
//   
//    //label.textColor = textColor;
//    return label;
//
//}
#pragma mark -返回距离今天days天数的星期数
+(NSString*)weekdayStringFromToday:(NSInteger)days{
    NSString*weekString;
   NSString*week =  [Tool weekdayStringFromDate:[NSDate date]];
    NSArray *weekdays = [NSArray arrayWithObjects:@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    for (NSInteger i = 0; i<weekdays.count; i++) {
        NSString*str = weekdays[i];
        if ([week isEqualToString: str]) {
            weekString =weekdays[(i+days)%7];
            return weekString;
        }
    }
    return @"未找到";
}
//+(NSString*)runTimeStringFromRuntimeIntergal:(NSInteger)time{
//    
//    NSInteger hour=0;
//    NSInteger min =0;
//    min = time/60;
////    min = time;
//    hour = min/60;
//    min = min-hour*60;
//    if (hour!=0) {
//        return [NSString stringWithFormat:@"%ld小时%ld分",(long)hour,(long)min];
//    }else{
//        return [NSString stringWithFormat:@"%ld分钟",(long)min];
//    }
//    
//}
+(NSString*)trainImageColorWithTrainNumber:(NSString*)trainNumber{
    if (trainNumber.length >=1) {
        NSString*head = [trainNumber substringToIndex:1];
        if ([head isEqual:@"G"]) {
            return @"蓝";
        }else if ([head isEqual:@"D"]){
            return @"绿";
        }else if ([head isEqual:@"T"]){
            return @"黄";
        }else{
            return @"红";
        }
    }else{
        return @"红";
    }
}

+(NSString*)md5:(NSString*)str
{
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
    
}
+(NSString*)base64StringFromText:(NSString *)text{
   
    return [CommonFunc base64StringFromText:text];
}
+(NSString*)textFromBase64String:(NSString *)base64{
     NSString*str =[CommonFunc textFromBase64String:base64];
    return str;
//    NSArray*strarray =[str componentsSeparatedByString:APIkey];
//    
//        NSString*text = [strarray lastObject];
//    if (text!=nil) {
//        
//    
//        return text;
//    }else{
//    
//    return @"";
//    }
}
+(NSString*)minDateStringWithLongDateString:(NSString*)str{
    if(str.length==@"yyyy-MM-dd HH:mm:ss".length){
    
    NSDate*date = [NSDate dateWithString:str format:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    NSString*minStr = [dateFormatter stringFromDate:date];
    if (minStr==nil) {
        return @"00:00";
    }
    return minStr;
    }else if (str.length==@"yyyy-MM-dd HH:mm".length){
        NSDate*date = [NSDate dateWithString:str format:@"yyyy-MM-dd HH:mm"];
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"HH:mm";
        NSString*minStr = [dateFormatter stringFromDate:date];
        if (minStr==nil) {
            return @"00:00";
        }
        return minStr;
    }else if (str.length==@"HH:mm".length){
        return str;
    }else{
         return @"00:00";
    }
}

+(NSString*)yearMonthDayStringWithLongDateString:(NSString *)str{
    NSString*yearMonthDayStr = [str substringToIndex:@"yyyy-MM-dd".length ];
    if (yearMonthDayStr==nil) {
        return @"0000-00-00";
    }
    return yearMonthDayStr;
}


+(NSString*)statusFromStatusCode:(NSString *)statusCode{
    NSString*path = [[NSBundle mainBundle]pathForResource:@"ImageAndOrderStatus" ofType:@"plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (statusCode!=nil) {
        if (dict[statusCode]!=nil) {
            return dict[statusCode];
        }
    }
    
    return @"正在处理";
}

+(CGFloat)kheightRedio{
    
    if (kwidth==320&&kheight==480) {
        return 1;
    }else{
        return kheight/568;
    }
    
}
//+(CGFloat)height:(CGFloat)height{
//    return  height*kHeightRatio;
//}
//+(CGFloat)width:(CGFloat)width{
//    return width*kwidthRatio;
//}
+(CGFloat)kwidthRedio{
    
    
    if (kwidth==320&&kheight==480) {
        return 1;
    }else{
        return kwidth/320;
    }

}


//获取当前屏幕显示的viewcontroller
//+(UIViewController *)currentViewController
//{
//    UIViewController *result = nil;
//    
//    //    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    //    if (window.windowLevel != UIWindowLevelNormal)
//    //    {
//    //        NSArray *windows = [[UIApplication sharedApplication] windows];
//    //        for(UIWindow * tmpWin in windows)
//    //        {
//    //            if (tmpWin.windowLevel == UIWindowLevelNormal)
//    //            {
//    //                window = tmpWin;
//    //                break;
//    //            }
//    //        }
//    //    }
//    UIWindow*window = [[UIApplication sharedApplication].delegate window];
//    UIViewController*root = window.rootViewController;
//    if ([root isKindOfClass:[UITabBarController class]]){
//        UITabBarController*tab =(UITabBarController*) window.rootViewController;
//        UIViewController*navi = [tab selectedViewController];
//        if ([navi isKindOfClass:[UINavigationController class]]) {
//            UINavigationController*nav = (UINavigationController*)navi;
//            result = nav.visibleViewController;
//        }else{
//            result = navi;
//        }
//    }else{
//        result = root;
//    }
//    return result;
//
////    UIViewController *result = nil;
////    
////    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
////    if (window.windowLevel != UIWindowLevelNormal)
////    {
////        NSArray *windows = [[UIApplication sharedApplication] windows];
////        for(UIWindow * tmpWin in windows)
////        {
////            if (tmpWin.windowLevel == UIWindowLevelNormal)
////            {
////                window = tmpWin;
////                break;
////            }
////        }
////    }
////    
////    UIView *frontView = [[window subviews] objectAtIndex:0];
////    id nextResponder = [frontView nextResponder];
////    
////    if ([nextResponder isKindOfClass:[UIViewController class]])
////        result = nextResponder;
////    else
////        result = window.rootViewController;
////    
////    return result;
//}
+ (UIViewController*)currentViewController
{
   
    
    UIViewController* rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [Tool currentViewControllerFrom:rootViewController];
}


+(CustomNavigationController*)currentNavigationController
{
    UIViewController* currentViewController = self.currentViewController;
    return currentViewController.rt_navigationController;
}

+(UIViewController*)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[CustomNavigationController class]]) {
        CustomNavigationController* navigationController = (CustomNavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.rt_viewControllers.lastObject];
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

//+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController
//{
//    if ([viewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationController* navigationController = (UINavigationController *)viewController;
//        return [Tool currentViewControllerFrom:navigationController.viewControllers.lastObject];
//    } else if([viewController isKindOfClass:[UITabBarController class]]) {
//        UITabBarController* tabBarController = (UITabBarController *)viewController;
//        return [Tool currentViewControllerFrom:tabBarController.selectedViewController];
//    } else if(viewController.presentedViewController != nil) {
//        return [Tool currentViewControllerFrom:viewController.presentedViewController];
//    } else {
//        return viewController;
//    }
//}

+(NSString*)strTranformFromFloat:(float)number{
   
    NSInteger b = (NSInteger)(number*100);
    return  [Tool strTranformFromNSInteger:b];
}
+(NSString*)strTranformFromNSInteger:(NSInteger)number{
    
   
    NSString*str;
    if (number%100==0) {
        str = [NSString stringWithFormat:@"%ld",(long)number/100];
    }else if (number%10==0){
        str = [NSString stringWithFormat:@"%.1f",number*1.0/100];
    }else{
        str = [NSString stringWithFormat:@"%.2f",1.0*number/100];
    }
    return str;
}
+(NSString*)monthDayStringFromTimeInterval:(long)timeInterval{
    NSDate*date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM-dd";
    NSString*minStr = [dateFormatter stringFromDate:date];
    if (!minStr.isNotEmpty) {
        minStr=@"00-00";
    }
    return minStr;
}
+(NSString*)yearMonthDayStringFromTimeInterval:(long)timeInterval{
    NSDate*date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString*minStr = [dateFormatter stringFromDate:date];
    if (!minStr.isNotEmpty) {
        minStr=@"0000-00-00";
    }
    return minStr;
}
+(NSString*)minDateStringFromTimeInterval:(long)timeInterval{
    NSDate*date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    NSString*minStr = [dateFormatter stringFromDate:date];
    if (!minStr.isNotEmpty) {
        minStr=@"00:00";
    }
    return minStr;
}
+(NSInteger)daySinceDate:(long)departCTime toDate:(long)arrivalCTime{
    NSString*departDateString = [Tool yearMonthDayStringFromTimeInterval:departCTime];
    NSString*arrivalDateString = [Tool yearMonthDayStringFromTimeInterval:arrivalCTime];
    NSDate*departDate =[NSDate dateWithString: departDateString format:@"yyyy-MM-dd"];
    NSDate*arrivelDate =[NSDate dateWithString: arrivalDateString format:@"yyyy-MM-dd"];
   
    NSInteger departTimeInterfar =[arrivelDate timeIntervalSinceDate:departDate]/(3600*24);
    
    return departTimeInterfar;

}


+(NSString*)durationStringFromDuration:(NSInteger)duration{
    NSInteger min =  duration/60;
    NSInteger hour = min/60;
    NSInteger mi = (min-hour*60);
    NSString*durationString=@"";
    if (mi!=0) {
        durationString =[NSString stringWithFormat:@"%ld分",(long)mi];
    }
    if (hour!=0) {
        durationString = [NSString stringWithFormat:@"%ld小时%@",(long)hour,durationString];
    }
       return durationString;
}
+(NSString*)whichDaySinceDate:(long)departCTime toDate:(long)arrivalCTime{
    NSInteger day = [Tool daySinceDate:departCTime toDate:arrivalCTime];
    if (day>0) {
        return [NSString stringWithFormat:@"+%ld天",day];
    }else{
        return @"";
    }
}
+(NSString *)changeNumberFormat:(NSInteger)num
{
    if (num == 0) {
        return @"0";
    }
    int count = 0;
    NSInteger a= num;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithFormat:@"%ld",num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
//+(void)showOrderDetailVC{
//    NSString*className;
//    static NSDictionary*dict ;
//    dict = [NSDictionary dictionaryWithObjectsAndKeys:
//            NSStringFromClass([AirplaneOrderDetailViewController class]),@"V001",
//            NSStringFromClass([TrainOrderDetailViewController class]),@"V002",
//            NSStringFromClass([GrogShopOrderDetailViewController class]),@"V003",
//            NSStringFromClass([CarOrderDetailViewController class]),@"V004", nil];
//    className =[dict valueForKey:[UmPushModel shareInstance].behaviorType ];
//    if([UmPushModel shareInstance].orderID.isNotEmpty&&className){
//        
//        Class class = NSClassFromString(className);
//       
//        UIViewController*VC = [Tool currentViewController];
//        if ([VC isKindOfClass:class]) {
//            OrderDetailViewController*VC = (OrderDetailViewController*)[Tool currentViewController];
//            VC.orderId = [UmPushModel shareInstance].orderID;
//            [VC refreshViewController];
//            [[UmPushModel shareInstance] removeUserInfo];
//        }else{
//            OrderDetailViewController*orderDetail = [[class alloc]init];
//            orderDetail.orderId = [UmPushModel shareInstance].orderID;
//            
//            [VC.navigationController pushViewController:orderDetail animated:YES];
//            [[UmPushModel shareInstance]removeUserInfo];
//        }
//        
//        
////        if ([className isEqualToString:NSStringFromClass([AirplaneOrderDetailViewController class])]) {
////            if ([VC isKindOfClass:[AirplaneOrderDetailViewController class]]) {
////                AirplaneOrderDetailViewController*VC = (AirplaneOrderDetailViewController*)[Tool currentViewController];
////                VC.orderId = [UmPushModel shareInstance].orderID;
////                [VC refreshViewController];
////                [[UmPushModel shareInstance] removeUserInfo];
////            }else{
////                OrderDetailViewController*orderDetail = [[AirplaneOrderDetailViewController alloc]init];
////                orderDetail.orderId = [UmPushModel shareInstance].orderID;
////                
////                [VC.navigationController pushViewController:orderDetail animated:YES];
////                [[UmPushModel shareInstance]removeUserInfo];
////            }
////            
////        }
//        
//        
//        
//        
//    }
//    
//}


//dateStr格式@"2016/6/23 11:01:34"
+ (BOOL)compareCurrentDateWithStr:(NSString *)dateStr
{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
     NSDate * date = [df dateFromString:dateStr];
    
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSDate * today = [NSDate date];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString * currentDate = [df stringFromDate:today];
    NSString *timeStr = [df stringFromDate:date];

    if ([timeStr integerValue] < [currentDate integerValue])
        return YES;
    else
        return NO;

}
//dateStr格式@"11:01"
+ (BOOL)compareCurrentDateFromStr:(NSString *)dateStr
{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"HH:mm"];
    NSDate * date = [df dateFromString:dateStr];
    
    [df setDateFormat:@"HHmm"];
    NSDate * today = [NSDate date];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString * currentDate = [df stringFromDate:today];
    NSString *timeStr = [df stringFromDate:date];
    
    if ([timeStr integerValue] < [currentDate integerValue])
        return YES;
    else
        return NO;
    
}
+ (NSString *)strTranformFromNSString:(NSString *)dateStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate * date = [df dateFromString:dateStr];
    
    [df setDateFormat:@"yyyyMMddHHmmss"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
    
    [df2 setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [df2 stringFromDate:date];

}

+ (NSString *)strTranformWithNSString:(NSString *)dateStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy/MM/dd"];
    NSDate * date = [df dateFromString:dateStr];
    
    [df setDateFormat:@"yyyyMMdd"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
    
    [df2 setDateFormat:@"MM月dd日"];
    return [df2 stringFromDate:date];
    
}
+(NSString*)urlHeader{
    
//    NSString*sessonid=@"";
    NSString*wz_Screen = [NSString stringWithFormat:@"%ld*%ld",(long)kwidth,(long)kheight];
    NSString*wz_Imei =  [[NSUserDefaults standardUserDefaults]objectForKey :@"wz_Imei"];
    if (!wz_Imei.isNotEmpty) {
        NSDate*date = [NSDate now];
        
        NSInteger i = arc4random()%10000 +1;
        NSString*dateString = [date stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        dateString  = [dateString stringByAppendingFormat:@"%5ld",(long)i];
        wz_Imei = [Tool md5:dateString];
        [[NSUserDefaults standardUserDefaults]setObject:wz_Imei forKey:@"wz_Imei"];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
    NSString*wz_Model = [[UIDevice currentDevice] model];
     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    //deviceID
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"chechengwang_ios"];
    
    NSString *deviceId = keychain[@"key"];
    if (deviceId==nil) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        keychain[@"key"] = uuid;
        deviceId = uuid;
    }
    NSLog(@"~~~~~~~~~~%@",deviceId);
    
    //idfa
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
//     NSDictionary*dict = [NSDictionary dictionaryWithObjectsAndKeys:@"gzip",@"Wz-Encode",@"1",@"Wz-type",sessonid,@"Wz-Sid",wz_Imei,@"Wz-Imei",APP_VERSION,@"Wz-Version", wz_Screen,@"Wz-Screen",wz_Model,@"Wz-Model",@"appstore",@"Wz-Channel",nil];
   NSDictionary*dict1 = @{@"Wz-OsVersionCode":@"21",@"Wz-Mac":@"20:82:c0:24:51:d6",@"Wz-Imei":@"",@"Wz-Model":wz_Model,@"Wz-Type":@"1",@"Wz-Brand":[[UIDevice currentDevice] localizedModel],@"Wz-Sid":@"",@"Wz-Screen":wz_Screen,@"Wz-OsVersionName":[[UIDevice currentDevice] systemVersion],@"Wz-Channel":@"appstore",@"Wz-Version":version,@"Wz-deviceId":deviceId,@"Wz-idfa":idfa};
  NSString*wz_Head = [NSString jsonStringWithDictionary:dict1 ];
    NSString*str  = [NSString AES128Encrypt:wz_Head key:APIkey];
    str =  [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str=  [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
    
//    NSData*data = [wz_Head dataUsingEncoding:NSUTF8StringEncoding ];
//   NSData*newData =  [data AES256EncryptWithKey:APIkey];
//   NSString*str =  [newData newStringInBase64FromData];
    
//    return str;
}
+ (NSArray *)imagesWithGif:(NSString *)gifNameInBoundle {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifNameInBoundle withExtension:@"gif"];
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
    }
    return frames;
}
+(UIFont*)fontOfSize:(CGFloat)size{
  UIFont*font=  [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}
+(UIFont*)fontBlackOfSize:(CGFloat)size{
    UIFont*font=  [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    if (!font) {
        font = [UIFont fontWithName:@"Helvetica-Bold" size:size];
    }
    return font;
}
+(CGFloat)safeAreaBottom{
   
        if (@available(iOS 11.0, *)) {
            return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        } else {
            return 0;
        }
   
}

+(NSString *)clickfilepath{
    NSArray *pathArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strPath=[pathArr lastObject];
    NSString *strFinalPath=[NSString stringWithFormat:@"%@/clickfile.txt",strPath];
    return strFinalPath;
}
@end
