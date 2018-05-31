//
//  CompareKoubeiTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareKoubeiTableViewCell.h"
#import "CompareKoubeiView.h"
@implementation CompareKoubeiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
