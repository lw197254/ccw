//
//  ButtonUIView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ButtonUIView.h"

@implementation ButtonUIView

-(instancetype)init{
    if(self = [super init]){
        self.imageView = [[UIImageView alloc]init];
        [self addSubview:self.imageView];
        
       
        
        self.label = [[UILabel alloc] init];
        self.label.textColor =BlackColor333333;
        self.label.font =FontOfSize(13);
        [self addSubview:self.label];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(self).offset(28);
            make.centerX.equalTo(self);
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(6);
            make.centerX.equalTo(self);
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
