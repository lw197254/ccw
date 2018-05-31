//
//  VideoViewListViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"

@interface VideoViewListViewController : ParentViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString* catid;
@property (nonatomic, copy) NSString* titlename;
@end
