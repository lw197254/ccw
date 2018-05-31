//
//  PhotoSelectCarTypeViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "PhotoSelectCarAndColorViewModel.h"
#import "PhotoSelectCarTypeTableView.h"
@interface PhotoSelectCarTypeViewController : ParentViewController
@property(nonatomic,strong)PhotoSelectCarAndColorViewModel*viewModel;
@property(nonatomic,strong)CarTypeSelectedBlock selectedBlock;

@end
