//
//  UITableView+UITableViewTopView.h
//  chechengwang
//
//  Created by 严琪 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(UITableViewTopView)
@property(nonatomic,strong)UIButton* tableToTopView;
@property(nonatomic,assign)BOOL tableToTopViewShow;


-(void)scrollsToTop;
@end
