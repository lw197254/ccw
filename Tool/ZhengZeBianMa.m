//
//  ZhengZeBianMa.m
//  CarAssistantsTest
//
//  Created by WSWY on 15/6/2.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import "ZhengZeBianMa.h"

@implementation ZhengZeBianMa
-(BOOL)checkPhoneNumInputWithStr:(NSString *)number
{
    NSString * MOBILE = @"^1(3[0-9]|7[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:number];
    BOOL res2 = [regextestcm evaluateWithObject:number];
    BOOL res3 = [regextestcu evaluateWithObject:number];
    BOOL res4 = [regextestct evaluateWithObject:number];
    
    if (res1 || res2 || res3 || res4 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
+(BOOL)checkNickNameWithStr:(NSString *)str{
   //NSString *      regex= @"(^[\u4e00-\u9fa5_a-zA-Z0-9]+$)";
    NSString *      regex = @"(^[\u4e00-\u9fa5A-Za-z0-9]{1,16}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:str];
   
}
-(BOOL)checkUserNameInputWithStr:(NSString *)str{
    NSString *      regex = @"(^[A-Za-z0-9]{4,16}$)";
        NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
        return [pred evaluateWithObject:str];
}
//- (BOOL)isUserName
//{
//    NSString *      regex = @"(^[A-Za-z0-9]{3,20}$)";
//    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    return [pred evaluateWithObject:self];
//}
//是否是密码
-(BOOL)checkPasswordInputWithStr:(NSString *)str{
    NSString *      regex = @"(^[A-Za-z0-9]{6,12}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:str];
}
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
+(BOOL)checkPhoneNumInputWithStr:(NSString *)number{
    ZhengZeBianMa *z = [[ZhengZeBianMa alloc]init];
    return[z checkPhoneNumInputWithStr:number];
}
+(BOOL)checkPasswordInputWithStr:(NSString *)str{
    ZhengZeBianMa *z = [[ZhengZeBianMa alloc]init];
    return[z checkPasswordInputWithStr:str];
}
+(BOOL)cheakEmail:(NSString*)email{
    NSString *emailRegex = @"\\w*@\\w*\\.\\w*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)checkUserNameInputWithStr:(NSString *)str{
    ZhengZeBianMa *z = [[ZhengZeBianMa alloc]init];
    return[z checkUserNameInputWithStr:str];
}
 + (BOOL)verifyIDCardNumber:(NSString *)value
 {
     value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     if ([value length] != 18) {
          return NO;
       }
     NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
      NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
     NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
      NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
      NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
      NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
      NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
 
        NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
     if (![regexTest evaluateWithObject:value]) {
               return NO;
             }
     
     
     int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
                + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
                 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
               + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
                + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
                + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
               + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
                + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
               + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
       NSInteger remainder = summary % 11;
        NSString *checkBit = @"";
      NSString *checkString = @"10X98765432";
        checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
       return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
  }
@end
