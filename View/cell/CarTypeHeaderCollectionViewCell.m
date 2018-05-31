//
//  CarTypeHeaderCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarTypeHeaderCollectionViewCell.h"

@implementation CarTypeHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageViewTapGesture = [[UITapGestureRecognizer alloc]init];
    [self.headerImageView addGestureRecognizer:self.headerImageViewTapGesture];
    [self.askForPriceButton setNormalAskForPriceButton];
    self.lineView.backgroundColor = BlackColorE3E3E3;
    self.lineViewHeightConstraint.constant = lineHeight;
    // Initialization code
    
    
    self.smallImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_picture_small"]];
    [self.headerImageView addSubview:self.smallImage];
    [self.smallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView.mas_right).offset(-4);
        make.bottom.equalTo(self.headerImageView.mas_bottom).offset(-4);
        make.height.with.mas_equalTo(9);
    }];
}

@end
