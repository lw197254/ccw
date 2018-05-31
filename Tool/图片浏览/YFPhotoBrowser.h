//
//  YFPhotoBrowser.h
//  02 CircleProgress
//
//  Created by Mr.Yan on 15/9/15.
//  Copyright (c) 2015年 我的地盘我做主. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFPhoto.h"
#import "YFPhotoScrollView.h"
#import "YFPhotoCell.h"

@protocol PhotoBrowerDelegate <NSObject>

//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(YFPhotoBrowser *)photoBrowser;

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (YFPhoto *)photoBrowser:(YFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@end

@interface YFPhotoBrowser : UIView <UIScrollViewDelegate,PhotoViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic,assign)id<PhotoBrowerDelegate> delegate;

//显示
+ (void)showImageInView:(UIView *)view selectImageIndex:(NSInteger)index delegate:(id<PhotoBrowerDelegate>)delegate;
@end