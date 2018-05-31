//
//  SelectCarTypeTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SelectCarTypeTableViewCell.h"

@implementation SelectCarTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDisable:(BOOL)disable{
    if (_disable != disable) {
        _disable = disable;
        if (_disable) {
            self.titleLabel.textColor = BlackColorCCCCCC;
        }else{
            self.titleLabel.textColor = BlackColor333333;
        }
    }
}
@end
