//
//  myCommentTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "MyCommentTableViewCell.h"

@implementation MyCommentTableViewCell

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
    
    [self.headimage setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"我的默认头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    self.headimage.layer.cornerRadius=self.headimage.frame.size.width/2;//裁成圆角
    self.headimage.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    
    self.name.text = model.username;
    self.content.text = model.content;
    self.time.text = model.formataddtime;
    
}



-(void)setMessageModelIndex:(NSInteger)index{
    [self.commite setTag:index];
}


- (IBAction)deleteMessage:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否删除此条评论?" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消按钮");
    }];
    [cancel setValue:[UIColor colorWithString:@"0xbbbbbb"] forKey:@"titleTextColor"];
    
    [alert addAction:cancel];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
    }]];
    
    UIViewController *vc = [URLNavigation navigation].currentNavigationViewController;
    
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
