//
//  CarDeptDealerTableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/28.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTypeDetailDealerModel.h"
typedef NS_ENUM(NSInteger,DealerSortType){
    DealerSortTypeNormal,  ///默认排序
    DealerSortTypeNearest  ///离我最近
};
@interface CarDeptDealerTableView : UITableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
-(void)refreshWithArea:(NSString*)area brand:(NSString*)brand dealerScope:(CarTypeDetailDealerScope)dealerScope cityId:(NSString*)cityId styletype:(DealerSortType) type;
@end
