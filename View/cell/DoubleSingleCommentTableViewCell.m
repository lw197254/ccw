//
//  DoubleSingleCommentTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/9/25.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "DoubleSingleCommentTableViewCell.h"
@interface DoubleSingleCommentTableViewCell()

@property(nonatomic,copy)CommiteModel *model;

@end
@implementation DoubleSingleCommentTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 48, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setMessageModel:(CommiteModel *)model{
    
    self.model = model;
    
    [self.headimage setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"我的默认头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    self.headimage.layer.cornerRadius=self.headimage.frame.size.width/2;//裁成圆角
    self.headimage.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    
    self.name.text = model.username;
    self.content.text = [NSString stringWithFormat:@"回复%@: %@",model.reusername,model.content];
    self.time.text = model.formataddtime;
    
    NSString *info = [model.reusername stringByAppendingString:@": "];
    info = [info stringByAppendingString:model.recontent];
    
    self.recontent.text = info;
    
}

-(void)setMessageModelMessageCenter:(CommiteModel *)model{
    
    self.model = model;
    
    [self.headimage setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"我的默认头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    self.headimage.layer.cornerRadius=self.headimage.frame.size.width/2;//裁成圆角
    self.headimage.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    
    self.name.text = model.username;
    self.content.text = [NSString stringWithFormat:@"回复%@:%@",model.reusername,model.content];
    self.time.text = model.formataddtime;
    
    NSString *info = [model.reusername stringByAppendingString:@":"];
    info = [info stringByAppendingString:model.recontent];
    
    self.recontent.text = info;
}


-(void)setMessageModelIndex:(NSInteger)index{
    [self.commite setTag:index];
}

@end
