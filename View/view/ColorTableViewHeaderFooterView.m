//
//  ColorTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/2/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ColorTableViewHeaderFooterView.h"

@implementation ColorTableViewHeaderFooterView


-(instancetype)init{
    if(self = [super init]){
        self.label = [[UILabel alloc] init];
        self.label.textColor = BlackColor333333;
        self.label.font= FontOfSize(14);
        [self addSubview: self.label];
        
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
        }];
        
        
        [self.contentView setBackgroundColor:BlackColorF8F8F8];
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
