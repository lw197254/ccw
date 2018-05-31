//
//  UIButton+Extend.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UIButton+Extend.h"
#define  ButtonHeight 36
@implementation UIButton (Extend)
-(void)exchangeImageAndTitle{
    
    CGFloat titleWidth = [self.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    CGFloat imageWidth = [self.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-5, 0, imageWidth+5);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
    
}
-(void)exchangeImageAndTitleWithSpace:(NSInteger)space{
    
    CGFloat titleWidth = [self.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    CGFloat imageWidth = [self.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth-space/2, 0, imageWidth+space/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+space/2, 0, -titleWidth-space/2);
    
}
-(UIButton *)initNavigationButtonWithTitle:(NSString *)str color:(UIColor *)color font:(UIFont*)font{
    CGRect buttonFrame = CGRectZero;
    
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(999999.0f, ButtonHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    if ( IOS7_OR_LATER )
    {
        buttonFrame = CGRectMake(0, 0, titleSize.width+1, ButtonHeight);
    }
    else
    {
        buttonFrame = CGRectMake(0, 0, titleSize.width + 10.0f, ButtonHeight);
    }
    
    self = [self initWithFrame:buttonFrame];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = font;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitle:str forState:UIControlStateNormal];
    return self;
}
-(void)setNormalAskForPriceButton{
    [self setBackgroundImage:[UIImage imageWithColor:BlueColorF5F8FE size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:BlueColorE4EDFF  size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [self setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
    
    [self setTitleColor:BlueColorA1BEFA  forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageWithColor:WhiteColorFAFBFE size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    [self setBackgroundColor:[UIColor clearColor]];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = BlueColor447FF5.CGColor;
    self.layer.cornerRadius = 3;
    
}
@end
