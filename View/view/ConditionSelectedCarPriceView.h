//
//  ConditionSelectedCarPriceView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLDoubleSlideView.h"
#import "ConditionSelectCarPriceFooterCollectionReusableView.h"
typedef void(^ConditionSelectCarPriceAndBrandCollectionViewCellBlock)(NSInteger minPrice,NSInteger maxPrice);
typedef void(^ConditionSelectCarPriceCancelBlock)(void);
#define MaxPrice 9999
@interface ConditionSelectedCarPriceView : UIView
@property (copy, nonatomic)  ConditionSelectCarPriceAndBrandCollectionViewCellBlock  block;
@property (copy, nonatomic)  ConditionSelectCarPriceAndBrandCollectionViewCellBlock  priceChangedBlock;
@property (copy, nonatomic)  ConditionSelectCarPriceCancelBlock  cancelBlock;
@property(nonatomic,strong)UICollectionView*collectionView;
@property(nonatomic,strong)HLDoubleSlideView*doubleSlideView;
@property(nonatomic,strong)UIButton*confirmButton;
@property(nonatomic,strong)ConditionSelectCarPriceFooterCollectionReusableView*footerView;
-(void)showWithPriceButtonTitle:(NSString*)title selctedBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock)block priceChangeBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock) priceChangedBlock cancelBlock:(ConditionSelectCarPriceCancelBlock)cancelBlock carSeriesCount:(NSInteger)carSeriesCount;


-(void)showWithPriceButtonTitleWithoutCount:(NSString*)title selctedBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock)block priceChangeBlock:(ConditionSelectCarPriceAndBrandCollectionViewCellBlock) priceChangedBlock cancelBlock:(ConditionSelectCarPriceCancelBlock)cancelBlock;

-(void)dismiss;

@property(nonatomic,assign)bool isReduce;
@end
