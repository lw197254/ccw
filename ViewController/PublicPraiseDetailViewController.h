//
//  PublicPraiseDetailViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface PublicPraiseDetailViewController : ParentViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *koubeiId;
@property(nonatomic,strong)NSString *views;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadimg;
@property (weak, nonatomic) IBOutlet UILabel *licheng;
@property (weak, nonatomic) IBOutlet UILabel *oil;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *carTypeName;
@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UILabel *oliLabelView;
@property (weak, nonatomic) IBOutlet UIButton *viewnum;

@end
