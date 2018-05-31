//
//  DealerTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *askForPriceButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleAreaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;


@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) IBOutlet UIImageView *carimage;

@end
