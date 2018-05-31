//
//  ArtPopViewCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ArtPopViewCollectionViewCell.h"
#import "ShareModel.h"

@interface ArtPopViewCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation ArtPopViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(ShareModel *)model{
    self.label.text = model.name;
    [self.image setImage:[UIImage imageNamed:model.imageName]];
}

@end
