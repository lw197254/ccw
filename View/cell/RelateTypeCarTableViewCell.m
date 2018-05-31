//
//  RelateTypeCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "RelateTypeCarTableViewCell.h"

@interface RelateTypeCarTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *koubei;
@property (weak, nonatomic) IBOutlet UILabel *price;


@end
@implementation RelateTypeCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(InfoRelateTypesModel *)model{
    [self.imageView setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.title.text = model.name;
    self.price.text = model.zhidaoprice;
    if(model.score.length>0){
        self.koubei.text = [NSString stringWithFormat:@"口碑%@",model.score];
    }else{
          self.koubei.text = @"暂无口碑";
    }
}

@end
