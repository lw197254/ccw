//
//  PublicPraiseTopCheXingViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PublicPraiseCheXingTopRequest.h"
#import "KouBeiBaseModel.h"
@interface PublicPraiseTopCheXingViewModel : FatherViewModel
@property(nonatomic,strong)PublicPraiseCheXingTopRequest *request;
@property(nonatomic,strong)KouBeiBaseModel *data;
@end
