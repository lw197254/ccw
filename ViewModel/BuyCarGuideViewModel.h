//
//  BuyCarGuideViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "BuyCarGuideRequest.h"
#import "CarGuideByModel.h"

@interface BuyCarGuideViewModel : FatherViewModel

@property (strong, nonatomic) BuyCarGuideRequest *request;
@property (copy, nonatomic) CarGuideByModel *data;

@end
