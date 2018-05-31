//
//  ComparePriceView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ComparePriceView.h"
#import "NewCompareCarModel.h"

#import "BuyCarCalculatorViewController.h"
#import "AskForPriceNewViewController.h"

#import "ClueIdObject.h"


@interface ComparePriceView()


@end

@implementation ComparePriceView
-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
-(instancetype)init{
    if (self= [super init]) {
        [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


-(void)choosePinkColor{
    [self.backgroundImageView setImage:[UIImage imageNamed:@"compareRight"]];
    
    self.cankaolabel.textColor = PinkColorFF500B;
    self.priceLabel.textColor = PinkColorFF500B;
    self.carPriceLabel.textColor = PinkColorFF823a;
    self.luochecankao.textColor = PinkColorFF823a;
}

- (IBAction)goToPriceCenter:(id)sender {
    
    if (![self.model isNotEmpty]) {
        return ;
    }
    
    BuyCarCalculatorViewController*vc  = [[ BuyCarCalculatorViewController alloc]init];
    vc.cheXingString = self.model.cars.car_name;
    vc.cheXingId = self.model.cars.car_id;
    if (self.model.budget.factory_price.isNotEmpty) {
        vc.price = [self.model.budget.factory_price floatValue]*10000;
    }else{
        vc.price =0;
    }
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}
- (IBAction)askForPrice:(id)sender {
    if (![self.model isNotEmpty]) {
        return ;
    }
    [ClueIdObject setClueId:xunjia_155];
    AskForPriceNewViewController*vc = [[AskForPriceNewViewController alloc]init];
    vc.carTypeId = self.model.cars.car_id;
    vc.carTypeName = [self.model.cars.car_name stringByAppendingString:self.model.cars.cx_name];
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
