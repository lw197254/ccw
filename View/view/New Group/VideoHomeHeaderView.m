//
//  VideoHomeHeaderView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoHomeHeaderView.h"

@implementation VideoHomeHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle]loadNibNamed:@"VideoHomeHeaderView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}


@end
