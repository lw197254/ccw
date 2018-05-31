//
//  NewCarForSale2TableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NewCarForSale2TableViewCell.h"

@implementation NewCarForSale2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.clipsToBounds =YES;
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.headImageView.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
