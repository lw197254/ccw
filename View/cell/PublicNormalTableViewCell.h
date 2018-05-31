//
//  PublicNormalTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InfoArticleModel.h"

@interface PublicNormalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *publicuser;
@property (weak, nonatomic) IBOutlet UILabel *views;

-(void)setData:(InfoArticleModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
