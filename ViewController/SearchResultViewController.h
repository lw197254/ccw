//
//  SearchResultViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewModel.h"
@interface SearchResultViewController : UITableViewController
@property(nonatomic,strong)SearchViewModel *viewModel;
///显示所有车系
@property(nonatomic,assign)BOOL showAllSeries;
@end
