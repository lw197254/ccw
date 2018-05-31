//
//  NormalCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 16/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "NormalCollectionViewCell.h"
#import "BrowseKouBeiArtModel.h"

@implementation NormalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code

}

-(void)setData:(PicShowModel *)model{
    
    [self.image setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    NSArray *browse = [BrowseKouBeiArtModel findByColumn:@"id" value:model.id];
    if ([browse count]) {
        model.isRead = isread;
    }
    
    if ([model.isRead isEqualToString:isread]) {
        self.title.textColor = BlackColor999999;
    }else{
        self.title.textColor = BlackColor333333;
    }
    
    self.title.text = model.title;
    self.views.text = [NSString stringWithFormat:@"%@",model.click];
    self.time.text = model.inputtime;
    NSLog(@"%@",self.time.font.fontName);
}

@end
