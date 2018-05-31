//
//  CarDeptTableViewHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/2/24.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RegTag.h"

@interface CarDeptTableViewHeaderFooterView : UITableViewHeaderFooterView

@property(nonatomic,copy)NSArray<RegTag> *tags;

@property (nonatomic,strong) UIImageView *image;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,assign)bool noimage;

//下边的蓝色按钮
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;


@property(nonatomic,strong)UIView *downView;
@property(nonatomic,strong)UIView *tagView;
@property(nonatomic,strong)UIView *upView;
@property(nonatomic,strong)UILabel *moreRightLabel;
@property(nonatomic,strong)UILabel *moreLeftLabel;

@property(nonatomic,strong)UIImageView *moreRightImage;

-(void)updateView;

@end
