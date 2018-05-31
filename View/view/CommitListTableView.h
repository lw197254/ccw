//
//  CommitListTableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/9.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^scrollView2FatherView)(UIScrollView *srollview);
typedef void(^messageCommite2FatherView)(UIButton *button);

@interface CommitListTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSMutableArray *commitList;

@property(nonatomic,copy)scrollView2FatherView block;
@property(nonatomic,copy)messageCommite2FatherView messageBlock;
@end
