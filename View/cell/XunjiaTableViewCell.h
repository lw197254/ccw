//
//  XunjiaTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XunjiaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *askPriceButton;

@end
