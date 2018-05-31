//
//  CarSeriesViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CarSeriesRequest.h"
#import "CarSeriesListModel.h"
#import "CarSeriesListWithfactoryRequest.h"
#import "CarSeriesFactoryListModel.h"
@interface CarSeriesViewModel : FatherViewModel
@property(nonatomic,strong)CarSeriesRequest*request;
@property(nonatomic,strong)CarSeriesListModel*model;
@property(nonatomic,strong)CarSeriesListWithfactoryRequest*factoryRequest;
@property(nonatomic,strong)CarSeriesFactoryListModel*factoryModel;
@end
