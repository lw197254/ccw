//
//  ConditionSelectCarPriceFooterCollectionReusableView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/28.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ConditionSelectCarPriceFooterCollectionReusableView.h"
#import "HLDoubleSlideView.h"
@implementation ConditionSelectCarPriceFooterCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.slideView.minValue = 0;
    self.slideView.maxValue = 101;
    self.slideView.currentLeftValue = 0;
    self.slideView.currentRightValue = 101;
   
//    @weakify(self);
//    [self.sliderView sliderChange:^void (NSInteger leftCountValue, NSInteger rightCountValue) {
//        @strongify(self);
//        self.minPriceLabel.text = [NSString stringWithFormat:@"%ld万",leftCountValue];
//        self.minPrice = leftCountValue;
//        if (rightCountValue >100) {
//            self.maxPriceLabel.text = @">100万";
//            self.maxPrice = MaxPrice;
//        }else{
//            self.maxPriceLabel.text = [NSString stringWithFormat:@"%ld万",rightCountValue];
//            self.maxPrice = rightCountValue;
//        }
//        if (self.block) {
//            self.block(self.minPrice,self.maxPrice);
//        }
//        
//    }];
    // Initialization code
}
-(void)resetSliderView{
    self.slideView.currentLeftValue = 0;
    self.slideView.currentRightValue = 101;
    
}



@end
