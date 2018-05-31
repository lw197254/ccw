//
//  ComparePriceTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ComparePriceTableViewCell.h"
#import "ComparePriceView.h"
@implementation ComparePriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self.righPricetView choosePinkColor];
    [self setBottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
