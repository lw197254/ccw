//
//  InfoDetailFont.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "InfoDetailFont.h"
@implementation InfoDetailFont
@synthesize fontSize = _fontSize;
+(instancetype)shareInstance{
    static InfoDetailFont*instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
      
        
        instance = [[InfoDetailFont alloc]init];
        NSNumber*number= [[NSUserDefaults standardUserDefaults]objectForKey:ArticleFont];
       
        instance.fontStyle = [instance fontStyleFromSize:instance.fontSize];
       
           });
    return instance;

}
-(void)setFontStyle:(ArticleFontStyle)fontStyle{
    if (_fontStyle !=fontStyle) {
        _fontStyle = fontStyle;
        _fontSize = [self fontSizeFromStyle:fontStyle];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:_fontSize] forKey:ArticleFont];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}
-(NSInteger)fontSize{
    if (_fontSize==0) {
        _fontSize = [self fontSizeFromStyle:ArticleFontStyleMiddle];
    }
    return _fontSize;
}
///tag即为字号
//超大 44/2
//大 40/2;
//中 36/2;
//小 32/2;

//+(void)setFont:(ArticleFontStyle)fontStyle{
//    
//    
//    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:[InfoDetailFont fontSizeFromStyle:fontStyle] ] forKey:ArticleFont];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//+(ArticleFontStyle)fontStyle{
//   
//    
//  return [InfoDetailFont fontStyleFromSize: [InfoDetailFont fontSize]];
//
//}
//+(NSInteger)fontSize{
//   NSNumber*number= [[NSUserDefaults standardUserDefaults]objectForKey:ArticleFont];
//    if (number.isNotEmpty) {
//         return [number integerValue];
//    }else{
//        return 36/2;
//    }
//    
//}
-(NSInteger)fontSizeFromStyle:(ArticleFontStyle)style{
    if (style== ArticleFontStyleSmall) {
        return 32/2;
    }else if (style== ArticleFontStyleLarge) {
        return 40/2;
    }else if (style== ArticleFontStyleVeryLarge) {
        return 44/2;
    }else{
        return 36/2;
    }

}
-(ArticleFontStyle)fontStyleFromSize:(NSInteger)size{
    if (size== 32/2) {
        return ArticleFontStyleSmall;
    }else if (size== 40/2 ) {
        return ArticleFontStyleLarge;
    }else if (size== 44/2 ) {
        return ArticleFontStyleVeryLarge;
    }else{
        return ArticleFontStyleMiddle;
    }
    
}
@end
