//
//  PromotionInfoViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PromotionInfoModel.h"
#import "PromotionInfoRequest.h"

@interface PromotionInfoViewModel : FatherViewModel
@property(nonatomic,strong)PromotionInfoModel *data;
@property(nonatomic,strong)PromotionInfoRequest *request;
@end
