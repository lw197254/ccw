//
//  PromotionTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/3/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionSaleCarModel.H"

@interface PromotionTableViewCell : UITableViewCell
-(void)SetData:(PromotionSaleCarModel *)model Count:(NSInteger) section;
-(void)SetDataList:(PromotionCarList *)model;

///跳转需要的参数
@property(nonatomic,strong)NSString *dealerId;
@end
