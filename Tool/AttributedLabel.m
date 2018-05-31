//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"

@interface AttributedLabel(){

}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation AttributedLabel
@synthesize attString = _attString;

- (void)setText:(NSString *)text{
   //[super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = nil;
        
        self.attString = [[NSMutableAttributedString alloc] initWithString:text] ;
    }
    self.attributedText = self.attString;
    
    //self.textColor = [UIColor clearColor];
}
-(void)setCharctorSpaceFitLabelSize:(BOOL)charctorSpaceFitLabelSize{
      
    
}
-(void)setCharctorSpacing:(CGFloat)spacing{
    long space = spacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &space);
    [_attString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[_attString length])];
    self.attributedText = self.attString;
}
// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:NSForegroundColorAttributeName
                        value:(id)color
                        range:NSMakeRange(location, length)];
    self.attributedText = self.attString;
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                        value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                       font.pointSize,
                                                       NULL))
                        range:NSMakeRange(location, length)];
     self.attributedText = self.attString;
}
// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:style]
                        range:NSMakeRange(location, length)];
     self.attributedText = self.attString;
}
@end
