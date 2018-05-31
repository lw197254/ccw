//
//  PhotoMoreViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/3/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

#import "ZLPhotoPickerBrowserPhoto.h"
#import "ZLPhotoPickerCommon.h"
#import "ZLPhotoPickerCustomToolBarView.h"
#import "ZLPhotoPickerBrowserPhotoScrollView.h"

#import "PicMenuModel.h"
#import "HTHorizontalSelectionList.h"
#import "PhotoViewModel.h"

@class PhotoMoreViewController;

@interface PhotoMoreViewController : ParentViewController<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>

// 数据源/代理
@property (nonatomic , weak) id<ZLPhotoPickerBrowserViewControllerDelegate> delegate;

// 展示的图片数组<ZLPhotoPickerBrowserPhoto> == [self.dataSource photoBrowser:photoAtIndex:]
@property (strong,nonatomic) NSArray<ZLPhotoPickerBrowserPhoto *> *photos;
// 当前提供的组
@property (assign,nonatomic) NSInteger currentIndex;

// @optional
// 是否可以编辑（删除照片）
@property (nonatomic , assign,getter=isEditing) BOOL editing;
// 动画status (放大缩小/淡入淡出/旋转)
@property (assign,nonatomic) UIViewAnimationAnimationStatus status;
// 长按保存图片会调用sheet
@property (strong,nonatomic) UIActionSheet *sheet;
// 需要增加的导航高度
@property (assign,nonatomic) CGFloat navigationHeight;

// 放大缩小一张图片的情况下（查看头像）
- (void)showHeadPortrait:(UIImageView *)toImageView;
// 放大缩小一张图片的情况下（查看头像）/ 缩略图是toImageView.image 原图URL
- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl;

// @function
// 展示控制器
- (void)showPickerVc:(UIViewController *)vc;
- (void)showPushPickerVc:(UIViewController *)vc;


// 列表数据
@property(strong,nonatomic) NSArray<PicMenuModel*> *toolBarList;
@property(nonatomic,strong)NSString *carName;
@property(nonatomic,strong)NSString *carType;
@property(nonatomic,strong)NSString *carPrice;
// 选中的列表
@property(nonatomic,assign)NSInteger labelCurrentNumber;
// 选中的列表名称
@property(nonatomic,copy)NSString* labelCurrentName;
@property(nonatomic,copy)NSString* carId;
@property(nonatomic,copy)NSString* typeId;
// 预初始化的图片
//初始化的图片列表
@property (nonatomic,strong)NSMutableDictionary* forestalllDict;

@property(nonatomic,strong)NSString *catgoryId;
@property(nonatomic,strong)NSString *colorId;

///有无经销商
@property(nonatomic,strong)NSString *has_dealer;
@end
