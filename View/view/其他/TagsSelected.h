//
//  TagsSelected.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsListModel.h"


@interface TagsSelected : UIView <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)TagsListModel *baseModel;

-(void)callNet;
-(void)rebuildbaseData;
@end
