//
//  AskForPriceTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "AskForPriceTableViewCell.h"
@interface AskForPriceTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@end
@implementation AskForPriceTableViewCell

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
