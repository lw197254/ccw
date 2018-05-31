//
//  ReduceTypeTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/25.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ReduceTypeTableViewCell.h"

@implementation ReduceTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.titleButton.selected = selected;
    // Configure the view for the selected state
}

@end
