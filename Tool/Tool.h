//
//  Tool.h
//  CarAssistantsTest
//
//  Created by 刘伟 on 15/5/11.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class CustomNavigationController;
//#import "AttributedLabel.h"

@interface Tool : NSObject
+(UIButton*)createButtonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action;
+(UILabel*)createLabelWithTitle:(NSString*)text frame:(CGRect)frame textColor:(UIColor*)textColor tag:(NSInteger)tag;
//+(UIButton*)createButtonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor  target:(id)target action:(SEL)action tag:(NSInteger)tag;
+(UIButton*)createButtonWithImage:(UIImage*)image target:(id)target action:(SEL)action tag:(NSInteger)tag;
+(UIButton*)createButtonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action backgroundImage:(UIImage*)backgroundImage highLightedBackgroundImage:(UIImage*)highLightedBackgroundImage;
+(UILabel*)createLabelWithTitle:(NSString *)text;
+(UILabel*)createLabelWhichTextFontIsTwelf;
+(UILabel*)createLabelWhichTextFontIsthreteenWithTitie:(NSString*)title;
+(UILabel*)createLineLabel;
+(UIView*)createLine;
+(UILabel*)createLabelWithTitle:(NSString*)text textColor:(UIColor*)textColor tag:(NSInteger)tag;
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate;
+(NSString*)weekdayStringFromToday:(NSInteger)days;
//+(AttributedLabel*)createAttributeLabelWithTitle:(NSString*)text frame:(CGRect)frame textColor:(UIColor*)textColor tag:(NSInteger)tag;
//+(NSString*)runTimeStringFromRuntimeIntergal:(NSInteger)time;

//+(NSString*)UrlBottom;
//+(NSString*)urlStringWithRefond:(NSString*)string;
+(NSString*)trainImageColorWithTrainNumber:(NSString*)trainNumber;
/******************************************************************************
函数名称 : + (NSString *)base64StringFromText:(NSString *)text
函数描述 : 将文本转换为base64格式字符串
输入参数 : (NSString *)text    文本
输出参数 : N/A
返回参数 : (NSString *)    base64格式字符串
备注信息 :
******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;
//时间戳转为时分
+(NSString*)minDateStringWithLongDateString:(NSString*)str;
//时间戳转为 年月日
+(NSString*)yearMonthDayStringWithLongDateString:(NSString*)str;
//statuscode 转为status值
+(NSString*)statusFromStatusCode:(NSString*)statusCode;

//+(CGFloat)height:(CGFloat)height;
//+(CGFloat)width:(CGFloat)width;

+(CGFloat)kwidthRedio;//宽度相对于5s的比例
+(CGFloat)kheightRedio;//高度相对应5s的比例
//+(NSString*)UrlOf12306Query:(NSString*)query;

//获取当前的viewcontroller
+(UIViewController*)currentViewController;
+(CustomNavigationController*)currentNavigationController;
//+(void)setConfigWithisCoupousShow:(BOOL)isShow UrlOf12306Query:(NSString *)query;
//+(BOOL)isCoupousShow;
//12306座位名称转座位代码



//+(NSString*)reqTime;
//+(NSString*)urlStringWithDict:(NSDictionary*)dict;
+(NSString*)md5:(NSString*)str;
+(NSString*)strTranformFromFloat:(float)number;
+(NSString*)strTranformFromNSInteger:(NSInteger)number;
+(NSString*)minDateStringFromTimeInterval:(long)timeInterval;
+(NSString*)monthDayStringFromTimeInterval:(long)timeInterval;
+(NSInteger)daySinceDate:(long)departCTime toDate:(long)arrivalCTime;
+(NSString*)yearMonthDayStringFromTimeInterval:(long)timeInterval;
//历时
+(NSString*)durationStringFromDuration:(NSInteger)duration;
+(NSString*)whichDaySinceDate:(long)departCTime toDate:(long)arrivalCTime;




///根据时间模型返回相隔天数

///如果比当前时间小返回YES   Str格式@"2016/6/23 11:01:34"
+ (BOOL)compareCurrentDateWithStr:(NSString *)dateStr;
///如果比当前时间小返回YES   Str格式@"11:01"
+ (BOOL)compareCurrentDateFromStr:(NSString *)dateStr;
///转化成 yyyy年MM月dd日 HH:mm 的字符串类型 Str格式@"2016/6/23 11:01:34"
+ (NSString *)strTranformFromNSString:(NSString *)dateStr;
///转化成 MM月dd日的字符串类型 Str格式@"2016/6/23"
+ (NSString *)strTranformWithNSString:(NSString *)dateStr;
+(NSString*)urlHeader;

+ (NSArray *)imagesWithGif:(NSString *)gifNameInBoundle;
///将数字加入逗号分隔
+(NSString *)changeNumberFormat:(NSInteger)num;
///字体
+(UIFont*)fontOfSize:(CGFloat)size;
+(UIFont*)fontBlackOfSize:(CGFloat)size;
+(CGFloat)safeAreaBottom;

+(NSString *)clickfilepath;
@end
