//
//  DealerBigImageTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerBigImageTableViewCell.h"


@interface DealerBigImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation DealerBigImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(PromotionArtInfoModel *)model{
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.title.text = model.title;
    [self.bottomImage setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.3]];
}
@end
