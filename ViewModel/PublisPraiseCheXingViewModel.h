//
//  PublisPraiseCheXingViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PublicPraiseCXingRequest.h"
#import "KouBeiBaseModel.h"


@interface PublisPraiseCheXingViewModel : FatherViewModel
@property(nonatomic,strong)KouBeiBaseModel *data;
@property(nonatomic,strong)PublicPraiseCXingRequest *request;
@end
