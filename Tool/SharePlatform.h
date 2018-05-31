//
//  SharePlatform.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareModel;

@interface SharePlatform : NSObject
+(NSArray<ShareModel *> *)getSharePlatforms;
@end
