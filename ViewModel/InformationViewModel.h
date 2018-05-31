//
//  InformationViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "InformationCarTypeRequest.h"
#import "InformationCarSeriesRequest.h"
#import "HomeMenuModel.h"
#import "InformationListModel.h"
#import "HomeMenuRequest.h"
@interface InformationViewModel : FatherViewModel
@property(nonatomic,strong)InformationCarTypeRequest*carTypeRequest;
@property(nonatomic,strong)InformationCarSeriesRequest*carSeriesRequest;
@property(nonatomic,strong)HomeMenuModel*menuModel;
@property(nonatomic,strong)InformationListModel*model;
@property(nonatomic,strong)NSMutableArray<InformationModel>*list;
@property(nonatomic,strong)HomeMenuRequest*menuRequst;

@end
