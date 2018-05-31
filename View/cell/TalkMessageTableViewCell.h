//
//  TalkMessageTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommiteModel.h"

@interface TalkMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftheadimage;
@property (weak, nonatomic) IBOutlet UILabel *leftname;
@property (weak, nonatomic) IBOutlet UIImageView *rightheadimage;
@property (weak, nonatomic) IBOutlet UILabel *rightname;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *leftContentBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightContentBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentright;
@property (weak, nonatomic) IBOutlet UILabel *currentlabelleft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContentBackgroundImageBottomTosuperConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContentBackgroundImageBottomTosuperConstraints;

-(void)setMessageData:(CommiteModel *)model;

-(void)setCurrentData:(CommiteModel *)model;

@end
