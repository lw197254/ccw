//
//  PublicPraiseCheXingTableView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicPraiseTopCheXingViewModel.h"
#import "PublisPraiseCheXingViewModel.h"

@interface PublicPraiseCheXingTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)PublisPraiseCheXingViewModel *model;
@property(nonatomic,strong)PublicPraiseTopCheXingViewModel *topViewModel;
@property(nonatomic,assign)bool isFirstTab;
@property(nonatomic,assign)NSInteger page;

@end
