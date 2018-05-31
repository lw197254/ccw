//
//  XiHaoClickObject.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "XiHaoClickObject.h"


@interface XiHaoClickObject()

@end

@implementation XiHaoClickObject


+(void)addname:(NSString *)name{
    
    NSString * temp_names = [self getnames];
    
    NSString * temp_name;
    
    if ([temp_names isNotEmpty]) {
        temp_name = [NSString stringWithFormat:@"%@,%@",temp_names,name];
    }else{
        temp_name = [NSString stringWithFormat:@"%@",name];
    }
    
    NSLog(@"添加name %@",temp_name);
  
 
    NSError *error ;
    [temp_name writeToFile:tongjifilepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
}


+(void)deletAll{
    NSString *tempString = @"";
    NSError *error ;
    [tempString writeToFile:tongjifilepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
}

+(void)deletename:(NSString *)name{

    NSLog(@"删除name %@",name);
    NSString * temp_names = [self getnames];
    
    if ([temp_names isNotEmpty]) {
        __block NSMutableArray *arry = [NSMutableArray arrayWithCapacity:0];
         NSArray *temparray = [temp_names componentsSeparatedByString:@","];
        [arry addObjectsFromArray:temparray];
        [temparray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:name]) {
                [arry removeObject:obj];
                *stop = YES;
            }
        }];
        
        NSString *tempString = [arry componentsJoinedByString:@","];
        NSError *error ;
         [tempString writeToFile:tongjifilepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"%@", error.description);
        }
    }
  
}

+(NSString *)getnames{
 
    NSString *names = [[NSString alloc]initWithContentsOfFile:tongjifilepath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"names:%@",names);
    if ([names isNotEmpty]) {
        return names;
    }else{
         return @"";
    }
}


@end
