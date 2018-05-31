//
//  AlertView.h
//  Qumaipiao
//
//  Created by 刘伟 on 15/9/16.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)(void);

@interface AlertView : UIAlertView
+(void)showAlertWithMessage:(NSString*)message;
+(UIAlertView*)showAlertWithMessage:(NSString *)message target:(id)target;
+(void)showAlertWithMessage:(NSString *)message confirmBlock:(Block)confirmBlock withVC:(UIViewController*)VC;
@property(nonatomic,copy)Block block;
@end
