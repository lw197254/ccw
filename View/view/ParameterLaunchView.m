//
//  ParameterLaunchView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParameterLaunchView.h"
@interface ParameterLaunchView()
@property(nonatomic,copy)ParameterLaunchViewDismissBlock block;
@end
@implementation ParameterLaunchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(BOOL)showWithDismissBlock:(ParameterLaunchViewDismissBlock)dismissBlock{
    ///展示过之后就不再展示
    if ([[NSUserDefaults standardUserDefaults] objectForKey:classNameFromClass([self class])]) {
        return NO;
    }
    
    
    
    ParameterLaunchView*view = [[ParameterLaunchView alloc]init];
    if (view.block!= dismissBlock) {
        view.block = dismissBlock;
    }
    
      UIWindow*window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    return YES;
}
-(instancetype)init{
  self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
    
    return self;

}
- (IBAction)nextClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults]setObject:classNameFromClass([self class]) forKey:classNameFromClass([self class])];
    [self removeFromSuperview];
    if(self.block){
        self.block();
    }
}

@end
