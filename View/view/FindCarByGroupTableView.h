//
//  FindCarByGroupTableView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindCarByGroupGetCarListViewModel.h"
#import "FindCarByGroupGetConditionModel.h"
@interface FindCarByGroupTableView : UITableView

@property (strong, nonatomic) FindCarByGroupGetConditionModel*conditionModel;
@end
