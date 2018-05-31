//
//  YFPhoto.m
//  02 CircleProgress
//
//  Created by Mr.Yan on 15/9/15.
//  Copyright (c) 2015年 我的地盘我做主. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YFPhoto.h"

@implementation YFPhoto
#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    _srcImageView = srcImageView;
    _placeholder = srcImageView.image;
//    if (srcImageView.clipsToBounds) {
//        _capture = [self capture:srcImageView];
//    }
}

@end