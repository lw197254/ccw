//
//  CustomAnnotationView.m
//  12123
//
//  Created by 刘伟 on 2016/10/21.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "CustomPinAnnotationView.h"

@implementation CustomPinAnnotationView
{
    UILabel*_label;
}
-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        _label = [Tool createLabelWithTitle:@"" textColor:[UIColor whiteColor] tag:0];
        _label.font = FontOfSize(9);
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).with.offset(-2);
        }];
    }
    return self;
}
-(void)setIndexString:(NSString *)indexString{
    if (![_indexString isEqual:indexString]) {
        _label.text = indexString;
        _indexString = indexString;
    }
   

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
