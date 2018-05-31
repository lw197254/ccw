//
//  VideoAutoPlay.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/6.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoAutoPlay.h"

@implementation VideoAutoPlay
+(void)setAutoPlay:(NSString *) autoplay{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setValue:autoplay forKey:@"isautoplay"];
    // 3.立刻同步
    [results synchronize];
    
}
+(NSString *)getAutoPlay{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results valueForKey:@"isautoplay"];
}


@end
