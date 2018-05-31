//
//  PromotionMoreTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionMoreTableViewHeaderFooterView.h"

@implementation PromotionMoreTableViewHeaderFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColorLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setTopLine];
        [self addSubview:self.backgroundColorLabel];
        
        
        self.image= [[UIImageView alloc] init];
        [self addSubview:self.image];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.backgroundColorLabel);
            make.centerX.equalTo(self.backgroundColorLabel).with.offset(-12);
        }];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).offset(5);
            make.centerY.equalTo(self.label);
            make.height.width.mas_equalTo(12);
        }];
        
        
        UIView *bottomLine = [[UIView alloc] init];
        [self addSubview:bottomLine];
        [self.backgroundColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(bottomLine.mas_top);
        }];

        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        bottomLine.backgroundColor= BlackColorF1F1F1;
       
    }
    return self;
}

-(instancetype)init{
    if (self= [super init]) {
         [self setTopLine];
        self.backgroundColorLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:self.backgroundColorLabel];
        
        
        
        self.image= [[UIImageView alloc] init];
        [self addSubview:self.image];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.backgroundColorLabel);
            make.centerX.equalTo(self.backgroundColorLabel).with.offset(-12);
        }];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).offset(5);
            make.centerY.equalTo(self.label);
            make.height.width.mas_equalTo(12);
        }];
        UIView *bottomLine = [[UIView alloc] init];
        [self addSubview:bottomLine];
        [self.backgroundColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(bottomLine.mas_top);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        bottomLine.backgroundColor= BlackColorF1F1F1;
        

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
