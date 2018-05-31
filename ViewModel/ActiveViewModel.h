//
//  ActiveViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "ActiveCommitCityRequest.h"
@interface ActiveViewModel : FatherViewModel
@property(nonatomic,strong)ActiveCommitCityRequest *request;
@end
