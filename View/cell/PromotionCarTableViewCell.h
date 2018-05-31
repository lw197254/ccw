//
//  PromotionCarTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/3/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PromotionSaleCarModel.h"

@interface PromotionCarTableViewCell : UITableViewCell
-(void)SetDataList:(PromotionCarList *)model;

@property(nonatomic,strong)NSString *dealerId;
@end
