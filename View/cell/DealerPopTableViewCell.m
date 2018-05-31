//
//  DealerPopTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerPopTableViewCell.h"
@interface DealerPopTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *pricedown;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
@implementation DealerPopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.button setNormalAskForPriceButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)click:(id)sender {
}

@end
