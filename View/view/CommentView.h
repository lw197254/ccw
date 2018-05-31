//
//  CommentView.h
//  12123
//
//  Created by 刘伟 on 2016/10/19.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CommentViewDismissBlock)(void);
@interface CommentView : UIView
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
-(void)show;
-(void)dismiss:(CommentViewDismissBlock)block;
-(void)dismiss;
@end
