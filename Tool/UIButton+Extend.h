//
//  UIButton+Extend.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extend)
-(void)exchangeImageAndTitle;
-(void)exchangeImageAndTitleWithSpace:(NSInteger)space;
-(UIButton *)initNavigationButtonWithTitle:(NSString *)str color:(UIColor *)color font:(UIFont*)font;
-(void)setNormalAskForPriceButton;
@end
