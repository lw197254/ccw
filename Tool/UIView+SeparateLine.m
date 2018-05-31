//
//  UITableViewCell+SeparateLine.m
//  chechengwang
//
//  Created by 刘伟 on 20lineHeight7/3/lineHeight4.
//  Copyright © 20lineHeight7年 江苏十分便民. All rights reserved.
//

#import "UIView+SeparateLine.h"
const char*leftLineShowKey = "leftLineShowKey";
const char*rightLineShowKey = "rightLineShowKey";
const char*bottomLineShowKey = "bottomLineShowKey";
const char*topLineShowKey = "topLineShowKey";
//const char*leftSeparatorLayerKey = "leftSeparatorLayerKey";
//const char*rightSeparatorLayerKey = "rightSeparatorLayerKey";
//const char*bottomSeparatorLayerKey = "bottomSeparatorLayerKey";
//const char*topSeparatorLayerKey = "topSeparatorLayerKey";

const char*leftLineEdgeInsetsKey = "leftLineEdgeInsetsKey";
const char*rightLineEdgeInsetsKey = "rightLineEdgeInsetsKey";
const char*bottomLineEdgeInsetsKey = "bottomLineEdgeInsetsKey";
const char*topLineEdgeInsetsKey = "topLineEdgeInsetsKey";

const char*leftSeparatorViewKey = "leftSeparatorViewKey";
const char*rightSeparatorViewKey = "rightSeparatorViewKey";
const char*bottomSeparatorViewKey = "bottomSeparatorViewKey";
const char*topSeparatorViewKey = "topSeparatorViewKey";
@implementation UIView (SeparateLine)
//@property(nonatomic,assign)UIEdgeInsets topLineEdgeInsets;
//@property(nonatomic,assign)UIEdgeInsets leftLineEdgeInsets;
//@property(nonatomic,assign)UIEdgeInsets rightLineEdgeInsets;
//@property(nonatomic,assign)UIEdgeInsets bottomLineEdgeInsets;
//-(void)setTopLine:(BOOL)isTopLineShow leftLine:(BOOL)isLeftLineShow rightLine:(BOOL)isRightLineShow bottomLine:(BOOL)isBottomLineShow{
//    
//}

-(void)layoutSubviews{
    if (self.topLineShow) {
        [self updateTopLine];
        
    }else{
        [[self topSeparatorView] removeFromSuperview];
    }
    if (self.bottomLineShow) {
        [self updateBottomLine];
    }else{
        [[self bottomSeparatorView] removeFromSuperview];
    }

    if (self.leftLineShow) {
        [self updateLeftLine];
       
    }else{
        [[self leftSeparatorView] removeFromSuperview];
    }

    if (self.rightLineShow) {
        [self updateRightLine];
       
    }else{
        [[self rightSeparatorView] removeFromSuperview];
    }

}
#pragma mark  添加普通的线，上下左右都为0

-(void)setTopLine{
   
    [self setTopLineWithEdgeInsets:UIEdgeInsetsZero];
   
}
-(void)setLeftLine{
   
   [self setLeftLineWithEdgeInsets:UIEdgeInsetsZero];
}
-(void)setBottomLine{
    
  [self setBottomLineWithEdgeInsets:UIEdgeInsetsZero];
}
-(void)setRightLine{
    
    [self setRightLineWithEdgeInsets:UIEdgeInsetsZero];
  
}
#pragma mark  添加普通的线，上下左右为edgeInsets
-(void)setTopLineWithEdgeInsets:(UIEdgeInsets)edgeInsets{
    
    
    [self setTopLineEdgeInsets:edgeInsets];
    [self setTopLineShow:YES];
    [self layoutIfNeeded];
    
}
-(void)setLeftLineWithEdgeInsets:(UIEdgeInsets)edgeInsets{
    
   
    [self setLeftLineEdgeInsets:edgeInsets];
    [self setLeftLineShow:YES];
    [self layoutIfNeeded];
}
-(void)setRightLineWithEdgeInsets:(UIEdgeInsets)edgeInsets{
    
    
    [self setRightLineEdgeInsets:edgeInsets];
    [self setRightLineShow:YES];
    [self layoutIfNeeded];
}
-(void)setBottomLineWithEdgeInsets:(UIEdgeInsets)edgeInsets{
    
    
    [self setBottomLineEdgeInsets:edgeInsets];
    [self setBottomLineShow:YES];
    [self layoutIfNeeded];
}
#pragma mark  更新线的位置
-(void)updateTopLine{
    [self addSubview:self.topSeparatorView];
    
       [[self topSeparatorView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(self.topLineEdgeInsets.left);
        make.top.equalTo(self).with.offset([self topLineEdgeInsets].top);
        make.right.equalTo(self).with.offset([self topLineEdgeInsets].right);
        make.height.mas_equalTo(lineHeight);
    }];

   
}

