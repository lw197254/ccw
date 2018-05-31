//
//  SearchResultViewController.h
//  searchController
//
//  Created by 王涛 on 16/3/7.
//  Copyright © 2016年 王涛. All rights reserved.
//
#import "ParentViewController.h"
@class AreaNewModel;
typedef void(^CityClickedBlock)(AreaNewModel *model);
typedef void(^SearchResignFirstResponceBlock)();

@interface CitySearchResultViewController :UIViewController

// 搜索结果数据
@property (nonatomic, strong) NSMutableArray *dataArray;
-(void)finishedSelected:(CityClickedBlock)block;
@property(nonatomic,copy)NSString *selectedCityName;
@property(nonatomic,copy)NSString *searchKey;
@property(nonatomic,copy)SearchResignFirstResponceBlock searchResignFirstResponceBlock;
-(void)reloadData;
@end
