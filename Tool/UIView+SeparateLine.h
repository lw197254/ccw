//
//  UITableViewCell+SeparateLine.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/14.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SeparateLine)
///设置上面的线UIEdgeInsets 为0
-(void)setTopLine;
///设置左边的线UIEdgeInsets 为0
-(void)setLeftLine;
///设置右边的线UIEdgeInsets 为0
-(void)setRightLine;
///设置下面的线UIEdgeInsets 为0
-(void)setBottomLine;
///设置上面的线UIEdgeInsets
-(void)setTopLineWithEdgeInsets:(UIEdgeInsets)edgeInsets;
///设置左边的线UIEdgeInsets
-(void)setLeftLineWithEdgeInsets:(UIEdgeInsets)edgeInsets;
///设置右边的线UIEdgeInsets
-(void)setRightLineWithEdgeInsets:(UIEdgeInsets)edgeInsets;
///设置下面的线UIEdgeInsets
-(void)setBottomLineWithEdgeInsets:(UIEdgeInsets)edgeInsets;

//-(void)setTopLine:(BOOL)isTopLineShow leftLine:(BOOL)isLeftLineShow rightLine:(BOOL)isRightLineShow bottomLine:(BOOL)isBottomLineShow;
@property(nonatomic,assign)BOOL topLineShow;
@property(nonatomic,assign)BOOL leftLineShow;
@property(nonatomic,assign)BOOL rightLineShow;
@property(nonatomic,assign)BOOL bottomLineShow;


//
//@property(nonatomic,strong)CAShapeLayer *topSeparatorLayer;
//@property(nonatomic,strong)CAShapeLayer *leftSeparatorLayer;
//@property(nonatomic,strong)CAShapeLayer *rightSeparatorLayer;
//@property(nonatomic,strong)CAShapeLayer *bottomSeparatorLayer;
@end
