//
//  CompareKoubeiView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareKoubeiView.h"
#import "PublicPraiseViewController.h"
#import "PublicPraiseDetailViewController.h"

@implementation CompareKoubeiView
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
-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSBundle mainBundle]loadNibNamed:classNameFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.ratingBar.isIndicator = NO;
    [self.ratingBar setImageDeselected:@"ic_star" halfSelected:@"ic_star3" fullSelected:@"ic_star2" andDelegate:nil];
    [self.ratingBar displayRating:5.0];
    
    
    [self.ratingBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20*5+5*4);
    }];
}
- (IBAction)goToKoubei:(id)sender {
    
    if (![self.car isNotEmpty]) {
        return ;
    }
    
    PublicPraiseViewController *vc = [[PublicPraiseViewController alloc] init];
    
    vc.chexingId = self.car.cars.car_id;
    vc.carSeriesName = self.car.cars.cx_name;
    vc.carTypeName = self.car.cars.car_name;
    [URLNavigation pushViewController:vc animated:YES];

}

- (IBAction)goToSingleKouBei:(id)sender{
    if (![self.car isNotEmpty]) {
        return ;
    }
    
    PublicPraiseDetailViewController *vc = [[PublicPraiseDetailViewController alloc] init];
    vc.koubeiId = self.car.koubei.id;
    [URLNavigation pushViewController:vc animated:YES];
}
@end
