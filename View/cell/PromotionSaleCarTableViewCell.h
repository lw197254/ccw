//
//  PromotionSaleCarTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionCarModel.h"

@interface PromotionSaleCarTableViewCell : UITableViewCell

-(void)setDataWithModel:(PromotionCarModel*)model;

@property(nonatomic,strong)NSString *delearId;

@end
