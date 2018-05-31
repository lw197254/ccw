//
//  SelectCarTypeViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "ConditionSelectCarSeriesViewModel.h"
#import "SelectCarTypeTableView.h"

@interface SelectCarTypeViewController : ParentViewController
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger typeId;

///为yes，需要给下面viewmodel值，为no给上面两个元素赋值,还需要typeId，type为默认0


@property(nonatomic,strong)ConditionSelectCarSeriesViewModel*condtionViewModel;

@property(nonatomic,assign)SelectCarType selectCarType;


@property(nonatomic,copy)NSString* carSeriesName;
///该方法type目前只支持 SelectCarTypeCompare,//对比，SelectCarTypeSingleSelect//单个选择
-(void)selectedWithCarTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block type:(SelectCarType)type typeId:(NSInteger )typeId selectedDict:(NSMutableDictionary*)selectedDict;

@end
