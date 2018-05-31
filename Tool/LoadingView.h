//
//  loadingView.h
//  Qumaipiao
//
//  Created by 刘伟 on 15/6/11.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView


//-(void)showInViewController:(UIViewController*)viewController;
@property(nonatomic,assign)BOOL isShow;
-(void)show;
-(void)dismiss;
+(instancetype)shareInstance;

//-(void)ContinueAnimation;
+(void)show;
+(void)dismiss;
@property(nonatomic,assign)BOOL isHalfClearColor;
@end
