//
//  UIView+CurrentViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UIView+CurrentViewController.h"

@implementation UIView (CurrentViewController)
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
