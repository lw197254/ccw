//
//  PickerView.m
//  TMC_lutao
//
//  Created by 刘伟 on 16/4/19.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)pickerViewWithConfirmBlock:(PickerViewConfirmBlock)pickerBlock{
    PickerView*picker = [[[NSBundle mainBundle]loadNibNamed:@"PickerView" owner:nil options:nil]firstObject ];
    picker.confirmBlock = pickerBlock;
     picker.whiteBackgroundView.transform = CGAffineTransformMakeTranslation(0, 250);
    return picker;
}
- (IBAction)cancelClicked:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)confirmClicked:(UIButton *)sender {
    
    if([self anySubViewScrolling:self]){
        return ;
    }
    
    if (_confirmBlock!=nil) {
        _confirmBlock();
    }
    [self dismiss];
}

- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

-(void)show{
   
     self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
         self.whiteBackgroundView.transform = CGAffineTransformIdentity;
        
        
    }];
}
- (IBAction)hideTap:(id)sender {
    [self dismiss];
}
-(void)dismiss{
   
    [UIView animateWithDuration:0.25 animations:^{
    self.whiteBackgroundView.transform = CGAffineTransformMakeTranslation(0, 250);
     
        
        
    }completion:^(BOOL finished) {
         self.hidden = YES;
    }];
  
    
}
@end
