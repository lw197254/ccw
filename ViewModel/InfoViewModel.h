//
//  InfoViewModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "InfoDetailRequest.h"
#import "InfoBaseModel.h"

@interface InfoViewModel : FatherViewModel

@property(nonatomic,strong)InfoDetailRequest *request;
@property(nonatomic,strong)InfoBaseModel *data;

@end
