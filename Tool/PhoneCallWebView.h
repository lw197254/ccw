//
//  PhoneCallWebView.h
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/15.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCallWebView : UIWebView
+(PhoneCallWebView*)showWithTel:(NSString*)tel;
@end
