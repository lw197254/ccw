//
//  ConditionSelectCarLevelCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarLevelCollectionViewCell.h"

@implementation ConditionSelectCarLevelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [UIImage imageNamed:@"矩形灰线.png"];
    UIImage*highLightImage = [UIImage imageNamed:@"bnt_xundijia_d.png"];
    image  = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    highLightImage = [highLightImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    self.selectButton.userInteractionEnabled = NO;
////    [self.selectButton setBackgroundImage:image forState:UIControlStateNormal];
//    [self.selectButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
//    [self.selectButton setBackgroundImage:highLightImage forState:UIControlStateSelected];
    // Initialization code
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleButton.selected = selected;
    self.imageView.highlighted = selected;
    
}
@end
