//
//  PhoneCallWebView.m
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/15.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "PhoneCallWebView.h"

@implementation PhoneCallWebView
+(PhoneCallWebView*)showWithTel:(NSString*)tel{
    
    NSMutableString* str1=[[NSMutableString alloc]initWithString:tel];//存在堆区，可变字符串
   ///大于等于10.2
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.2"] != NSOrderedAscending) {
        [PhoneCallWebView callTEL:tel];
    }else{
        [UIAlertController showAlertInViewController:[Tool currentViewController] withTitle:str1 message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"呼叫" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if([action.title isEqualToString:@"呼叫"]){
                [PhoneCallWebView callTEL:tel];
            }
        }];
    }
    return nil;
}
+(void)callTEL:(NSString*)tel{
   
    if (tel.length==0) {
        return ;
    
    }
    NSString* phoneStr = [NSString stringWithFormat:@"tel://%@",tel];
    if ([phoneStr hasPrefix:@"sms:"] || [phoneStr hasPrefix:@"tel:"]) {
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:phoneStr]]) {
            /// 大于等于10.0系统使用此openURL方法
            if (IOS_10_OR_LATER) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr] options:@{} completionHandler:nil];
            }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
        }
    }

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
