//
//  PublicPraiseViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "HTHorizontalSelectionList.h"

@interface PublicPraiseViewController : ParentViewController<UIScrollViewDelegate,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>

/// 车系
@property(nonatomic,strong)NSString *catTypeId;
/// 车型
@property(nonatomic,strong)NSString *chexingId;
/// 车系名
@property(nonatomic,strong)NSString *carSeriesName;
/// 车型名
@property(nonatomic,strong)NSString *carTypeName;
@end
