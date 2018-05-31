//
//  CompareImageLineTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareImageLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *leftlabel;
@property (weak, nonatomic) IBOutlet UILabel *middlelabel;

@property (weak, nonatomic) IBOutlet UILabel *rightlabel;


-(void)configWithData:(BOOL)isFirst index:(NSInteger)index;

-(void)configWithData:(BOOL)isFirst float:(float)index;
@end
