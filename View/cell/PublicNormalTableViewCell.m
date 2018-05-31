//
//  PublicNormalTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicNormalTableViewCell.h"

@interface PublicNormalTableViewCell()
 

@end


@implementation PublicNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.img.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    self.img.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(InfoArticleModel *)model{
    [self.img setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    if ([model.isRead isEqualToString:isread]) {
        self.title.textColor = BlackColor999999;
    }else{
        self.title.textColor = BlackColor333333;
    }
    self.title.text = model.title;
    self.views.text = [NSString stringWithFormat:@"%@人阅读",model.click];
    self.publicuser.text = model.authorName;

}

@end
