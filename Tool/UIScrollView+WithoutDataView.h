//
//  UITableView+WithoutDataView.h
//  TMC_convenientTravel
//
//  Created by 刘伟 on 16/6/1.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithDataView.h"
///没有数据的视图
typedef void(^ButtonClickedBlock)(void);
@interface UIScrollView (WithoutDataView)
//frame 如果传frame按frame布局，如果不传，按滚动视图本身布局
//-(void)showWithOutDataViewWithTitle:(NSString*)title frame:(CGRect)frame laugh:(BOOL)laugh;

///只有提示文本，图片为默认
-(void)showWithOutDataViewWithTitle:(NSString *)title;
///只有提示文本，图片为默认，可以修改偏移量
-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet;
///只有提示文本，图片为默认，可以选中居中样式
-(void)showWithOutDataViewWithTitle:(NSString *)title centerModel:(WithDataViewCenterMode)centerModel;


///只有提示文本，图片，
-(void)showWithOutDataViewWithTitle:(NSString*)title image:(UIImage*)image;
///只有提示文本，图片，可以修改偏移量
-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet image:(UIImage*)image;
///只有提示文本，图片，可以选中居中样式
-(void)showWithOutDataViewWithTitle:(NSString *)title centerModel:(WithDataViewCenterMode)centerModel image:(UIImage*)image;
//-(void)showWithOutDataViewWithTitle:(NSString*)title frame:(CGRect)frame image:(UIImage*)image;



///断网
-(void)showNetLost;
///断网  两种样式，一种图片底部居中，
-(void)showNetLostWithCenterModel:(WithDataViewCenterMode)centerModel;
//／一种自定义在内容居中的基础上修改偏移量
-(void)showNetLostWithCenterYOffSet:(CGFloat)centerYOffSet;

///有按钮的提示，有提示文本，图片，可以选中居中样式
-(void)showWithOutDataViewWithTitle:(NSString *)title centerModel:(WithDataViewCenterMode)centerModel image:(UIImage*)image buttonTitle:(NSString*)buttonTitle buttonClicked:(ButtonClickedBlock)block;
///有按钮的提示，有提示文本，图片，可以修改偏移量
-(void)showWithOutDataViewWithTitle:(NSString *)title centerYOffSet:(CGFloat)centerYOffSet image:(UIImage*)image buttonTitle:(NSString*)buttonTitle buttonClicked:(ButtonClickedBlock)block;
///有按钮的提示，有提示文本，图片
-(void)showWithOutDataViewWithTitle:(NSString *)title image:(UIImage*)image buttonTitle:(NSString*)buttonTitle buttonClicked:(ButtonClickedBlock)block;

-(void)dismissWithOutDataView;
@property(nonatomic,assign)ButtonClickedBlock buttonClickedBlock;
@property(nonatomic,strong)WithDataView* withoutView;
@end
