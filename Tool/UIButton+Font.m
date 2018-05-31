//
//  UIButton+Font.m
//  ColorTest
//
//  Created by 刘伟 on 2017/7/7.
//  Copyright © 2017年 万圣伟业. All rights reserved.
//

#import "UIButton+Font.h"
#import <objc/runtime.h>
@implementation UIButton (Font)
+(void)load{
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        //替换三个方法
        SEL originalSelector = @selector(init);
        SEL originalSelector2 = @selector(initWithFrame:);
        SEL originalSelector3 = @selector(awakeFromNib);
         SEL originalSelector4 = @selector(buttonWithType:);
        SEL swizzledSelector = @selector(YHBaseInit);
        SEL swizzledSelector2 = @selector(YHBaseInitWithFrame:);
        SEL swizzledSelector3 = @selector(YHBaseAwakeFromNib);
        SEL swizzledSelector4 = @selector(YHBaseButtonWithType:);
        
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method originalMethod3 = class_getInstanceMethod(class, originalSelector3);
        Method originalMethod4 = class_getClassMethod([UIButton class ], originalSelector4);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        Method swizzledMethod3 = class_getInstanceMethod(class, swizzledSelector3);
         Method swizzledMethod4 = class_getClassMethod([UIButton class ], swizzledSelector4);
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        BOOL didAddMethod2 =
        class_addMethod(class,
                        originalSelector2,
                        method_getImplementation(swizzledMethod2),
                        method_getTypeEncoding(swizzledMethod2));
        BOOL didAddMethod3 =
        class_addMethod(class,
                        originalSelector3,
                        method_getImplementation(swizzledMethod3),
                        method_getTypeEncoding(swizzledMethod3));
        BOOL didAddMethod4 =
        class_addMethod([UIButton class ],
                        originalSelector4,
                        method_getImplementation(swizzledMethod4),
                        method_getTypeEncoding(swizzledMethod4));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        if (didAddMethod2) {
            class_replaceMethod(class,
                                swizzledSelector2,
                                method_getImplementation(originalMethod2),
                                method_getTypeEncoding(originalMethod2));
        }else {
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
        }
        if (didAddMethod3) {
            class_replaceMethod(class,
                                swizzledSelector3,
                                method_getImplementation(originalMethod3),
                                method_getTypeEncoding(originalMethod3));
        }else {
            method_exchangeImplementations(originalMethod3, swizzledMethod3);
        }
        if (didAddMethod4) {
            class_replaceMethod([UIButton class ],
                                swizzledSelector4,
                                method_getImplementation(originalMethod4),
                                method_getTypeEncoding(originalMethod4));
        }else {
            method_exchangeImplementations(originalMethod4, swizzledMethod4);
        }

    });
    
}

+(instancetype)YHBaseButtonWithType:(UIButtonType)buttonType{
    id instance = [UIButton  YHBaseButtonWithType:buttonType];
    [instance changeFontAndTextColor];
    return instance;
   
}
/**
 *在这些方法中将你的字体名字换进去
 */
- (instancetype)YHBaseInit
{
    id __self = [self YHBaseInit];
    [self changeFontAndTextColor];
    ///PingFangSC-Regular___.SFUIText
    //    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
    ////    if (self.font.pointSize ==15) {
    ////       font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    ////    }else{
    ////        font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
    ////    }
    //
    //    if (font) {
    //        self.font=font;
    //
    //    }
    return __self;
}
-(void)changeFontAndTextColor{
    
    //    NSInteger hexValue = 0x595959;
    //
    //
    //    UIColor *color = [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
    //                                                    green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
    //                                                     blue:((float)(hexValue & 0xFF))/255.0
    //                                                    alpha:1.0];
    //
    //    if([self colorEqulaToColor:self.textColor color2:color]){
    //        self.textColor = LabelTextblackColor;
    //    }
    //
    
    UIFont *font1 = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    if ([self.titleLabel.font.fontName isEqual:font1.fontName]){
        UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
        if (font) {
            self.titleLabel.font=font;
        }
        
        
    }
    
}
-(BOOL)colorEqulaToColor:(UIColor*)color color2:(UIColor*)color2{
    const CGFloat* components1 = CGColorGetComponents(color.CGColor);
    CGFloat red1, green1, blue1, alpha1;
    alpha1 = components1[0];
    red1 = components1[0+1];
    green1 = components1[0+2];
    blue1 = components1[0+3];
    
    const CGFloat* components2 = CGColorGetComponents(color2.CGColor);
    CGFloat red2, green2, blue2, alpha2;
    alpha2 = components2[0];
    red2 = components2[0+1];
    green2 = components2[0+2];
    blue2 = components2[0+3];
    
    
    //向量比较
    float difference = pow( pow((red1 - red2), 2) + pow((green1 - green2), 2) +
                           pow((blue1 - blue2), 2), 0.5 );
    if (difference <0.085) {
        return YES;
    }else{
        return NO;
    }
}
-(instancetype)YHBaseInitWithFrame:(CGRect)rect{
    id __self = [self YHBaseInitWithFrame:rect];
    [self changeFontAndTextColor];
    
    //    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
    ////    if (self.font.pointSize ==15) {
    ////        font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    ////    }else{
    ////        font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
    ////    }
    //    if (font) {
    //        self.font=font;
    //    }
    return __self;
}
-(void)YHBaseAwakeFromNib{
    [self YHBaseAwakeFromNib];
    
    [self changeFontAndTextColor];
    
    //    UIFont * font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
    ////    if (self.font.pointSize ==15) {
    ////        font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    ////    }else{
    ////        font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.font.pointSize];
    ////    }
    //    if (font) {
    //        self.font=font;
    //    }
    
}

@end
