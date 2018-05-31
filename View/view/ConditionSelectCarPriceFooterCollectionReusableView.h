//
//  ConditionSelectCarPriceFooterCollectionReusableView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/28.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLDoubleSlideView;
@interface ConditionSelectCarPriceFooterCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet HLDoubleSlideView *slideView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
-(void)resetSliderView;
@end
