//
//  CompareDelearTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareDelearTableViewCell.h"
#import "ReducePriceListViewController.h"

@implementation CompareDelearTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftbuttonClick:(id)sender {
    ReducePriceListViewController*vc = [[ReducePriceListViewController alloc]init];
//    vc.che = self.leftid;
    vc.carTypeID = self.leftid;
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

- (IBAction)rightbuttonClick:(id)sender {
    if (![self.rightid isNotEmpty]) {
        return ;
    }
    ReducePriceListViewController*vc = [[ReducePriceListViewController alloc]init];
    vc.carTypeID = self.rightid;
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

@end
