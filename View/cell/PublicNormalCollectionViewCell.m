//
//  PublicNormalCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/4/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicNormalCollectionViewCell.h"
#import "BrowseKouBeiArtModel.h"

@interface PublicNormalCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *publicuser;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *reader;

@end

@implementation PublicNormalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.img setContentMode:UIViewContentModeScaleAspectFill];
    self.img.clipsToBounds = YES;    // Initialization code
}


-(void)setData:(PicShowModel *)model{
    
    [self.img setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    self.reader.text = [NSString stringWithFormat:@"%@人阅读",model.click];
    self.time.text = model.inputtime;
    self.time.hidden = YES;
    self.publicuser.text = model.authorName;
    NSLog(@"%@",self.publicuser.font.fontName);
    
}

@end
