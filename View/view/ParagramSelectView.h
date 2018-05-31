//
//  paragramSelectView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//
///分类选择的视图
#import <UIKit/UIKit.h>
typedef void (^ParagramItemSelectedBlock)(NSInteger i);
@interface ParagramSelectView : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

-(void)showWithTitleArray:(NSArray<NSString*>*)titleArray titleClicked:(ParagramItemSelectedBlock)block;
@end
