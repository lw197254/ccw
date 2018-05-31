//
//  PromotionCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionCarTableViewCell.h"

#import "PromotionCarList.h"
#import "PromotionSaleCarTableViewCell.h"
#import "CarDeptTableViewHeaderFooterView.h"
#import "PromotionMoreTableViewHeaderFooterView.h"
#import "DealerCarInfoViewController.h"
#import "PromotionTitleHeaderFooterView.h"


@interface PromotionCarTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)PromotionSaleCarModel *model;

@property(nonatomic,strong)PromotionCarList *car;
@end

@implementation PromotionCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)SetDataList:(PromotionCarList *)model{
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    [self.tableview registerNib:nibFromClass(PromotionSaleCarTableViewCell) forCellReuseIdentifier:@"PromotionSaleCarTableViewCell"];
    self.car = model;
    [self.tableview reloadData];
}

#pragma table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.car.carlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PromotionCarModel *info = self.car.carlist[indexPath.row];
//    DealerCarInfoViewController *vc = [[DealerCarInfoViewController alloc] init];
//    vc.carId = info.carid;
//    vc.typeId = info.typeid;
//    vc.dealerId = self.dealerId;
//    [URLNavigation pushViewController:vc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionSaleCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionSaleCarTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    PromotionCarModel *info = self.car.carlist[indexPath.row];
    cell.delearId = self.dealerId;
    [cell setDataWithModel:info];
    return cell;
}

#pragma 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PromotionTitleHeaderFooterView *footView = [[PromotionTitleHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 30)];
    footView.label.text = self.car.title;
    return footView;
    
}

#pragma 尾部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 00000.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}

@end
