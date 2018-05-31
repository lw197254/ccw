//
//  PhotoSelectCarAndColorViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PhotoCarTypeAndColorRequest.h"
#import "CarTypeAndColorModel.h"
@interface PhotoSelectCarAndColorViewModel : FatherViewModel
@property(nonatomic,strong)PhotoCarTypeAndColorRequest*request;
@property(nonatomic,strong)CarTypeAndColorModel*model;
@end
