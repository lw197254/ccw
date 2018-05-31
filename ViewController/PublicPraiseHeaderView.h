//
//  PublicPraiseHeaderView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
#import "KouBeiPaiHangView.h"
#import "RegTag.h"
#import "KouBeiSerieskBData.h"

@interface PublicPraiseHeaderView : UITableViewHeaderFooterView
//@property(nonatomic,strong)RatingBar *bar;
///星级
@property(nonatomic,strong)UILabel *starLabel;
///评论人数
@property(nonatomic,strong)UILabel *commentPeopleNumberLabel;
///排名
@property(nonatomic,strong)UILabel *rankLabel;
///车型个数
@property(nonatomic,strong)UILabel *carTypeNumberLabel;

@property(nonatomic,strong)UIView *oldView;

@property(nonatomic,strong)KouBeiPaiHangView *paihangView;
@property(nonatomic,strong)UIView *tagView;
@property(nonatomic,strong)UIView *upView;
@property(nonatomic,strong)UILabel *moreLeftLabel;
@property(nonatomic,strong)UILabel *moreLeftCountLabel;

@property(nonatomic,copy)NSArray<RegTag> *tags;

@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)KouBeiSerieskBData *seriseKB;
@property(nonatomic,copy)KouBeiSerieskBData *seriseModelKB;
@property(nonatomic,copy)NSString *carname;


-(bool)isNeedShowPaiHang;

//全部口碑的添加 添加这个先要判断是否存在排行
-(void)buildUpView;
//多行条数的口碑添加
-(void)buildTagView;

//数据加载之后刷新界面 具有排行效应的
-(void)reloadSelection;



//这个方法是用来预先计算高度的
-(void)updateView;

@end
