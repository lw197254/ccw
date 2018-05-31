//
//  CompareContentView.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompareTopView;
@class CompareTableView;

@interface CompareContentView : UIView<UIGestureRecognizerDelegate>

@property (strong ,nonatomic) CompareTopView *topView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CompareTableView *contentView;

@property (assign, nonatomic) bool isNeedparent;


@end
