//
//  CustomAlertView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CustomAlertView.h"
@interface CustomAlertView()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonLeadingToSuperViewConstraint;

@property (weak, nonatomic) IBOutlet UIView *middleSeparateLineView;

@property (copy, nonatomic)  CustomAlertViewBlock confirmBlock;
@property (copy, nonatomic)  CustomAlertViewBlock cancelBlock;
@end
@implementation CustomAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)alertView{
    return [[[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:nil options:nil] firstObject];
}


-(void)showWithTitle:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelTitle confirmButtonTitle:(NSString*)confirmTitle cancel:(CustomAlertViewBlock)cancel confirm:(CustomAlertViewBlock)confirm{
    
    self.titleLabel.text = title;
    self.messageLabel.text = message;
    [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
    [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    ;
    [self show];
    if (_cancelBlock!=cancel) {
        _cancelBlock = cancel;
    }
    if (_confirmBlock!=confirm) {
        _confirmBlock = confirm;
    }

}
-(void)showWithTitle:(NSString *)title cancel:(CustomAlertViewBlock)cancel confirm:(CustomAlertViewBlock)confirm{
    [self show];
    self.titleLabel.text = title;
    if (_cancelBlock!=cancel) {
        _cancelBlock = cancel;
    }
    if (_confirmBlock!=confirm) {
        _confirmBlock = confirm;
    }
    
}
-(void)show{
    ///有就显示，没有就隐藏
    if (self.titleLabel.text.length==0) {
        self.titleLabel.hidden = YES;
        self.titleHeightConstraint.priority = 900;
    }else{
        self.titleLabel.hidden = NO;
        self.titleHeightConstraint.priority = 1;
    }
    if (self.messageLabel.text.length==0) {
        self.messageLabel.hidden = YES;
        self.messageHeightConstraint.priority = 900;
    }else{
        self.messageLabel.hidden = NO;
        self.messageHeightConstraint.priority = 1;
    }
    if(self.cancelButton.titleLabel.text.length==0){
        self.cancelButton.hidden = YES;
        self.middleSeparateLineView.hidden = YES;
        self.confirmButtonLeadingToSuperViewConstraint.priority = 900;
    }else{
        self.confirmButtonLeadingToSuperViewConstraint.priority = 1;
        self.cancelButton.hidden = NO;
        self.middleSeparateLineView.hidden = NO;
    }
    UIWindow*window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    
}
- (IBAction)ConfirmClicked:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (IBAction)cancelClicked:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
     [self removeFromSuperview];
}


@end
