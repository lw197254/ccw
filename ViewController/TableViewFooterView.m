//
//  TableViewFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "TableViewFooterView.h"

@implementation TableViewFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.image= [[UIImageView alloc] init];
        [self addSubview:self.image];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
//        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self).offset(5);
//        }];

        
                [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self);
                }];
        
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).offset(5);
            make.centerY.equalTo(self.label);
            make.height.width.mas_equalTo(12);
        }];
        
        self.image.image = [UIImage imageNamed:@"箭头向右蓝"];
        
        [self setTopLine];
       
        
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
