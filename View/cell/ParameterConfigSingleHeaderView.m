//
//  ParameterConfigSingleHeaderView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParameterConfigSingleHeaderView.h"
#import "LineView.h"
@implementation ParameterConfigSingleHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    self.titleLabel = [Tool createLabelWithTitle:@"" textColor:BlackColor666666 tag:0];
    self.titleLabel.font = FontOfSize(12);
    [self.contentView addSubview: self.titleLabel];
   
    UILabel*subTitleLabel = [Tool createLabelWithTitle:@"●标配  ○选配  - 无" textColor:BlackColor666666 tag:0];
    subTitleLabel.font = FontOfSize(12);
    [self.contentView addSubview: subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    LineView*line = [[LineView alloc]init];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(140);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(lineHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(line.mas_left);
    }];
    
    LineView*topLine = [[LineView alloc]init];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
       
        make.height.mas_equalTo(lineHeight);
    }];

    LineView*bottomLine = [[LineView alloc]init];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(lineHeight);
    }];

}
@end
