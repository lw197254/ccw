//
//  PromotionSaleCarViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PromotionListModel.h"
#import "PromotionSaleCarsRequest.h"

@interface PromotionSaleCarViewModel : FatherViewModel
@property(nonatomic,copy)PromotionListModel *data;
@property(nonatomic,strong)PromotionSaleCarsRequest *request;
@end
