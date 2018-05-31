//
//  CompareListTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/2/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CompareListTableViewCell.h"

@implementation CompareListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectButton.selected = selected;
    self.nameButton.selected = selected;
    
    // Configure the view for the selected state
}

@end
