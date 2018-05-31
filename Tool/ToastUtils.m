//
//  ToastUtils.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ToastUtils.h"

@interface ToastUtils()

@property(nonatomic,strong)UILabel *messageLabel;

@end


@implementation ToastUtils


-(UILabel *)messageLabel{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = FontOfSize(14);
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        _messageLabel.layer.cornerRadius = 5;
        _messageLabel.layer.masksToBounds = YES;
        [_messageLabel setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.7]];
    }
    return _messageLabel;
}


-(void)showWithMessage:(NSString *)message fatherView:(UIView *)view{
    self.messageLabel.text = message;
    self.messageLabel.alpha = 1.0;
    [view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(130);
    }];
    
    [UIView animateWithDuration:2.f animations:^{
        self.messageLabel.alpha = 0.f;
    }];
    
    
    
}


@end
