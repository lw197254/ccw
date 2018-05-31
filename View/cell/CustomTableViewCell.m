//
//  CustomTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected!=self.selected) {
        if (selected) {
            self.textLabel.textColor = BlueColor447FF5;
        }else{
            self.textLabel.textColor = BlackColor333333;
        }
    }
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

@end
