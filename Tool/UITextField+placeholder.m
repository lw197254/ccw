//
//  UITextField+placeholder.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UITextField+placeholder.h"

@implementation UITextField (placeholder)
-(void)resetPlaceholderWithTextColor:(UIColor*)color Font:(UIFont*)font{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:self.placeholder];
    [placeholder addAttribute:NSForegroundColorAttributeName
                       value:color
                        range:NSMakeRange(0, self.placeholder.length)];
    [placeholder addAttribute:NSFontAttributeName
                       value:font
                       range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = placeholder;
}
@end
