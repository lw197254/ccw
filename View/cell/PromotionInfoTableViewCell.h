//
//  PromotionInfoTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionDearInfoModel.h"
#import "PromotionArtInfoModel.h"

@interface PromotionInfoTableViewCell : UITableViewCell
-(void)setData:(PromotionDearInfoModel *)model Art:(PromotionArtInfoModel *) art;
@end
