//
//  UINavigationController+Present.m
//  chechengwang
//
//  Created by 刘伟 on 2017/7/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UINavigationController+Present.h"

@implementation UINavigationController (Present)
- (void)dismissViewController
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
    
}


- (void)presentViewController:(UIViewController *)viewController
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:viewController animated:NO];
}

@end
