//
//  FindCarByGroupViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "FindCarByGroupGetConditionListModel.h"
#import "FindCarByGroupGetConditionRequest.h"

//#import "FindCarByGroupGetCarListCountRequest.h"


//#import "FindCarByGroupGetCarCountModel.h"



@interface FindCarByGroupViewModel : FatherViewModel
@property(nonatomic,strong)FindCarByGroupGetConditionRequest*getConditionListRequest;


//
//@property(nonatomic,strong)FindCarByGroupGetCarListCountRequest*getCarListCountRequest;

@property(nonatomic,strong)FindCarByGroupGetConditionListModel*getConditionListModel;


//@property(nonatomic,strong)FindCarByGroupGetCarCountModel*getCarListCountModel;

@end
