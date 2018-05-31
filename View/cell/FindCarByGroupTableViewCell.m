//
//  FindCarByGroupTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FindCarByGroupTableViewCell.h"

@implementation FindCarByGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.headerImageView.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    
    self.headerImageView.clipsToBounds = YES;
    self.seperateLine.backgroundColor = BlackColorE3E3E3;
    self.seperateLineHeightConstaint.constant = lineHeight;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
