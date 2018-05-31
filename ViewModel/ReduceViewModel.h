//
//  ReduceViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"

#import "ReduceRequest.h"
#import "ReduceListModel.h"

@interface ReduceViewModel : FatherViewModel

@property(nonatomic,strong) ReduceRequest *request;
@property(nonatomic,strong) ReduceListModel *data;

@end
