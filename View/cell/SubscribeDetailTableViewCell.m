//
//  SubscribeDetailTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/4/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SubscribeDetailTableViewCell.h"



@interface SubscribeDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reader;

@end

@implementation SubscribeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.img.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    self.img.clipsToBounds = YES;
    // Initialization code
}


-(void)setData:(PicShowModel *)model{
    
    [self.img setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    [self.img mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kwidth-50)/3);
    }];
    
    if ([model.isRead isEqualToString:isread]) {
        self.title.textColor = BlackColor999999;
    }else{
        self.title.textColor = BlackColor333333;
    }
    
    self.title.text = model.title;
    self.reader.text = [NSString stringWithFormat:@"%@人阅读",model.click];
    self.time.text = model.inputtime;
   
    
    
}
@end
