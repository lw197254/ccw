//
//  AskPriceSuccessViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"
@class AskForPriceResultListModel;
@interface AskPriceSuccessViewController : ParentViewController
@property(nonatomic,strong)AskForPriceResultListModel*model;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
