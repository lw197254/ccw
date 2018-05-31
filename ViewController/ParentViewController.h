//
//  ParentViewController.h
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/2.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "Scene.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@class ToastUtils;
//#import "CustomNavigationBar.h"
@interface ParentViewController : Scene<UIGestureRecognizerDelegate>
-(void)showNavigationTitle:(NSString*)title;
-(void)showNavigationWithImageName:(NSString*)imageName;
@property(nonatomic,strong)UIButton*backButton;

/////当前界面是否隐藏navitionbar，使用该方法会做动画处理，不然有bug，navitionbar的隐藏显示全使用该方法
//@property(nonatomic,assign)BOOL navigationBarHidden;
///navitionbar 下面的线
@property(nonatomic,assign)BOOL navigationBarBottomLineHidden;
-(void)showbackButtonwithTitle:(NSString*)title;
//@property(nonatomic,assign)BOOL cancelAllRequestInCurrentVC;
-(void)refreshViewController;
-(void)setNavigationBackgroundColor:(UIColor*)color;
-(void)setNavigationtitle:(NSString*)text textColor:(UIColor*)textColor;

-(void)addjustButton:(UIButton*)button WithTitle:(NSString*)title;

//@property(nonatomic,strong)CustomNavigationBar*navigitionBar;

/////车城网的方法
//-(void)initCheRightButton:(UIButton *)button :(UIButton *)button1;
-(void)btnClick:(UIButton *)button;
-(void)setNavigationButtontitle:(NSString*)text textColor:(UIColor*)textColor;
-(void)topclick:(UIButton *)click;

-(void)showSaveSuccess;
-(void)showSaveSuccessWithTitle:(NSString*)title;

-(void)showSaveRemove;
-(void)showSaveRemoveWithTitle:(NSString*)title;
-(void)initButtonView;

-(void)askPrise:(UIButton *)sender;
-(void)makeCall:(UIButton *)sender;

- (void)setStatusBarBackgroundColor:(UIColor *)color;
@end
