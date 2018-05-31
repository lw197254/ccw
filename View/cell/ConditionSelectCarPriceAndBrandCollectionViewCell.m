//
//  ConditionSelectCarPriceAndBrandCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarPriceAndBrandCollectionViewCell.h"

@interface ConditionSelectCarPriceAndBrandCollectionViewCell()
@property (weak, nonatomic) IBOutlet HLDoubleSlideView *sliderView;
@property (assign, nonatomic)  NSInteger minPrice;
@property (assign, nonatomic)  NSInteger maxPrice;

@end
@implementation ConditionSelectCarPriceAndBrandCollectionViewCell

- (void)awakeFromNib {
   
    [super awakeFromNib];
    UIImage*image = [UIImage imageNamed:@"bnt_xundijia_n.png"];
    UIImage*highLightImage = [UIImage imageNamed:@"bnt_xundijia_s.png"];
    image  = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    highLightImage = [highLightImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.selectBrandButton setBackgroundImage:image forState:UIControlStateNormal];
     [self.selectBrandButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    
    self.sliderView.minValue = 0;
    self.sliderView.maxValue = 101;
    self.sliderView.currentLeftValue = 0;
    self.sliderView.currentRightValue = 101;
    self.minPrice = 0;
    self.maxPrice = MaxPrice;
    @weakify(self);
   [self.sliderView sliderChange:^void (NSInteger leftCountValue, NSInteger rightCountValue) {
       @strongify(self);
       self.minPriceLabel.text = [NSString stringWithFormat:@"%ld万",leftCountValue];
        self.minPrice = leftCountValue;
       if (rightCountValue >100) {
            self.maxPriceLabel.text = @">100万";
           self.maxPrice = MaxPrice;
       }else{
       self.maxPriceLabel.text = [NSString stringWithFormat:@"%ld万",rightCountValue];
           self.maxPrice = rightCountValue;
       }
       if (self.block) {
           self.block(self.minPrice,self.maxPrice);
       }
       
    }];
    // Initialization code
}
-(void)resetSliderView{
    self.sliderView.currentLeftValue = 0;
    self.sliderView.currentRightValue = 101;
    self.minPriceLabel.text = [NSString stringWithFormat:@"%ld万",self.sliderView.currentLeftValue];
    self.minPrice = self.sliderView.currentLeftValue;
   
        self.maxPriceLabel.text = @">100万";
        self.maxPrice = MaxPrice;
        if (self.block) {
        self.block(self.minPrice,self.maxPrice);
    }

}
@end
