//
//  ComparePriceView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewCompareCarModel;

@interface ComparePriceView : UIView
@property(nonatomic,strong)IBOutlet UIView*view;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *askPriceButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *carPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceDetailButton;

@property (weak, nonatomic) IBOutlet UILabel *cankaolabel;
@property (weak, nonatomic) IBOutlet UILabel *luochecankao;

@property (strong,nonatomic) NewCompareCarModel *model;

-(void)choosePinkColor;
 
@end
