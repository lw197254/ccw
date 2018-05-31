//
//  BrowseUITableView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/18.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BrowseUITableViewDeleteBlock)(NSMutableDictionary *list);
@interface BrowseUITableView : UITableView
@property(nonatomic,assign)bool edited;

@property(nonatomic,assign)bool selectedAll;

@property(nonatomic,assign)NSInteger type;

@property(nonatomic,copy )BrowseUITableViewDeleteBlock  block;
//刷新
-(void)selectStatus;
@end
