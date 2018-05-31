//
//  FindeTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FindeTableViewCell.h"

@implementation FindeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(FindBaseModel *)data{
    [self.image setImageWithURL:[NSURL URLWithString:data.img_url] placeholderImage:[UIImage imageNamed:@"默认图片330_165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.title.text = data.title;
}

@end
