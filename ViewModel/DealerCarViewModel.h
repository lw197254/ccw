//
//  DealerCarViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/3/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "DealerCarModel.h"
#import "DealerCarRequest.h"

@interface DealerCarViewModel : FatherViewModel
@property(nonatomic,strong)DealerCarRequest *request;
@property(nonatomic,strong)DealerCarModel *data;
@end
