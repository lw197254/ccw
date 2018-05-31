//
//  UIScrollView+EndEdit.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UIScrollView+EndEdit.h"

@implementation UIScrollView (EndEdit)
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self endEditing:YES];
}

@end
