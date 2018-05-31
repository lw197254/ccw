//
//  MyUMShare.h
//  chechengwang
//
//  Created by 严琪 on 17/1/16.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUMShare : NSObject
+(void)showShareInView:(UIView*)view title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl;
+(void)showSharePictureInView:(UIView*)view title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl;

//无ui分享
+(void)shareWithSSDKPlatform:(SSDKPlatformType)platformType title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl;

+(void)showSharePictureWithSSDKPlatform:(SSDKPlatformType)platformType title:(NSString*)title conent:(NSString*)content artUrl:(NSString*)artUrl  picUrl:(NSString*)picUrl;
@end
