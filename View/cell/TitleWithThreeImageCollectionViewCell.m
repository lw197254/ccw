//
//  TitleWithThreeImageCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 16/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "TitleWithThreeImageCollectionViewCell.h"

@implementation TitleWithThreeImageCollectionViewCell

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
