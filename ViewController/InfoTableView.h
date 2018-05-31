//
//  InfoTableView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoNewSonModel.h"
#import "RelateCarTableViewCell.h"

@interface InfoTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray<InfoNewSonModel> *sonModel;

@end
