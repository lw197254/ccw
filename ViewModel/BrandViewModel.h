//
//  BrandViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "BrandListModel.h"
#import "BrandRequest.h"
@interface BrandViewModel : FatherViewModel
@property(nonatomic,strong)BrandRequest*request;
@property(nonatomic,strong)BrandListModel*model;
@end
