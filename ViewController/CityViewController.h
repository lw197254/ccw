//
//  ProvinceViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
@class AreaNewModel;
typedef void(^CitySelectedBlock)(AreaNewModel*cityModel);
@interface CityViewController : ParentViewController
@property(nonatomic,copy)CitySelectedBlock citySelectedBlock;
///历史选择城市
//@property(nonatomic,strong)AreaNewModel*selectedCityModel;

@end
