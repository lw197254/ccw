//
//  TablePublicHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "TablePublicHeaderFooterView.h"

@implementation TablePublicHeaderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *tab1 = [[UIView alloc]init];
        [self addSubview:tab1];
        
        
        [tab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self);
            make.width.mas_equalTo(kwidth/2);
        }];
        
        
        UIView *tab2 = [[UIView alloc]init];
        
        [tab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.width.mas_equalTo(kwidth/2);
        }];
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
