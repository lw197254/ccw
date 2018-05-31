//
//  UMShare.h
//  12123
//
//  Created by 刘伟 on 2016/10/12.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
@interface UMShare : NSObject
//资讯详情页具体平台分享
+(void)shareWithString:(NSString*)title content:(NSString*)content shareurl:(NSString*)url image:(id)image shareType:(ShareType)shareType;
///资讯详情页分享
+(void)shareWithString:(NSString*)title content:(NSString*)content shareurl:(NSString*)url image:(id)image;
///直接推荐分享
+(void)shareShow;
@end
