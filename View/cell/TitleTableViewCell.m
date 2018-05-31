//
//  TitleTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TitleTableViewCell.h"

@implementation TitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    [self.titleButton setBackgroundImage:[UIImage imageWithColor:WhiteColorF6F6F6 size:self.titleButton.size] forState:UIControlStateNormal];
    [self.titleButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:self.titleButton.size] forState:UIControlStateSelected];
    
    //保证所有touch事件button的highlighted属性为NO,即可去除高亮效果
    [self.titleButton addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}


@end
