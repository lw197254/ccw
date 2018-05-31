//
//  BrandTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "BrandMutableTableViewCell.h"

@implementation BrandMutableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectButton.selected = selected;
    
    // Configure the view for the selected state
}

@end
