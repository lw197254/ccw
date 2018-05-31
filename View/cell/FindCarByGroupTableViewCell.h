//
//  FindCarByGroupTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindCarByGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *CarNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *CarCountLabel;
@property (weak, nonatomic) IBOutlet UIView *seperateLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLineHeightConstaint;

@end
