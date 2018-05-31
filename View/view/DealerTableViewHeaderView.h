//
//  DealerTableViewHeaderView.h
//  chechengwang
//
//  Created by 严琪 on 17/3/2.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"
#import "PromotionDearInfoModel.h"

@interface DealerTableViewHeaderView : UITableViewHeaderFooterView<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>

///第一部分的图片
@property(nonatomic,strong)UIView *firstHeadView;
@property(nonatomic,strong)UIImageView *firstImageView;

@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *shopName;

//／商店属性
///销售范围
@property(nonatomic,strong)UILabel *shopProperty1;
///4s店还是综合店
@property(nonatomic,strong)UILabel *shopProperty2;

@property(nonatomic,strong)UIImageView *locationImage;
@property(nonatomic,strong)UILabel *location;

///第二部分的图片
@property(nonatomic,strong)UIView *secondHeadView;
@property(nonatomic,strong)HTHorizontalSelectionList *horizontalSelectionList;

///第三部分的图片
@property(nonatomic,strong)UIView *thridHeadView;
@property(nonatomic,strong)UIImageView *bigImageView;
@property(nonatomic,strong)UILabel *info;

///数据加载
-(void)setHeadData:(PromotionDearInfoModel *)model;
@end
