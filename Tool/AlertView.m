//
//  AlertView.m
//  Qumaipiao
//
//  Created by 刘伟 on 15/9/16.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)showAlertWithMessage:(NSString *)message{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
+(UIAlertView*)showAlertWithMessage:(NSString *)message target:(id)target{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}
+(void)showAlertWithMessage:(NSString *)message confirmBlock:(Block)confirmBlock withVC:(UIViewController*)VC{
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confirmBlock();
    }];
    [alert addAction:action];
    [VC presentViewController:alert animated:YES completion:nil] ;
   
}

@end
