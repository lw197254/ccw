//
//  JustOnceClickTool.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "JustOnceClickTool.h"

@implementation JustOnceClickTool

+(void)setRightClickTimes:(bool) clueid{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setBool:clueid forKey:@"homeClickRed"];
    // 3.立刻同步
    [results synchronize];
    
}

+(bool)geRightClickTimes{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results boolForKey:@"homeClickRed"];
}

@end
