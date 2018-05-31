//
//  myCommentTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommiteModel.h"

@interface MyCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *level;

@property (weak, nonatomic) IBOutlet UIButton *deleteCommite;
@property (weak, nonatomic) IBOutlet UIButton *commite;

-(void)setMessageModel:(CommiteModel *)model;

-(void)setMessageModelIndex:(NSInteger)index;

@end
