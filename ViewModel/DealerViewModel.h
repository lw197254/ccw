//
//  DealerViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "DealerRequest.h"
#import "DealerListModel.h"
@interface DealerViewModel : FatherViewModel
@property(nonatomic,strong)DealerRequest*request;
@property(nonatomic,strong)DealerListModel*model;
@property(nonatomic,retain)NSMutableArray*list;
@end
