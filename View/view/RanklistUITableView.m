//
//  RanklistUITableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/29.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "RanklistUITableView.h"
#import "RanklistTableViewCell.h"
#import "PromotionTitleHeaderFooterView.h"
#import "CarDeptViewController.h"

@implementation RanklistUITableView


-(instancetype)init{
    if (self = [super init]) {
        [self registerNib:nibFromClass(RanklistTableViewCell) forCellReuseIdentifier:classNameFromClass(RanklistTableViewCell)];
        
        [self registerClass:[PromotionTitleHeaderFooterView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(PromotionTitleHeaderFooterView)];
        
        
        
        self.delegate = self;
        self.dataSource  = self;
    }
    return  self;
}


#pragma tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RankSectionModel *model = self.cars[section];
    return model.data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.cars.count>0) {
        [self dismissWithOutDataView];
        return self.cars.count;
    }
//    [self showWithOutDataViewWithTitle:@"暂无数据"];
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RanklistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(RanklistTableViewCell)];
    RankSectionModel *md = self.cars[indexPath.section];
    RankModel *model = md.data[indexPath.row];
    cell.carname.text = model.CAR_BRAND_TYPE_NAME;
    cell.price.text  = model.zhidaoPrice;
    cell.flag.titleLabel.textAlignment = NSTextAlignmentCenter;
    cell.sellCount.text = [NSString stringWithFormat:@"%@月份销量: %@台",model
                       .month,model.sales];
    
    if ([model.order_sort intValue] > 3) {
        [cell.flag setTitle:model.order_sort forState:UIControlStateSelected];
        [cell.flag setSelected:YES];
    }else{
        [cell.flag setTitle:model.order_sort forState:UIControlStateNormal];
        [cell.flag setSelected:NO];
    }
    
    [cell.image setImageWithURL:[NSURL URLWithString:model.PIC_URL] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    PromotionTitleHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PromotionTitleHeaderFooterView"];
    RankSectionModel *md = self.cars[section];
    headView.label.text = md.firshChar;
    return headView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarDeptViewController *controller = [[CarDeptViewController alloc]init];
    RankSectionModel *md = self.cars[indexPath.section];
    RankModel *model = md.data[indexPath.row];
    controller.chexiid = model.cxID;
    controller.picture = model.pic_url;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [URLNavigation pushViewController:controller animated:YES];
}


@end
