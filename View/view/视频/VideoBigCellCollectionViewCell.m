//
//  VideoBigCellCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoBigCellCollectionViewCell.h"

@implementation VideoBigCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
}

-(void)setVideoModel:(VideoModel *)model{
    
    self.des.text = model.des;
    self.title.text = model.title;
    
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:model.big_img_url]  placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
     [self layoutIfNeeded];
}

@end
