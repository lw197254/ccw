//
//  YFPhoto.h
//  02 CircleProgress
//
//  Created by Mr.Yan on 15/9/15.
//  Copyright (c) 2015年 我的地盘我做主. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YFPhoto : NSObject

@property (nonatomic, strong) NSURL *url; // 大图的URL
@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;//占位图
@property (nonatomic, assign) BOOL isSelectImg;//是否被选中

//@property (nonatomic, strong, readonly) UIImage *capture;

@end