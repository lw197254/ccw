//
//  DoubleCommentTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "DoubleCommentTableViewCell.h"

#import "HistoryTalksViewController.h"

@interface DoubleCommentTableViewCell()

@property(nonatomic,copy)CommiteModel *model;

@end

@implementation DoubleCommentTableViewCell

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
    
    if (model.maxnum > 2) {
//        self.cheoutButtonHeight.constant = 12;
        [self.checkoutButton setHidden:NO];
        
        NSString *num = [NSString stringWithFormat:@"查看全部%ld条对话",model.maxnum];
        
        [self.checkoutButton setTitle:num forState:UIControlStateNormal];
        [self.checkoutButton setImage:[UIImage imageNamed:@"箭头向右"] forState:UIControlStateNormal];
        [self.checkoutButton exchangeImageAndTitleWithSpace:2];
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.checkoutButton.mas_bottom).offset(13);
        }];
    }else {
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.checkoutButton.mas_top);
        }];
        
//        self.cheoutButtonHeight.constant = 0;
        [self.checkoutButton setHidden:YES];
        
        
    }
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
    
    if (model.maxnum > 2) {
        self.cheoutButtonHeight.constant = 12;
        [self.checkoutButton setHidden:NO];
        
        NSString *num = [NSString stringWithFormat:@"查看全部%ld条对话",model.maxnum];
        
        [self.checkoutButton setTitle:num forState:UIControlStateNormal];
        [self.checkoutButton setImage:[UIImage imageNamed:@"箭头向右"] forState:UIControlStateNormal];
        [self.checkoutButton exchangeImageAndTitleWithSpace:2];
    }else {
        self.cheoutButtonHeight.constant = 0;
        [self.checkoutButton setHidden:YES];
    }
}


-(void)setMessageModelIndex:(NSInteger)index{
    [self.commite setTag:index];
}

- (IBAction)gotoCommitHistory:(id)sender {
    
    HistoryTalksViewController *vc = [[HistoryTalksViewController alloc] init];
    vc.model = self.model;
    [[Tool currentNavigationController].rt_navigationController pushViewController:vc animated:YES];
}


@end
