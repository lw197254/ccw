//
//  CarAllCheXingViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "CarAllCheXingRequest.h"
#import "CarAllListModel.h"

@interface CarAllCheXingViewModel : FatherViewModel

@property(nonatomic,strong)CarAllCheXingRequest *request;

@property(nonatomic,copy)CarAllListModel *data;

@end
