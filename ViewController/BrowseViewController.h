//
//  BrowseViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/1/18.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "HTHorizontalSelectionList.h"
#import "HorizontalScrollView.h"

@interface BrowseViewController : ParentViewController<UIScrollViewDelegate,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>

@end
