//
//  ParameterAskPriceCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParameterAskPriceCollectionViewCell.h"

@implementation ParameterAskPriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.askPriceButton setBackgroundImage:[UIImage imageWithColor:BlueColor447FF5] forState:UIControlStateNormal];
    [self.askPriceButton setBackgroundImage:[UIImage imageWithColor:BlueColorA9C6FF] forState:UIControlStateDisabled];
    // Initialization code
}

@end
