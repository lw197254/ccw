//
//  UserSelectedTool.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/15.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UserSelectedTool.h"


@implementation UserSelectedTool

static UserSelectedTool* _instance = nil;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

@end
