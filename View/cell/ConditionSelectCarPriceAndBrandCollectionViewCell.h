//
//  ConditionSelectCarPriceAndBrandCollectionViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLDoubleSlideView.h"
typedef void(^ConditionSelectCarPriceAndBrandCollectionViewCellBlock)(NSInteger minPrice,NSInteger maxPrice);
#define MaxPrice 9999
@interface ConditionSelectCarPriceAndBrandCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBrandButton;
@property (copy, nonatomic)  ConditionSelectCarPriceAndBrandCollectionViewCellBlock  block;

-(void)resetSliderView;
@end
