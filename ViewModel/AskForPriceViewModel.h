//
//  AskForPriceViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "AskForPriceModel.h"
#import "AskForPriceDealerListRequest.h"
#import "AskForPriceCommitRequest.h"
#import "AskForPriceCarSeriesListModel.h"
#import "AskForPriceCarseriesRequest.h"
#import "AskForPriceMessageRequest.h"
@interface AskForPriceViewModel : FatherViewModel

@property(nonatomic,strong)AskForPriceDealerListRequest*askRequest;

@property(nonatomic,strong)AskForPriceCommitRequest*commitRequest;
@property(nonatomic,strong)AskForPriceModel*model;


@property(nonatomic,strong)AskForPriceCarseriesRequest*carSeriesRequest;
@property(nonatomic,strong)AskForPriceCarSeriesListModel*carSeriesListModel;

@property(nonatomic,strong)AskForPriceMessageRequest*messageRequest;


@end
