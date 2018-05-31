//
//  RanklistTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/29.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "RanklistTableViewCell.h"

@implementation RanklistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.clipsToBounds =YES;
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.image.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
