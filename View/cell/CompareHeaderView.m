//
//  CompareHeaderView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareHeaderView.h"

@implementation CompareHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self configUI];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)configUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.left.right.equalTo(self.contentView);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
}
-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [Tool createLabelWithTitle:@"" textColor:BlackColor333333 tag:0];
        _titleLabel.font = FontBlackOfSize(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UILabel*)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [Tool createLabelWithTitle:@"" textColor:BlackColor333333 tag:0];
        _subTitleLabel.font  = FontOfSize(13);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;

}
@end
