//
//  ConditionSelectCarNormalCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarNormalCollectionViewCell.h"

@implementation ConditionSelectCarNormalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [UIImage imageNamed:@"矩形灰线.png"];
    UIImage*highLightImage = [UIImage imageNamed:@"bnt_xundijia_d.png"];
    image  = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    highLightImage = [highLightImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.titleButton.userInteractionEnabled = NO;
    [self.titleButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.titleButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    [self.titleButton setBackgroundImage:highLightImage forState:UIControlStateSelected];
    // Initialization code
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleButton.selected = selected;
  
}
@end
