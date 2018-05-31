//
//  RankingListViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/29.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "RanklistModel.h"
#import "RanklistRequest.h"

@interface RankingListViewModel : FatherViewModel

@property(nonatomic,strong)RanklistModel *data;
@property(nonatomic,strong)RanklistRequest *request;
@end
