//
//  PromotionTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionTableViewCell.h"

#import "PromotionCarList.h"
#import "PromotionSaleCarTableViewCell.h"

#import "PromotionMoreTableViewHeaderFooterView.h"
#import "PromotionTitleHeaderFooterView.h"
#import "DealerCarInfoViewController.h"


@interface PromotionTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)PromotionSaleCarModel *model;

@property(nonatomic,strong)PromotionTypeInfoModel *car;

@property(nonatomic,strong)PromotionCarList *singlelist;
@end

@implementation PromotionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SetData:(PromotionSaleCarModel *)model Count:(NSInteger) section{
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    [self.tableview registerNib:nibFromClass(PromotionSaleCarTableViewCell) forCellReuseIdentifier:@"PromotionSaleCarTableViewCell"];
    [self.tableview registerClass:[PromotionTitleHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PromotionTitleHeaderFooterView"];
    self.model = model;
    self.car = self.model.typeinfo[section];
    [self.tableview reloadData];
}

-(void)SetDataList:(PromotionCarList *)model{
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    [self.tableview registerNib:nibFromClass(PromotionSaleCarTableViewCell) forCellReuseIdentifier:@"PromotionSaleCarTableViewCell"];
    self.singlelist = model;
    [self.tableview reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionCarList *list = self.car.carlist[indexPath.section];
    PromotionCarModel *info = list.carlist[indexPath.row];
    
    DealerCarInfoViewController *vc = [[DealerCarInfoViewController alloc] init];
    vc.typeId = self.car.typeId;
    vc.dealerId  = self.dealerId;
    vc.carId = info.carid;
    [URLNavigation pushViewController:vc animated:YES];
}

#pragma table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.car.carlist.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PromotionCarList *list = self.car.carlist[section];
    return list.carlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionSaleCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionSaleCarTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    PromotionCarList *list = self.car.carlist[indexPath.section];
    PromotionCarModel *info = list.carlist[indexPath.row];
    cell.delearId = self.dealerId;
    [cell setDataWithModel:info];
    return cell;
}

#pragma 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PromotionTitleHeaderFooterView *headview = [[PromotionTitleHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 30)];

    PromotionCarList *list = self.car.carlist[section];
    headview.label.text = list.title;

    return headview;
    
}

#pragma 尾部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 00000.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}
@end
