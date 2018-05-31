//
//  DealerInfoTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/28.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "DealerInfoTableViewCell.h"

@implementation DealerInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.line1.backgroundColor = BlackColorE3E3E3;
//    self.line2.backgroundColor = BlackColorE3E3E3;
    self.shoptype.layer.borderColor = BlackColorBBBBBB.CGColor;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
