//
//  DealerTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerTableViewCell.h"

@implementation DealerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line1.backgroundColor = BlackColorE3E3E3;
    self.line2.backgroundColor = BlackColorE3E3E3;
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
