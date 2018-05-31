//
//  DialogView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/2/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DialogView : NSObject
+ (DialogView *) sharedInstance;
- (void)showDlg:(UIView *) view textOnly:(NSString *) label ;
- (void)showDlg:(UIView *) view textOnly:(NSString *) label delayTime:(NSInteger)delay;
@end
