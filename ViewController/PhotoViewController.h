//
//  PhotoViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "HTHorizontalSelectionList.h"
#import "HorizontalScrollView.h"


@interface PhotoViewController : ParentViewController <UIScrollViewDelegate,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>

@property(nonatomic,strong)NSString *typeId;
@property(nonatomic,strong)NSString *carId;

@property(nonatomic,strong)NSString *carName;
@property(nonatomic,strong)NSString *carType;
@property(nonatomic,strong)NSString *carPrice;
@end
