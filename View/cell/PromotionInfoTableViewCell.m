//
//  PromotionInfoTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionInfoTableViewCell.h"


@interface PromotionInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *shopType;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation PromotionInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(PromotionDearInfoModel *)model Art:(PromotionArtInfoModel *) art{
    
    self.title.text = art.title;
    self.shopName.text = model.shortname;
    self.shopType.titleLabel.text = @"";
    [self.shopType setBackgroundImage:[UIImage imageNamed:@"4s"] forState:UIControlStateNormal];
    // 文字变色
    NSString *info = [NSString stringWithFormat:@"还有%@天 结束",art.days];
    
    NSMutableAttributedString *ssa = [[NSMutableAttributedString alloc] initWithString:info];
    
    [ssa addAttribute:NSForegroundColorAttributeName value:RedColorFF2525  range:NSMakeRange(2,art.days.length)];
    
    self.time.attributedText = ssa;

}

@end
