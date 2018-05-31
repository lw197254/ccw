//
//  TagsHeaderView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TagsHeaderView.h"

@implementation TagsHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
   
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top).mas_offset(25);
        }];
    }
    return self;
}



-(void)setLabelText:(NSString *)text Color:(UIColor *)color{
    self.label.text = text;
    self.label.textColor = color;
}


-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [_label setBackgroundColor:[UIColor whiteColor]];
    }
    return _label;
}


@end
