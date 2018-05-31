//
//  HomeViewModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "HomelistRequest.h"
#import "HomeModel.h"

#import "XiHaoSubjectListModel.h"
#import "HomeXihaoRequest.h"

#import "TagsListModel.h"
#import "TagsRequest.h"

@interface HomeViewModel : FatherViewModel
@property(nonatomic,strong)HomelistRequest *request;
@property(nonatomic,strong)HomeModel *data;

//@property(nonatomic,strong)HomeXihaoRequest *xihaorequest;
//@property(nonatomic,strong)XiHaoSubjectListModel *xihaodata;

@property(nonatomic,strong)TagsRequest *tagrequest;
@property(nonatomic,strong)TagsListModel *tagdata;
@end
