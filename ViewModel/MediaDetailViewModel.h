//
//  MediaDetailViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "MediaDetailRequest.h"
#import "InfoBaseModel.h"


@interface MediaDetailViewModel : FatherViewModel
@property(nonatomic,strong)MediaDetailRequest *request;
@property(nonatomic,strong)InfoBaseModel *data;
@end
