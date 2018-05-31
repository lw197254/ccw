//
//  NewCompareCarViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "NewCompareCarRequest.h"
#import "NewCompareCarListModel.h"

@interface NewCompareCarViewModel : FatherViewModel

@property(nonatomic,strong) NewCompareCarRequest *request;
@property(nonatomic,strong) NewCompareCarListModel *data;

@end
