//
//  PromotionTitleHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionTitleHeaderFooterView.h"

@implementation PromotionTitleHeaderFooterView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.label = [[UILabel alloc] init];
        self.label.font =FontOfSize(12);
        self.label.textColor = BlackColor333333;
        
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
                
    }
    return self;
}


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc] init];
        self.label.font =FontOfSize(12);
        self.label.textColor = BlackColor333333;
        
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
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
