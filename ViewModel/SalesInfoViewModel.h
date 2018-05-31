//
//  SalesInfoViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/3/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "SalesInformationListModel.h"
#import "SalesInformationFatherRequest.h"

@interface SalesInfoViewModel : FatherViewModel
@property(nonatomic,strong)SalesInformationFatherRequest *request;
@property(nonatomic,strong)SalesInformationListModel *data;
@end
