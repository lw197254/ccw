//
//  RanklistUITableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/29.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
#import "RankSectionModel.h"

@interface RanklistUITableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSArray<RankSectionModel> *cars;

@end
