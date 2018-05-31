//
//  SellCarTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
//指导价
@property (weak, nonatomic) IBOutlet UILabel *price;
//报价
@property (weak, nonatomic) IBOutlet UILabel *myPrice;
//询底价
@property (weak, nonatomic) IBOutlet UIButton *searchPrice;
@property (weak, nonatomic) IBOutlet UILabel *reference;
///对比
@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UIButton *buyCarCalculatorButton;

@end
