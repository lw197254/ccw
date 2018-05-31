//
//  ConditionSelectCarViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "ConditionModel.h"
typedef void(^ConditionSelectCarMoreConditionBlock)(NSDictionary*selectedDict,NSArray<ConditionModel*>*selectedArray,NSInteger chexiNumber);
@interface ConditionSelectCarMoreConditionViewController : ParentViewController
//@property(nonatomic,strong)NSMutableDictionary*originalSelectedDict;
//@property(nonatomic,strong)NSMutableArray*originalSelectedArray;
-(void)resetWithPriceArray:(NSArray<NSString *> *)priceArray brandIdArray:(NSArray<NSString *> *)brandIdArray originalSelectedDict:(NSDictionary *)originalSelectedDict originalSelectedArray:(NSArray<ConditionModel*> *)originalSelectedArray confirmClickedBlock:(ConditionSelectCarMoreConditionBlock)block count:(NSInteger)count;
@end
