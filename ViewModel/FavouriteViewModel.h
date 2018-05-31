//
//  FavouriteViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "CarSeriesListModel.h"
#import "FindCarByGroupByCarTypeGetCarListModel.h"
@interface FavouriteViewModel : FatherViewModel
@property(nonatomic,strong)NSArray<CarSeriesModel*>*carSeriesList;
@property(nonatomic,strong)NSArray<FindCarByGroupByCarTypeGetCarModel*>*carTypeList;

@end
