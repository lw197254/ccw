//
//  CommiteListViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "CommiteListRequest.h"
#import "CommiteListModel.h"

@interface CommiteListViewModel : FatherViewModel

@property(nonatomic,strong)CommiteListRequest *request;
@property(nonatomic,strong)CommiteListModel *data;

@end