-(void)updateBottomLine{
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(self.bottomLineEdgeInsets.left, self.bounds.size.height+self.bottomLineEdgeInsets.bottom-lineHeight)];
//    
//    [path addLineToPoint:CGPointMake(self.bounds.size.width+self.bottomLineEdgeInsets.right , self.bounds.size.height+self.bottomLineEdgeInsets.bottom-lineHeight)];
//    self.bottomSeparatorLayer.path = path.CGPath;
    [self addSubview:self.bottomSeparatorView];
    [[self bottomSeparatorView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(self.bottomLineEdgeInsets.left);
        make.bottom.equalTo(self).with.offset([self bottomLineEdgeInsets].bottom);
        make.right.equalTo(self).with.offset([self bottomLineEdgeInsets].right);
        make.height.mas_equalTo(lineHeight);
    }];

//    self.bottomSeparatorView.frame = CGRectMake(self.bottomLineEdgeInsets.left,self.bounds.size.height+self.bottomLineEdgeInsets.bottom-lineHeight,  self.bounds.size.width+self.bottomLineEdgeInsets.right - self.bottomLineEdgeInsets.left, lineHeight);
}

-(void)updateLeftLine{
//    UIBezierPath *path = [UIBezierPath bezierPath];
    [self addSubview:self.bottomSeparatorView];
   
    ///上面有线时，防止线重叠，流出线的粗细
    CGFloat y = 0;
    CGFloat bottomOffSet = 0;
    if (self.topLineShow) {
        y =self.leftLineEdgeInsets.top+lineHeight;
       
    }else{
        y =self.leftLineEdgeInsets.top;
        
    }
    ///下面有线时，防止线重叠，流出线的粗细
    if (self.bottomLineShow) {
        bottomOffSet = self.leftLineEdgeInsets.bottom-lineHeight;
      
    }else{
        bottomOffSet = self.leftLineEdgeInsets.bottom;
      
    }
[[self leftSeparatorView] mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).with.offset(self.leftLineEdgeInsets.left);
     make.top.equalTo(self).with.offset(y);
     make.bottom.equalTo(self).with.offset(bottomOffSet);
    make.width.mas_equalTo(lineHeight);
}];
    
   
    
}

