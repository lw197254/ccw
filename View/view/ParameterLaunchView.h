//
//  ParameterLaunchView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//
///配置页面第一次进来的引导图
#import <UIKit/UIKit.h>
typedef void (^ParameterLaunchViewDismissBlock)();
@interface ParameterLaunchView : UIView
+(BOOL)showWithDismissBlock:(ParameterLaunchViewDismissBlock)dismissBlock;
@end
