//
//  DearlerCarTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PromotionDearInfoModel.h"

@interface DearlerCarTableViewCell : UITableViewCell
-(void)setData:(PromotionDearInfoModel *)model;
@property(nonatomic,strong)NSString *dealer;
@end
