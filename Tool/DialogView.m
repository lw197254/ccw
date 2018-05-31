//
//  DialogView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/2/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView
+ (DialogView *) sharedInstance
{
    static DialogView *sharedInstance = nil ;
    static dispatch_once_t onceToken;  // 锁
    dispatch_once (&onceToken, ^ {     // 最多调用一次
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)showDlg:(UIView *) view textOnly:(NSString *) label delayTime:(NSInteger)delay{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud show:YES];
    hud.userInteractionEnabled = NO;
    
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    //    hud.labelText = label;
    hud.detailsLabelText = label;
    hud.margin = 10.f;
    hud.labelFont = FontOfSize(16);
    hud.detailsLabelFont = FontOfSize(16);
    hud.minSize = CGSizeMake(150, 50);
    //    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    //[hud hide:YES afterDelay:delay];
   [[GCDQueue mainQueue]queueBlock:^{
       [hud hide:YES];
   } afterDelay:delay];
   
    
   
}
- (void)showDlg:(UIView *) view textOnly:(NSString *) label {
    [self showDlg:view textOnly:label delayTime:2];

}
@end
