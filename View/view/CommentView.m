//
//  CommentView.m
//  12123
//
//  Created by 刘伟 on 2016/10/19.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "CommentView.h"

#import "KeyboardManager.h"
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000
@interface CommentView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (copy, nonatomic)CommentViewDismissBlock block;
@property (weak, nonatomic) IBOutlet UIView *backtopVIEW;


@end
@implementation CommentView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.messageTextView.inputAccessoryView = [[UIView alloc] init];
    
    self.messageField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.messageField.leftViewMode = UITextFieldViewModeAlways;
    
    
    [self.messageField setValue:[UIFont systemFontOfSize:14.f weight:UIFontWeightThin] forKeyPath:@"_placeholderLabel.font"];

    self.messageTextView.delegate = self;
        [[RACSignal combineLatest:@[self.messageTextView.rac_textSignal] reduce:^(NSString*message){
            return@([message stringByTrimmingTrailingWhitespaceAndNewlineCharacters].length >0);
        }]subscribeNext:^(NSNumber *res) {
            if (res.boolValue) {
                self.sendButton.enabled = YES;
                self.messageField.hidden = YES;
            }else{
                self.messageField.hidden = NO;
                self.sendButton.enabled = NO;
            }
        }];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.backtopVIEW addGestureRecognizer:tap];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    [self.sendButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [KeyboardObserver shareInstanceWithKeyboardHeightChange:^(CGFloat height, float duration) {
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -height);
        }];
        
    }];
   }
-(void)show{
    self.hidden = NO;
    [self.messageTextView becomeFirstResponder];
    NSRange range = self.messageTextView.selectedRange;
    [self.messageTextView scrollRangeToVisible:range];
}
-(void)dismiss{
    [self.messageTextView resignFirstResponder];
    self.hidden = YES;
    if (self.block) {
        self.block();
    }
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *hexstr = @"";
    
//    for (int i=0;i< [text length];i++)
//    {
//        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X ",[text characterAtIndex:i]]];
//    }
//    NSLog(@"UTF16 [%@]",hexstr);
//    
//    hexstr = @"";
//    
//    long slen = strlen([text UTF8String]);
//    
//    for (int i = 0; i < slen; i++)
//    {
//        //fffffff0 去除前面六个F & 0xFF
//        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[text UTF8String][i] & 0xFF ]];
//    }
//    NSLog(@"UTF8 [%@]",hexstr);
//    
//    hexstr = @"";
//    
//    if ([text length] >= 2) {
//        
//        for (int i = 0; i < [text length] / 2 && ([text length] % 2 == 0) ; i++)
//        {
//            // three bytes
//            if (([text characterAtIndex:i*2] & 0xFF00) == 0 ) {
//                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[text characterAtIndex:i*2],[text characterAtIndex:i*2+1]];
//            }
//            else
//            {// four bytes
//                hexstr = [hexstr stringByAppendingFormat:@"U+%1X ",MULITTHREEBYTEUTF16TOUNICODE([text characterAtIndex:i*2],[text characterAtIndex:i*2+1])];
//            }
//            
//        }
//        NSLog(@"(unicode) [%@]",hexstr);
//    }
//    else
//    {
//        NSLog(@"(unicode) U+%1X",[text characterAtIndex:0]);
//    }
    
    return YES;
    
}


-(void)dismiss:(CommentViewDismissBlock)block{
    
    if (self.block != block) {
        self.block = block;
    }
}
-(instancetype)init{
   return  [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
}

 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
