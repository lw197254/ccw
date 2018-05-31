//
//  VideoTableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDetailModel.h"
#import "VideoModel.h"

typedef void(^refreshModel)(VideoModel *model);

@interface VideoTableView : UITableView

@property(nonatomic,copy)refreshModel block;
@property(nonatomic,copy)VideoDetailModel *daseModel;

@end
