//
//  UIButton+Create.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UIButton+Create.h"
///添加创建button的方法
@implementation UIButton (Create)
+(UIButton*)buttonWithTitle:(NSString *)title titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action{
    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

//+(UIButton*)buttonWithImage:(ui) titleColor:(UIColor*)titleColor target:(id)target action:(SEL)action{
//    UIButton*button = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    
//    return button;
//}

@end
