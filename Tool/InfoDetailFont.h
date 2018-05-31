//
//  InfoDetailFont.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ArticleFontStyle){
    ArticleFontStyleSmall  = 0,
    ArticleFontStyleMiddle  = 1,
    ArticleFontStyleLarge  = 2,
    ArticleFontStyleVeryLarge  = 3
};
@interface InfoDetailFont : NSObject
@property(nonatomic,assign)ArticleFontStyle fontStyle;
@property(nonatomic,assign,readonly)NSInteger fontSize;
+(instancetype)shareInstance;


@end
