//
//  PromotionImageTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionPrcinfoModel.h"
@interface PromotionImageTableViewCell : UITableViewCell
-(void)setData:(NSArray<PromotionPrcinfoModel> *) model Count:(NSInteger) row;
@end
