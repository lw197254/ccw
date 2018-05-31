//
//  ReduceCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ReduceCarTableViewCell.h"

#import "AskForPriceNewViewController.h"
#import "AskForPriceViewController.h"
#import "PhoneCallWebView.h"
#import "BuyCarCalculatorViewController.h"

@implementation ReduceCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBottomLine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)jisuan:(UIButton *)sender {
    BuyCarCalculatorViewController*vc  = [[ BuyCarCalculatorViewController alloc]init];
    vc.cheXingString = [NSString stringWithFormat:@"%@ %@",self.model.CAR_BRAND_TYPE_NAME,self.model.CAR_BRAND_SON_TYPE_NAME];
    vc.cheXingId = self.model.car_brand_son_type_id;
    if (self.model.manufacturer_price.isNotEmpty) {
        vc.price = [self.model.manufacturer_price floatValue]*10000;
    }else{
        vc.price =0;
    }
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

- (IBAction)call:(id)sender {
    if (self.model.servicePhone.isNotEmpty) {
        [PhoneCallWebView showWithTel:self.model.servicePhone];
    }else{
        [UIAlertController showAlertInViewController:[Tool currentViewController] withTitle:@"" message:@"经销商电话为空" cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
    }
}

- (IBAction)xunjia:(id)sender {
    
    AskForPriceViewController*vc = [[AskForPriceViewController alloc]init];
    
    vc.delearId = self.model.dealer_id;
    vc.carSerieasId = self.model.car_brand_type_id;
    vc.carTypeId = self.model.car_brand_son_type_id;
    vc.carTypeName = [NSString stringWithFormat:@"%@ %@",self.model.CAR_BRAND_TYPE_NAME,self.model.CAR_BRAND_SON_TYPE_NAME];
    
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

@end
