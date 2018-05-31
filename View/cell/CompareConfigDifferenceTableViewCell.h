//
//  CompareConfigDifferenceTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LineView;
@interface CompareConfigDifferenceTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView*leftTagView;
@property(nonatomic,strong)UIView*rightTagView;
@property(nonatomic,strong)LineView*middleLineView;

@property(nonatomic,strong)UIButton *moreButton;

-(void)setData:(NSString *)info onView:(UIView*)view;
-(void)isneedShowButton:(bool) isshow;
@end
