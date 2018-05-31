//
//  SaveFlow.m
//  chechengwang
//
//  Created by 严琪 on 17/2/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SaveFlow.h"

@implementation SaveFlow


+(void)setFlowSign:(bool) sign{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    [results setBool:sign forKey:@"flowkey"];
    // 3.立刻同步
    [results synchronize];
}

+(bool)getFlowSign{
    NSUserDefaults *results = [NSUserDefaults standardUserDefaults];
    return [results boolForKey:@"flowkey"];
}

@end
