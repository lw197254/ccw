//
//  FindCarViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "FindCarBrandListRequest.h"
#import "FindCarBrandListModel.h"


@interface FindCarViewModel : FatherViewModel
//@property(nonatomic,strong)NSArray*sectionHeaderTitleArray;
//@property(nonatomic,strong)NSArray*sectionIndexTitleArray;
@property(nonatomic,strong)FindCarBrandListRequest*brandListRequest;

@property(nonatomic,strong)FindCarBrandListModel*model;

///马上刷新
@property(nonatomic,assign)BOOL refreshImmediately;
@end
