//
//  MyOwnShareView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MyOwnShareType) {
    /**
     *  share art
     */
    ShareArt,
    /**
     *  only share pic
     */
    SharePic,
};

@interface MyOwnShareView : NSObject

///初始化界面
-(void) initPopView;


@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *share_url;
@property(nonatomic,copy)NSString *pic_url;

@property(nonatomic,assign)MyOwnShareType myownshareType;

@end
