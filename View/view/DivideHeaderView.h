//
//  DivideHeaderView.h
//  chechengwang
//
//  Created by 严琪 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DivideHeaderViewDataSourceDelegate<NSObject>

-(NSInteger)numOfViews;

@end

@protocol DivideHeaderViewDelegate<NSObject>

-(UIView *)buildViewbuildViewForItemWithIndex:(NSInteger) i;

@end


@interface DivideHeaderView : UIView<UIGestureRecognizerDelegate>

@property(nonatomic,weak)id<DivideHeaderViewDataSourceDelegate> dataDelegate;

@property(nonatomic,weak)id<DivideHeaderViewDelegate> delegate;

-(void)reloadData;

@end
