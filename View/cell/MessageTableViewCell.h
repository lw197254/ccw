//
//  MessageTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDynamicModel.h"

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;


-(void)setMessage:(MyDynamicModel *)model;

@end
