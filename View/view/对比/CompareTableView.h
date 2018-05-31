//
//  CompareTableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompareTopView;
@class NewCompareCarListModel;

@protocol CompareTableViewDelegate

-(void)setTableWay:(bool) swpie;

@end

@interface CompareTableView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIView *parentScrollView;

@property(nonatomic,strong) CompareTopView *topView;

@property (assign, nonatomic) id<CompareTableViewDelegate> tbDelegate;

@property (strong, nonatomic) NewCompareCarListModel *data;

//所有车型
@property(nonatomic,strong)NSArray<NSString*>*carIds;

-(void)loadView;
-(void)loadTableView;
@end
