//
//  HistoryTalksViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "TalksHistoryRequest.h"
#import "CommiteListModel.h"


@interface HistoryTalksViewModel : FatherViewModel

@property(nonatomic,strong)TalksHistoryRequest *request;
@property(nonatomic,copy)CommiteListModel *data;

@end
