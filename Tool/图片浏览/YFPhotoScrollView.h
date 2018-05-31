//
// YFPhotoScrollView.h
//
//  Created by Mr.Yan on 15/9/15.
//  Copyright (c) 2015年 我的地盘我做主. All rights reserved.
//

//我的地盘我做主
#import <UIKit/UIKit.h>
#define kPhotoImageEdgeSize  40
#define kBackgroundColor [UIColor grayColor]

@interface UIView (viewController)
- (UIViewController *)viewController;
@end

@implementation UIView (viewController)

- (UIViewController *)viewController {
    
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
   
    return nil;
}
@end

@class YFPhotoBrowser, YFPhoto, YFPhotoScrollView;

@protocol PhotoViewDelegate <NSObject>
@optional
- (void)photoViewWillZoomIn:(YFPhotoScrollView *)photoView;
- (void)photoViewDidZoomIn:(YFPhotoScrollView *)photoView;
- (void)photoViewWillZoomOut:(YFPhotoScrollView *)photoView;
- (void)photoViewDidZoomOut:(YFPhotoScrollView *)photoView;

@end

@interface YFPhotoScrollView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) YFPhoto *photo;
// 代理
@property (nonatomic, weak) id<PhotoViewDelegate> photoViewDelegate;
@end
