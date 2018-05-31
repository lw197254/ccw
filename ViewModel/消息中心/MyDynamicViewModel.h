//
//  MyDynamicViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "MyDynamicRequest.h"
#import "MyDynamicListModel.h"

@interface MyDynamicViewModel : FatherViewModel

@property(nonatomic,strong)MyDynamicRequest *request;
@property(nonatomic,copy) MyDynamicListModel *data;

@end
