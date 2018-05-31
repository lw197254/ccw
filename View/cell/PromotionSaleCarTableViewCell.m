//
//  PromotionSaleCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionSaleCarTableViewCell.h"
#import "AskForPriceViewController.h"

#import "PromotionViewController.h"
#import "PromotionSaleCarsViewController.h"
#import "DealerCarInfoViewController.h"

@interface PromotionSaleCarTableViewCell()
//@property (weak, nonatomic) IBOutlet UIView *topView;
//@property (weak, nonatomic) IBOutlet UILabel *toplabel;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceDown;
@property (weak, nonatomic) IBOutlet UIButton *askForPriceButton;

@property(nonatomic,strong)PromotionCarModel *model;
@end

@implementation PromotionSaleCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (kwidth == 320) {
        [self.askForPriceButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataWithModel:(PromotionCarModel *)model  {
    self.model = model;
    self.carName.text = model.carname;
    NSString *price = [NSString stringWithFormat:@"¥%@万",model.showprice];
    self.price.text = price;
    
    NSString *oldprice = [NSString stringWithFormat:@"指导价:%@万",model.facprice];
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",oldprice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    
   
    self.oldPrice.attributedText =newPrice;
    
    NSString *reduceprice = [NSString stringWithFormat:@"↓%@万",model.reduceprice];
    self.priceDown.text = reduceprice;
}
- (IBAction)askprice:(id)sender {
  
    AskForPriceViewController *vc = [[AskForPriceViewController alloc] init];
    
    UIViewController *obj = [Tool currentViewController];
    
    //促销详情 埋点
    if ([obj isKindOfClass:[PromotionViewController class]]) {
        [ClueIdObject setClueId:xunjia_14];
    }else
    
    //在售车型 埋点
    if ([obj isKindOfClass:[PromotionSaleCarsViewController class]]) {
        [ClueIdObject setClueId:xunjia_16];
    }
    
    //车辆详情 埋点
    else if ([obj isKindOfClass:[DealerCarInfoViewController class]]) {
        [ClueIdObject setClueId:xunjia_17];
    }

    
    vc.delearId  = self.delearId;
    vc.carTypeId = self.model.carid;
    vc.carSerieasId = self.model.typeid;
    vc.carTypeName = self.model.carname;
    [URLNavigation pushViewController:vc animated:YES];
}

@end
