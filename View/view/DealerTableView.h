//
//  DealerTableView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/4/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealerViewModel.h"
typedef NS_ENUM(NSInteger,DealerSortType){
    DealerSortTypeNormal,  ///默认排序
    DealerSortTypeNearest  ///离我最近
};
@interface DealerTableView : UITableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dealerSortType:(DealerSortType)dealerSortType;
-(void)refreshWithArea:(NSString*)area brand:(NSString*)brand dealerScope:(CarTypeDetailDealerScope)dealerScope cityId:(NSString*)cityId ;
@end
