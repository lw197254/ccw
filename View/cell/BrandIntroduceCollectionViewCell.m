//
//  BrandIntroduceCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/9/20.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "BrandIntroduceCollectionViewCell.h"

@implementation BrandIntroduceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.image.clipsToBounds =YES;
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.image.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
}

@end
