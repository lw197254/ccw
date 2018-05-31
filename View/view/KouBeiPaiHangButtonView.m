//
//  KouBeiPaiHangButtonView.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/19.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "KouBeiPaiHangButtonView.h"

@interface KouBeiPaiHangButtonView()

@property (weak, nonatomic) IBOutlet UIView *view;
@end
@implementation KouBeiPaiHangButtonView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        
    }
    return self;
}


@end
