//
//  ZiMeiTiWithThreeImageCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/4/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ZiMeiTiWithThreeImageCollectionViewCell.h"

@implementation ZiMeiTiWithThreeImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageleft.clipsToBounds = YES;
    self.imageleft.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imagemiddle.clipsToBounds = YES;
    self.imagemiddle.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imageright.clipsToBounds = YES;
    self.imageright.contentMode = UIViewContentModeScaleAspectFill;
}

@end
