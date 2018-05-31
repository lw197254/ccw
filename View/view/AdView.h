//
//  AdView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompletionBlock)();
@interface AdView : UIView
+(void)showAdViewOnWindow:(UIWindow*)window complateBlock:(CompletionBlock)finish;
@end
