//
//  TableTopViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "TableTopViewHeaderFooterView.h"

@implementation TableTopViewHeaderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.image = [[UIImageView alloc]init];
        [self addSubview:self.image];
    
        self.labelTitle = [[UILabel alloc]init];
        [self addSubview:self.labelTitle];
        self.views = [[UILabel alloc]init];
        [self addSubview:self.views];
        self.soure = [[UILabel alloc]init];
        [self addSubview:self.soure];
        self.author = [[UILabel alloc]init];
        [self addSubview:self.author];
        self.time = [[UILabel alloc]init];
        [self addSubview:self.time];
        
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom);
            make.bottom.equalTo(self).offset(-20);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        
        [self.views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom);
            make.bottom.equalTo(self).offset(-20);
            make.left.equalTo(self.image.mas_right).offset(5);
            make.height.mas_equalTo(12);
        }];
        
        [self.soure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom);
            make.bottom.equalTo(self).offset(-20);
            make.left.equalTo(self.views.mas_right).offset(15);
            make.height.mas_equalTo(12);
        }];
        
        [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom);
            make.bottom.equalTo(self).offset(-20);
            make.left.equalTo(self.soure.mas_right).offset(15);
            make.height.mas_equalTo(12);
        }];
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTitle.mas_bottom);
            make.bottom.equalTo(self).offset(-20);
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(12);
        }];
        
        //[self setline:self];
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