-(void)updateRightLine{
    
    [self addSubview:self.rightSeparatorView];
    
    ///上面有线时，防止线重叠，流出线的粗细
    CGFloat y = 0;
    CGFloat bottomOffSet = 0;
    if (self.topLineShow) {
        y =self.rightLineEdgeInsets.top+lineHeight;
        
    }else{
        y =self.rightLineEdgeInsets.top;
        
    }
    ///下面有线时，防止线重叠，流出线的粗细
    if (self.bottomLineShow) {
        bottomOffSet = self.rightLineEdgeInsets.bottom-lineHeight;
        
    }else{
        bottomOffSet = self.rightLineEdgeInsets.bottom;
        
    }
    [[self rightSeparatorView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(self.rightLineEdgeInsets.right);
        make.top.equalTo(self).with.offset(y);
        make.bottom.equalTo(self).with.offset(bottomOffSet);
        make.width.mas_equalTo(lineHeight);
    }];

//    UIBezierPath *path = [UIBezierPath bezierPath];
//     ///上面有线时，防止线重叠，流出线的粗细
//    if (self.topLineShow) {
//        [path moveToPoint:CGPointMake(self.rightLineEdgeInsets.right+self.bounds.size.width - lineHeight/2, self.rightLineEdgeInsets.top+lineHeight)];
//    }else{
//        [path moveToPoint:CGPointMake(self.rightLineEdgeInsets.right+self.bounds.size.width - lineHeight/2,  self.rightLineEdgeInsets.top)];
//    }
//     ///下面有线时，防止线重叠，流出线的粗细
//    if (self.bottomLineShow) {
//        
//        [path moveToPoint:CGPointMake(self.rightLineEdgeInsets.right+self.bounds.size.width-lineHeight/2, self.rightLineEdgeInsets.bottom+self.bounds.size.height-lineHeight)];
//    }else{
//        [path moveToPoint:CGPointMake(self.rightLineEdgeInsets.right+self.bounds.size.width-lineHeight/2, self.rightLineEdgeInsets.bottom+self.bounds.size.height)];
//    }
//
//       self.rightSeparatorLayer.path = path.CGPath;
}


#pragma mark - Setter
//- (void)setHorizontalMargin:(CGFloat)horizontalMargin {
//    _horizontalMargin = horizontalMargin;
//    
//    [self updateFrame];
//}
//
//#pragma mark - Getter


-(void)setTopLineShow:(BOOL)topLineShow{
    objc_setAssociatedObject(self, topLineShowKey,[NSNumber numberWithBool: topLineShow] , OBJC_ASSOCIATION_ASSIGN);
    
}

-(BOOL)topLineShow{
    return [objc_getAssociatedObject(self, topLineShowKey) boolValue];
    
}

-(void)setLeftLineShow:(BOOL)leftLineShow{
    objc_setAssociatedObject(self, leftLineShowKey,[NSNumber numberWithBool: leftLineShow] , OBJC_ASSOCIATION_ASSIGN);
    
}

-(BOOL)leftLineShow{
    return [objc_getAssociatedObject(self, leftLineShowKey) boolValue];
    
}
-(void)setRightLineShow:(BOOL)rightLineShow{
    objc_setAssociatedObject(self, rightLineShowKey,[NSNumber numberWithBool: rightLineShow] , OBJC_ASSOCIATION_ASSIGN);
    
}

-(BOOL)rightLineShow{
    return [objc_getAssociatedObject(self, rightLineShowKey) boolValue];
    
}
-(void)setBottomLineShow:(BOOL)bottomLineShow{
    objc_setAssociatedObject(self, bottomLineShowKey,[NSNumber numberWithBool: bottomLineShow] , OBJC_ASSOCIATION_ASSIGN);
    
}

