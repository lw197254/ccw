//
//  DealerInfoTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/28.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealerInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *askForPriceButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
//@property (weak, nonatomic) IBOutlet UIView *line1;
//@property (weak, nonatomic) IBOutlet UIView *line2;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoptype;

@end
