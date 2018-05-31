//
//  PromotionImageTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionImageTableViewCell.h"

@interface PromotionImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *image2;

@end

@implementation PromotionImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSArray<PromotionPrcinfoModel> *) model Count:(NSInteger) row{
    int picID = row*2;
    if (model.count>picID) {
        PromotionPrcinfoModel *pic = model[picID];
        [self.image1 setImageWithURL:[NSURL URLWithString:pic.picurl] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    }
    
    if(model.count>picID+1){
        PromotionPrcinfoModel *pic = model[picID+1];
        [self.image2 setImageWithURL:[NSURL URLWithString:pic.picurl] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [self.image1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kwidth-30-20)/2);
        make.height.mas_equalTo(125);
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.image2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kwidth-30-20)/2);
        make.height.mas_equalTo(125);
        make.top.equalTo(self.image1);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}

@end
