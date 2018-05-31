//
//  ReBackViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "ReBackrRequest.h"
#import "CommiteListModel.h"

@interface ReBackViewModel : FatherViewModel
@property(nonatomic,strong)ReBackrRequest *request;
@property(nonatomic,copy)CommiteListModel *data;
@end
