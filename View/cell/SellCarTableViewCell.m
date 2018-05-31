//
//  SellCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SellCarTableViewCell.h"

@implementation SellCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.searchPrice setNormalAskForPriceButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
