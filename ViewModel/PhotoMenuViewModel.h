//
//  PhotoMenuViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PicMenuBaseModel.h"
#import "PhotoMenuRequest.h"


@interface PhotoMenuViewModel : FatherViewModel

@property(nonatomic,strong)PicMenuBaseModel *data;
@property(nonatomic,strong)PhotoMenuRequest *request;

@end
