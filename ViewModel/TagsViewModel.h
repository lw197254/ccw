//
//  TagsViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"

#import "TagsRequest.h"
#import "TagsListModel.h"

@interface TagsViewModel : FatherViewModel

@property(nonatomic,strong)TagsRequest *request;
@property(nonatomic,strong)TagsListModel *data;



@end
