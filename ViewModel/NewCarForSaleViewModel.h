//
//  NewCarForSaleViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "NewCarForSaleListModel.h"
#import "NewCarForSaleRequest.h"
@interface NewCarForSaleViewModel : FatherViewModel
@property(nonatomic,strong)NewCarForSaleRequest*request;
@property(nonatomic,strong)NewCarForSaleListModel*model;

@end
