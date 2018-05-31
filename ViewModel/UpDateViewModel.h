//
//  UpDateViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/15.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "UpDateRequest.h"
#import "UpdateInfoModel.h"

@interface UpDateViewModel : FatherViewModel
@property(nonatomic,strong)UpDateRequest *request;
@property(nonatomic,strong)UpdateInfoModel *data;
@end
