//
//  SharePlatform.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "SharePlatform.h"
#import "ShareModel.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>

@implementation SharePlatform


+(NSArray<ShareModel *> *)getSharePlatforms{
    //第二版本
    NSMutableArray *share = [NSMutableArray arrayWithCapacity:4];
    
    if([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]){
        ShareModel *share1 = [[ShareModel alloc] init];
        share1.name = @"微信";
        share1.imageName = @"ic_wechat";
        share1.tag = @"1";
        [share addObject:share1];
        
        ShareModel *share2 = [[ShareModel alloc] init];
        share2.name = @"朋友圈";
        share2.imageName = @"ic_pengyouquan";
        share2.tag = @"1";
        [share addObject:share2];
    }
    
    if([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]){
        ShareModel *share3 = [[ShareModel alloc] init];
        share3.name = @"QQ好友";
        share3.imageName = @"ic_qq";
        share3.tag = @"1";
        [share addObject:share3];
        
        ShareModel *share4 = [[ShareModel alloc] init];
        share4.name = @"QQ空间";
        share4.imageName = @"ic_qqk";
        share4.tag = @"1";
        [share addObject:share4];
    }
    return [share copy];
}

@end