-(BOOL)bottomLineShow{
    return [objc_getAssociatedObject(self, bottomLineShowKey) boolValue];
    
}
-(void)setTopLineEdgeInsets:(UIEdgeInsets)edgeInsets{
    objc_setAssociatedObject(self, topLineEdgeInsetsKey,[NSValue value:&edgeInsets withObjCType:@encode(UIEdgeInsets)] , OBJC_ASSOCIATION_RETAIN);
   
}
-(UIEdgeInsets)topLineEdgeInsets{
    NSValue*value = objc_getAssociatedObject(self, topLineEdgeInsetsKey);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return edgeInsets;
}
///设置左边的线UIEdgeInsets
-(void)setLeftLineEdgeInsets:(UIEdgeInsets)edgeInsets{
    objc_setAssociatedObject(self, leftLineEdgeInsetsKey,[NSValue value:&edgeInsets withObjCType:@encode(UIEdgeInsets)] , OBJC_ASSOCIATION_RETAIN);
}
-(UIEdgeInsets)leftLineEdgeInsets{
    NSValue*value = objc_getAssociatedObject(self, leftLineEdgeInsetsKey);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return edgeInsets;
}
///设置右边的线UIEdgeInsets
-(void)setRightLineEdgeInsets:(UIEdgeInsets)edgeInsets{
    objc_setAssociatedObject(self, rightLineEdgeInsetsKey,[NSValue value:&edgeInsets withObjCType:@encode(UIEdgeInsets)] , OBJC_ASSOCIATION_RETAIN);
}
-(UIEdgeInsets)rightLineEdgeInsets{
    NSValue*value = objc_getAssociatedObject(self, rightLineEdgeInsetsKey);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return edgeInsets;
}
///设置下面的线UIEdgeInsets
-(void)setBottomLineEdgeInsets:(UIEdgeInsets)edgeInsets{
    objc_setAssociatedObject(self, bottomLineEdgeInsetsKey,[NSValue value:&edgeInsets withObjCType:@encode(UIEdgeInsets)] , OBJC_ASSOCIATION_RETAIN);
    
}
-(UIEdgeInsets)bottomLineEdgeInsets{
    NSValue*value = objc_getAssociatedObject(self, bottomLineEdgeInsetsKey);
    UIEdgeInsets edgeInsets;
    [value getValue:&edgeInsets];
    return edgeInsets;
}
-(void)setTopSeparatorView:(UIView *)topSeparatorView{
    objc_setAssociatedObject(self, topSeparatorViewKey,topSeparatorView , OBJC_ASSOCIATION_RETAIN);
    
}

-(UIView*)topSeparatorView{
    UIView *view =objc_getAssociatedObject(self, topSeparatorViewKey);
    if (!view) {
        view = [[UIView alloc]init];
        view.backgroundColor = BlackColorE3E3E3;
        [ self setTopSeparatorView:view ];
    }
    
    
    return view;
}



-(void)setRightSeparatorView:(UIView *)rightSeparatorView{
    objc_setAssociatedObject(self, rightSeparatorViewKey,rightSeparatorView , OBJC_ASSOCIATION_RETAIN);
    
}

-(UIView*)rightSeparatorView{
    UIView *view =objc_getAssociatedObject(self, rightSeparatorViewKey);
    if (!view) {
        view = [[UIView alloc]init];
        view.backgroundColor = BlackColorE3E3E3;
        [ self setRightSeparatorView:view ];
    }
    
    
    return view;
}

-(void)setLeftSeparatorView:(UIView *)leftSeparatorView{
    objc_setAssociatedObject(self, leftSeparatorViewKey,leftSeparatorView , OBJC_ASSOCIATION_RETAIN);
    
}

-(UIView*)leftSeparatorView{
    UIView *view =objc_getAssociatedObject(self, leftSeparatorViewKey);
    if (!view) {
        view = [[UIView alloc]init];
        view.backgroundColor = BlackColorE3E3E3;
        [ self setLeftSeparatorView:view ];
    }
    
    
    return view;
}

-(void)setBottomSeparatorView:(UIView *)bottomSeparatorLineView{
    objc_setAssociatedObject(self, bottomSeparatorViewKey,bottomSeparatorLineView , OBJC_ASSOCIATION_RETAIN);
    
}

-(UIView*)bottomSeparatorView{
   UIView*bottomSeparatorView =objc_getAssociatedObject(self, bottomSeparatorViewKey);
    if (!bottomSeparatorView) {
        bottomSeparatorView = [[UIView alloc]init];
        bottomSeparatorView.backgroundColor = BlackColorE3E3E3;
        [ self setBottomSeparatorView:bottomSeparatorView ];
    }
    
    
    return bottomSeparatorView;
}

@end
