//
//  UIViewController+HalfLeftSlider.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/27.
//  Copyright © 2017年 车城网. All rights reserved.
//
///半边侧滑
#import <UIKit/UIKit.h>
typedef void(^RemoveBlock)();
@interface UIViewController (HalfLeftSlider)
-(void)addHalfLeftSliderViewController:(UIViewController*)viewController viewEdgeInsets:(UIEdgeInsets)edgeInsets removeBlock:(RemoveBlock)removeBlock;
///当前离开上一级界面

-(void)removeHalfLeftSliderFromParentViewController;
-(void)removeHalfLeftSliderFromParentViewControllerWithAnimated:(BOOL)animated;
-(void)resetHalfLeftSliderViewController:(UIViewController*)viewController edgeInsets:(UIEdgeInsets)edgeInsets;
@end
