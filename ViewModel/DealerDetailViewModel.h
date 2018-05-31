//
//  DealerDetailViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"

#import "DealerDetailModel.h"
#import "DealerDetailRequest.h"

@interface DealerDetailViewModel : FatherViewModel

@property(nonatomic,strong)DealerDetailRequest *request;
@property(nonatomic,strong)DealerDetailModel *data;

@end
