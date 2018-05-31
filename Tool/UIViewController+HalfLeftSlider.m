//
//  UIViewController+HalfLeftSlider.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UIViewController+HalfLeftSlider.h"
#import "UIView+CurrentViewController.h"
static char*const removeBlockKey = "removeBlockKey";
@implementation UIViewController (HalfLeftSlider)


-(void)setRemoveBlock:(RemoveBlock)removeBlock{
    objc_setAssociatedObject(self, removeBlockKey, removeBlock, OBJC_ASSOCIATION_COPY);
}
-(RemoveBlock)removeBlock{
    return objc_getAssociatedObject(self, removeBlockKey) ;
}
-(void)resetHalfLeftSliderViewController:(UIViewController*)viewController edgeInsets:(UIEdgeInsets)edgeInsets{
    [self.view bringSubviewToFront:viewController.view];
     CGRect frame = self.view.frame;
    frame.origin.x += edgeInsets.left;
    
    frame.size.width = frame.size.width - edgeInsets.left + edgeInsets.right;
    frame.size.height = frame.size.height + frame.origin.y - edgeInsets.top + edgeInsets.bottom;
    frame.origin.y = edgeInsets.top;
    viewController.view.frame = frame;
    
    [UIView animateWithDuration:0.25 animations:^{
         viewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];

}
-(void)addHalfLeftSliderViewController:(UIViewController*)viewController viewEdgeInsets:(UIEdgeInsets)edgeInsets removeBlock:(RemoveBlock)removeBlock{
    if ([self removeBlock]!=removeBlock) {
        [self setRemoveBlock:removeBlock];
    }
    CGRect frame = self.view.frame;
   
   
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    frame.origin.x += edgeInsets.left;
    
    frame.size.width = frame.size.width - edgeInsets.left + edgeInsets.right;
    frame.size.height = frame.size.height + frame.origin.y - edgeInsets.top + edgeInsets.bottom;
    frame.origin.y = edgeInsets.top;
     viewController.view.frame = CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    [viewController.view addShadow];
   // UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lineHeight, frame.size.height)];
   

//    view.backgroundColor = seperateLineColor;
//    [viewController.view addSubview:view];
   [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.view).with.offset(edgeInsets.left);
       make.right.equalTo(self.view).with.offset(edgeInsets.right);
       make.top.equalTo(self.view).with.offset(edgeInsets.top);
       make.bottom.equalTo(self.view).with.offset(edgeInsets.bottom);
   }];
    [UIView animateWithDuration:0.25 animations:^{
        viewController.view.frame = frame;
    }];
    UIPanGestureRecognizer*pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [viewController.view addGestureRecognizer:pan];
}
- (IBAction)panGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point =   [sender translationInView:sender.view];
    if (point.x <0) {
        
        return;
    }
    ///上一次手势的位置
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            
            sender.view.transform =  CGAffineTransformMakeTranslation( point.x, 0);
            break;
        }
        case  UIGestureRecognizerStateChanged:{
            sender.view.transform =CGAffineTransformMakeTranslation( point.x, 0);
            break;
        }
        case  UIGestureRecognizerStateCancelled:{
            break;
        }
        case  UIGestureRecognizerStateEnded:{
            if (point.x >sender.view.frame.size.width/4) {
                [UIView animateWithDuration:0.25 animations:^{
                    sender.view.transform = CGAffineTransformMakeTranslation(sender.view.frame.size.width, 0);
                }completion:^(BOOL finished) {
                    if (finished) {
                        
                        if ([self removeBlock]!=nil) {
                            [self removeBlock]();
                        }
                    }
                   
                   
                }];
            }else {
                [UIView animateWithDuration:0.25 animations:^{
                    sender.view.transform = CGAffineTransformMakeTranslation(0, 0);
                }];
            }
            break;
            
        }
            break;
            
    };
    
    
    
    
    
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point =   [(UIPanGestureRecognizer*)gestureRecognizer translationInView:gestureRecognizer.view];
        if (fabs(point.x) > fabs(point.y)) {
            otherGestureRecognizer.enabled = NO;
            otherGestureRecognizer.enabled = YES;
            return NO;
        }
        return YES;
    }
    return NO;
    
}
-(void)removeHalfLeftSliderFromParentViewController{
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
   
    
}
-(void)removeHalfLeftSliderFromParentViewControllerWithAnimated:(BOOL)animated{
    if (animated) {
        static BOOL isAnimating = NO;
        if (isAnimating==YES) {
            return;
        }
        [UIView animateWithDuration:0.25 animations:^{
            isAnimating = YES;
            self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        }completion:^(BOOL finished) {
            if (finished) {
                isAnimating = NO;
                 [self removeHalfLeftSliderFromParentViewController];
            }
           
        }];
    }else{
        [self removeHalfLeftSliderFromParentViewController];
    }
    

   
}

@end
