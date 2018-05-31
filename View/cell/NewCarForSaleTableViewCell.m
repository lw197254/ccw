//
//  NewCarForSaleTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "NewCarForSaleTableViewCell.h"

@implementation NewCarForSaleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.clipsToBounds =YES;
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.headImageView.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
