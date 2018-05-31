//
//  CustomAlertView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CustomAlertViewBlock)();
@interface CustomAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//@property (copy, nonatomic)  UIFont *titleLabelFond;
//@property (copy, nonatomic)  UIFont *messageLabelFond;
//@property (copy, nonatomic)  UIColor *titleTextColor;
//
//@property (copy, nonatomic)  UIColor *messageTextColor;
+(instancetype)alertView;
-(void)showWithTitle:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelTitle confirmButtonTitle:(NSString*)confirmTitle cancel:(CustomAlertViewBlock)cancel confirm:(CustomAlertViewBlock)confirm;
@end
