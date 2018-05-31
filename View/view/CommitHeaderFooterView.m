//
//  CommitHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/9.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CommitHeaderFooterView.h"

@implementation CommitHeaderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.image= [[UIImageView alloc] init];
        [self addSubview:self.image];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        
        
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(0);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(16);
        }];
        
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.image).offset(11);
        }];
        
    }
    return self;
}

@end
