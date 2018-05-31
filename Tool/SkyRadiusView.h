//
//  SkyRadiusView.h
//  SkyRadiusView
//
//  Created by skytoup on 15/8/11.
//  Copyright (c) 2015年 skytoup. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SkyRadiusView : UIView

///使用了该类就无法使用
@property (assign, nonatomic) IBInspectable BOOL topRightRadius;
@property (assign, nonatomic) IBInspectable BOOL topLeftRadius;
@property (assign, nonatomic) IBInspectable BOOL bottomRightRadius;
@property (assign, nonatomic) IBInspectable BOOL bottomLeftRadius;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign,nonatomic) IBInspectable BOOL    multiToBounds;
@property (assign,nonatomic) IBInspectable CGFloat borderWidth;
@property (strong,nonatomic) IBInspectable UIColor   *borderColor;
@end