//
//  FindViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "FindListModel.h"
#import "FindRequest.h"

@interface FindViewModel : FatherViewModel

@property(nonatomic,strong)FindRequest *request;
@property(nonatomic,strong)FindListModel *data;

@end
