//
//  SelectCarTypeTableView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindCarByGroupByCarTypeGetCarModel.h"
@class FindCarByGroupByCarTypeYearModel;
typedef NS_ENUM(NSInteger,SelectCarType){
    SelectCarTypeDefault,//默认
    SelectCarTypeConditionSelect,//条件选车(多选)
    SelectCarTypeCompare,//对比（跟）
    SelectCarTypeSingleSelect//单个选择
};
typedef void(^CarTypeCompareSelectedBlock)(FindCarByGroupByCarTypeGetCarModel*model);
@interface SelectCarTypeTableView : UITableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style carTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block type:(SelectCarType)type typeId:(NSInteger )typeId selectedDict:(NSMutableDictionary*)selectedDict carSeriesName:(NSString*)carSeriesName model:(FindCarByGroupByCarTypeYearModel*)model;
@end
