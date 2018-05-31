//
//  KeyboardObserver.h
//  12123
//
//  Created by 刘伟 on 2016/10/19.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^KeyboardObserverHeightChangeBlock)(CGFloat height,float duration);
@interface KeyboardObserver : NSObject
+(instancetype)shareInstanceWithKeyboardHeightChange:(KeyboardObserverHeightChangeBlock)height;
@end
