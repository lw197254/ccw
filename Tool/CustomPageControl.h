//
//  MyPageControl.h
//  chechengwang
//
//  Created by 严琪 on 17/2/23.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIView

//声明pageControl点的样式枚举
typedef enum : NSInteger{
    /**
     默认类型:圆形
     */
    CustomPageControlStyleDefaoult = 0,
    /**
     正方形
     */
    CustomPageControlStyleSquare,
    /**
     圆形蓝色
     */
    CustomPageControlBlueCircle,
    /**
     <<<缩略图>>>!!!
     */
    CustomPageControlStyleImages,
}CustomPageControlStyle;

@property(nonatomic, assign)NSInteger pageNumber;//点的个数
@property(nonatomic, assign)CGFloat pageSpace;//点的间隔
@property(nonatomic, strong)UIColor *pageBackgroundColor;//点的背景颜色
@property(nonatomic, strong)UIColor *selectedColor;//选中的背景色
@property(nonatomic, assign)NSInteger currentPageNumber;//当前点击的pageNumber
@property(nonatomic, assign)CustomPageControlStyle pageStyle;//当前pageControl样式
@property(nonatomic, strong)NSMutableArray *imageArray;
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame pageStyle:(CustomPageControlStyle)pageStyle withImageArray:(NSMutableArray *)imageArray;
-(void)setCurrentPageNumber:(NSInteger)currentPageNumber nextPage:(NSInteger)nextPageNumber;
@end
