//
//  RecommendTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.img.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    self.img.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
