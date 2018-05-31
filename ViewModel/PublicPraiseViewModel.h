//
//  PublicPraiseViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PublicPraiseRequest.h"
#import "KouBeiBaseModel.h"

@interface PublicPraiseViewModel : FatherViewModel

@property(nonatomic,strong)KouBeiBaseModel *data;
@property(nonatomic,strong)PublicPraiseRequest *request;
@end
