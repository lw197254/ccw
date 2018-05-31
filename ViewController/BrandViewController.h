//
//  BrandViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "BrandModel.h"
#import "CarSeriesViewController.h"
typedef void(^BrandSelectedBlock)(BrandModel*model);

@interface BrandViewController : ParentViewController
@property(nonatomic,copy)BrandSelectedBlock brandSelectedBlock;
@property(nonatomic,copy)CarTypeCompareSelectedBlock carTypeCompareSelectedBlock;
@property(nonatomic,assign)CarSeriesType carSeriesType;
@property(nonatomic,copy)CarSeriesSelectedBlock carSeriesSelectedBlock;
-(void)selectedWithCarTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block type:(SelectCarType)type selectedDict:(NSMutableDictionary*)selectedDict;
@end
