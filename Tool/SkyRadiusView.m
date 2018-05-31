//
//  SkyRadiusView.m
//  SkyRadiusView
//
//  Created by skytoup on 15/8/11.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import "SkyRadiusView.h"

@interface SkyRadiusView ()
@property (strong, nonatomic) UIColor *bgColor;

@end

@implementation SkyRadiusView

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _bgColor = backgroundColor;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    UIColor *color = [UIColor redColor];
//    [color set]; //设置线条颜色
//    
//    UIBezierPath* aPath = [UIBezierPath bezierPath];
//    aPath.lineWidth = 5.0;
//    
//    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
//    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
//    
//    // Set the starting point of the shape.
//    [aPath moveToPoint:CGPointMake(100.0, 0.0)];
//    
//    // Draw the lines
//    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];
//    [aPath addLineToPoint:CGPointMake(160, 140)];
//    [aPath addLineToPoint:CGPointMake(40.0, 140)];
//    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];
//    [aPath closePath];//第五条线通过调用closePath方法得到的
//    
//    [aPath stroke];//Draws line 根据坐标点连线
//    [super drawRect:rect];
//    if (self.multiToBounds) {
////        self.layer.masksToBounds = NO;
////        self.layer.cornerRadius = 0;
////        self.layer.borderWidth = 0;
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        // 添加路径[1条点(100,100)到点(200,100)的线段]到path
//        [path moveToPoint:CGPointMake(100 , 100)];
//        [path addLineToPoint:CGPointMake(200, 100)];
//        // 将path绘制出来
//        [path stroke];
////        UIBezierPath *path = [UIBezierPath bezierPath];
////        // 添加圆到path
////        [path addArcWithCenter:self.center radius:100.0 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
////        // 设置描边宽度（为了让描边看上去更清楚）
////        [path setLineWidth:5.0];
////        //设置颜色（颜色设置也可以放在最上面，只要在绘制前都可以）
////        [[UIColor blueColor] setStroke];
////        [[UIColor redColor] setFill];
////        [path moveToPoint:CGPointMake(100 , 100)];
////        [path addLineToPoint:CGPointMake(200, 100)];
////        // 描边和填充
////        [path stroke];
////        [path fill];
////        
////                CGContextRef c = UIGraphicsGetCurrentContext();
////        
////                CGContextAddPath(c, path.CGPath);
////                CGContextClosePath(c);
////                CGContextClip(c);
////                CGContextAddRect(c, rect);
////                CGContextSetFillColorWithColor(c, _bgColor.CGColor);
////                CGContextFillPath(c);
//
    if (self.multiToBounds) {
                self.layer.masksToBounds = NO;
                self.layer.cornerRadius = 0;
                self.layer.borderWidth = 0;
        UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(_bottomLeftRadius?UIRectCornerBottomLeft:0)|(_bottomRightRadius?UIRectCornerBottomRight:0)|(_topLeftRadius?UIRectCornerTopLeft:0)|(_topRightRadius?UIRectCornerTopRight:0) cornerRadii:CGSizeMake(_cornerRadius, 0.f)];
        [p setLineWidth: self.borderWidth];
        [self.borderColor set];
    
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextAddPath(c, p.CGPath);
        CGContextClosePath(c);
        CGContextClip(c);
        CGContextAddRect(c, rect);
        CGContextSetFillColorWithColor(c, _bgColor.CGColor);
        CGContextFillPath(c);
    [p stroke];
           }else{
        
    }
    
}

@end
