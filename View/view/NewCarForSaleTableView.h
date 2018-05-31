//
//  NewCarForSaleTableView.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCarForSaleViewModel.h"
typedef void(^ReloadDataFinishedBlock)(NSInteger listCount);
@interface NewCarForSaleTableView : UITableView

@property (strong, nonatomic) NewCarForSaleViewModel*viewModel;
@property(nonatomic,copy)ReloadDataFinishedBlock reloadDataFinishedBlock;
@end
