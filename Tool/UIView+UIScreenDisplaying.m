//
//  UIView+UIScreenDisplaying.m
//  chechengwang
//
//  Created by 刘伟 on 2017/2/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UIView+UIScreenDisplaying.h"

@implementation UIView (UIScreenDisplaying)
// 判断View是否显示在屏幕上

- (BOOL)isDisplayedInScreen

{
    
    if (self == nil) {
        
        return FALSE;
        
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    
    CGRect rect = [self convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        
        return FALSE;
        
    }
    
    // 若view 隐藏
    
    if (self.hidden) {
        
        return FALSE;
        
    }
    
    // 若没有superview
    
    if (self.superview == nil) {
        
        return FALSE;
        
    }else{
         CGRect rect1 = [self convertRect:self.frame toView:self.superview];
        CGRect intersectionRect = CGRectIntersection(rect1, self.superview.frame);
        
        if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
            
            return FALSE;
            
        }

    }
    
    // 若size为CGrectZero
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        
        return  FALSE;
        
    }
    
    // 获取 该view与window 交叉的 Rect
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        
        return FALSE;
        
    }
    
    return TRUE;
    
}


@end
