//
//  SubscribeTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/4/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SubscribeTableViewCell.h"
#import "SubjectUserModel.h"

@interface SubscribeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation SubscribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSInteger)count array:(NSArray*)array{
    SubjectUserModel *model = array[count];
    
    [self.img setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"pic_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.name.text = model.authorName;
}

@end
