//
//  KeyboardObserver.m
//  12123
//
//  Created by 刘伟 on 2016/10/19.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "KeyboardObserver.h"
@interface KeyboardObserver()
@property(nonatomic,copy) KeyboardObserverHeightChangeBlock block;
@end
@implementation KeyboardObserver
+(instancetype)shareInstanceWithKeyboardHeightChange:(KeyboardObserverHeightChangeBlock)height{
   static KeyboardObserver *instance;
   static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class]alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:instance
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:instance
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    });
   
    
    if (instance.block!=height) {
        instance.block = height;
    }
    return instance;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
     CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.block) {
        self.block(height,duration);
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
     NSDictionary *userInfo = [aNotification userInfo];
      CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.block) {
        self.block(0,duration);
    }
}



@end
