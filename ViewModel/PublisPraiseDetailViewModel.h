//
//  PublisPraiseDetailViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PublicPraiseDetailRequest.h"
#import "KouBeiDetailBaseModel.h"

@interface PublisPraiseDetailViewModel : FatherViewModel

@property(nonatomic,strong)PublicPraiseDetailRequest *request;
@property(nonatomic,strong)KouBeiDetailBaseModel *data;

@end
