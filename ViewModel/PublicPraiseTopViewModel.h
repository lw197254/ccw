//
//  PublicPraiseTopViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/16.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PublicPraiseTopRequest.h"
#import "KouBeiBaseModel.h"
@interface PublicPraiseTopViewModel : FatherViewModel

@property(nonatomic,strong)PublicPraiseTopRequest *request;
@property(nonatomic,strong)KouBeiBaseModel *data;

@end
