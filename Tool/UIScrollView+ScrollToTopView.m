//
//  UIScScrollView+ScrollToTopView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UIScrollView+ScrollToTopView.h"
static char*const scrollToTopViewKey = "scrollToTopViewKey";
static char*const scrollToTopViewShowKey = "scrollToTopViewShowKey";
@implementation UIScrollView (ScrollToTopView)


-(void)showScrollTopView{
    if (!self.scrollToTopView) {
        self.scrollToTopView = [Tool createButtonWithImage:[UIImage imageNamed:@"左移"] target:self action:@selector(scrollsToTop) tag:0];
        self.scrollToTopView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.superview addSubview:self.scrollToTopView];
        [self.scrollToTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-20);
            make.bottom.equalTo(self).with.offset(-60);
//            make.centerX.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
//            make.height.equalTo(self.scrollToTopView.mas_width);
        }];
    }else{
        self.scrollToTopView.hidden = NO;
    }
    [self.superview bringSubviewToFront:self.scrollToTopView];
}
-(void)hideScrollToTopView{
    self.scrollToTopView.hidden = YES;
}
-(void)setScrollToTopViewShow:(BOOL)scrollToTopViewShow{
    objc_setAssociatedObject(self, scrollToTopViewShowKey, [NSNumber numberWithBool: scrollToTopViewShow ], OBJC_ASSOCIATION_ASSIGN);
    __block RACDisposable *handler;
    if (scrollToTopViewShow==YES) {
        @weakify(self);
      handler =  [[RACObserve(self, contentOffset)filter:^BOOL(id value) {
            @strongify(self);
            return (self.contentSize.height>0);
            
        }]subscribeNext:^(id x) {
            @strongify(self);
            if( self.contentOffset.y > 0){
                [self showScrollTopView];
            }else{
                [self hideScrollToTopView];
            }
            
        }];

    }else{
//        [handler dispose];
    }
}
-(BOOL)scrollToTopViewShow{
    return [objc_getAssociatedObject(self, scrollToTopViewShowKey) boolValue] ;
}
-(void)setScrollToTopView:(UIButton*)scrollToTopView{
    objc_setAssociatedObject(self, scrollToTopViewKey, scrollToTopView, OBJC_ASSOCIATION_RETAIN);
}
-(UIButton*)scrollToTopView{
   return objc_getAssociatedObject(self, scrollToTopViewKey) ;
}
-(void)scrollsToTop{
    [self setContentOffset:CGPointMake(self.contentOffset.x, 0) animated:YES];
}
@end
