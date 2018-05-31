//
//  BrandViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "BrandModel.h"
#import "SelectCarTypeViewController.h"
#import "CarSeriesModel.h"
typedef NS_ENUM(NSInteger,CarSeriesType){
    CarSeriesTypeNormal = 0,
    CarSeriesTypeCompare = 1,
    CarSeriesTypeDelear = 2,
    CarSeriesTypeSingleSelect = 3
};
typedef void(^CarSeriesSelectedBlock)(CarSeriesModel*model);
@interface CarSeriesViewController : ParentViewController


@property(nonatomic,strong)BrandModel*brandModel;


///对比的时候使用下面方法，开始
@property(nonatomic,copy)CarTypeCompareSelectedBlock carTypeCompareSelectedBlock;
@property(nonatomic,copy)CarSeriesSelectedBlock carSeriesSelectedBlock;
@property(nonatomic,assign)CarSeriesType carSeriesType;
-(void)selectedWithCarTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block carSeriesType:(CarSeriesType)type selectedDict:(NSMutableDictionary*)selectedDict;
///根据厂商id查询车系
@property(nonatomic,strong)NSString*factoryId;
///根据厂商id查询车系名字
@property(nonatomic,strong)NSString*carSeriesName;

///对比的时候使用方法，结束
///刷新当前控制器
-(void)refreshViewController;
@end
