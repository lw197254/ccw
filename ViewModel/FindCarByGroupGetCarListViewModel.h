//
//  FindCarByGroupGetCarListViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "FindCarByGroupGetCarListRequest.h"

#import "FindCarByGroupGetCarListModel.h"
@interface FindCarByGroupGetCarListViewModel : FatherViewModel
@property(nonatomic,strong)FindCarByGroupGetCarListRequest*request;
@property(nonatomic,strong)FindCarByGroupGetCarListModel*model;
@property(nonatomic,retain)NSMutableArray<FindCarByGroupGetCarModel*>*carListArray;
@end
