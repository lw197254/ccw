//
//  ReduceCarTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReduceModel.h"

@interface ReduceCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UIImageView *iamge;
@property (weak, nonatomic) IBOutlet UILabel *dearname;
@property (weak, nonatomic) IBOutlet UILabel *redprice;
@property (weak, nonatomic) IBOutlet UILabel *normalprice;
@property (weak, nonatomic) IBOutlet UILabel *loseprice;
@property (weak, nonatomic) IBOutlet UIButton *callphone;
@property (weak, nonatomic) IBOutlet UIButton *xundijiabutton;
@property (weak, nonatomic) IBOutlet UIButton *jisuanbutton;
@property (weak, nonatomic) IBOutlet UILabel *labelleft;
@property (weak, nonatomic) IBOutlet UILabel *labelright;

@property (strong, nonatomic) ReduceModel *model;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *cityId;
@end
