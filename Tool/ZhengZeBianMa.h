//
//  ZhengZeBianMa.h
//  CarAssistantsTest
//
//  Created by WSWY on 15/6/2.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhengZeBianMa : NSObject
-(BOOL)checkPhoneNumInputWithStr:(NSString *)number;
-(BOOL)checkPasswordInputWithStr:(NSString *)str;
-(BOOL)checkUserNameInputWithStr:(NSString *)str;
+(BOOL)checkPhoneNumInputWithStr:(NSString *)number;
+(BOOL)checkPasswordInputWithStr:(NSString *)str;
+(BOOL)checkUserNameInputWithStr:(NSString *)str;
+(BOOL)checkNickNameWithStr:(NSString *)str;
+(BOOL)cheakEmail:(NSString*)email;
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
+ (BOOL)verifyIDCardNumber:(NSString *)value;
@end
