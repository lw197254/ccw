//
//  ColorPickViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/2/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "PhotoSelectCarAndColorViewModel.h"
#import "CarColorTypeModel.h"
typedef void (^ColorTableViewBlock)(CarColorTypeModel*model);
typedef void (^ColorTableViewNSIndexPathBlock)(NSIndexPath*IndexPath);
@interface ColorPickViewController : ParentViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)PhotoSelectCarAndColorViewModel*viewModel;
@property(nonatomic,strong)ColorTableViewBlock block;
@property(nonatomic,strong)ColorTableViewNSIndexPathBlock index;
//点击后的位置
@property(nonatomic,strong)NSIndexPath *clickIndexPath;
@end
