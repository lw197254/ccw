//
//  XunjiaTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "XunjiaTableViewCell.h"

@implementation XunjiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.headerImageView.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    self.headerImageView.clipsToBounds = YES;
    [self.askPriceButton setNormalAskForPriceButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
