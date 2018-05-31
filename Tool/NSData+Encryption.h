//
//  NSData+Encryption.h
//  12123
//
//  Created by 刘伟 on 2016/9/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//







#import <Foundation/Foundation.h>



@class NSString;



@interface NSData (Encryption)


///加密
- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
/////追加64编码
- (NSString *)newStringInBase64FromData;            //追加64编码

+ (NSString*)base64encode:(NSString*)str;           //同上64编码



@end



//------------------------------------------------------------------------------------------------
//
//
//
//
//
//
//------------------------------------------------------------------------------------------------
//
//
//
//测试代码
//
//
//
//
//
//#import "Encryption.h"
//
//
//NSString *key = @"my password";
//
//NSString *secret = @"text to encrypt";
//
////加密
//
//NSData *plain = [secret dataUsingEncoding:NSUTF8StringEncoding];
//
//NSData *cipher = [plain AES256EncryptWithKey:key];
//
//NSLog(@"%@",[[cipher newStringInBase64FromData] autorelease]);
//
//printf("%s\n", [[cipher description] UTF8String]);
//
//NSLog(@"%@", [[[NSString alloc] initWithData:cipher encoding:NSUTF8StringEncoding] autorelease]);//打印出null,这是因为没有解密。
//
////解密
//
//plain = [cipher AES256DecryptWithKey:key];
//
//printf("%s\n", [[plain description] UTF8String]);
//
//NSLog(@"%@", [[[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding] autorelease]);
//
////打印出secret的内容,用密码解密过了。如果使用错误的密码，则打印null
