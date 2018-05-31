//
//  VideoAutoPlay.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/6.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoAutoPlay : NSObject

+(void)setAutoPlay:(NSString *) autoplay;

//1  是wifi
//2  非wifi
+(NSString *)getAutoPlay;

@end
