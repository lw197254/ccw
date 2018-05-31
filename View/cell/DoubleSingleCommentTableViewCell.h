//
//  DoubleSingleCommentTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/9/25.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommiteModel.h"

@interface DoubleSingleCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *recontent;

@property (weak, nonatomic) IBOutlet UILabel *level;


@property (weak, nonatomic) IBOutlet UIButton *commite;

//文章列表
-(void)setMessageModel:(CommiteModel *)model;
//消息中心
-(void)setMessageModelMessageCenter:(CommiteModel *)model;


-(void)setMessageModelIndex:(NSInteger)index;

@end
