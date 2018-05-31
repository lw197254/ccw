//
//  BuyCarCalculatorRightListTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BuyCarCalculatorRightListTableViewCell.h"

@implementation BuyCarCalculatorRightListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.titleButton.selected = selected;
    // Configure the view for the selected state
}

@end
