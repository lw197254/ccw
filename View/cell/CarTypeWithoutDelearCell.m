//
//  CarTypeWithoutDelearCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/2/24.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarTypeWithoutDelearCell.h"

@implementation CarTypeWithoutDelearCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configUI];
    // Initialization code
}
-(void)configUI{
    self.backgroundColor = [UIColor whiteColor];
    UIView*view = [[UIView alloc]init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        
    }];
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"没有数据cry.png"]];
    [view addSubview:_imageView];
    
    
    _titleLabel = [Tool createLabelWithTitle:@"" textColor: BlackColorC9C8C8 tag:0];
    _titleLabel.font =FontOfSize(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(view);
        
        
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_titleLabel.mas_top).with.offset(-5);
        make.top.centerX.equalTo(view);
    }];
    
}

@end
