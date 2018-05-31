//
//  NewCarForSaleTableView.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//



#import "NewCarForSaleTableView.h"
#import "NewCarForSaleTableViewCell.h"
#import "CarDeptViewController.h"
#import "ArtInfoViewController.h"
#import "NewCarForSale2TableViewCell.h"

@interface NewCarForSaleTableView ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UILabel*countLabel;

@end


@implementation NewCarForSaleTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.viewModel = [NewCarForSaleViewModel SceneModel];
        UIView*view = [[UIView alloc]initWithFrame:CGRectZero];
        
        
        self.tableFooterView = view;
        self.backgroundColor = BlackColorF1F1F1;
        self.separatorColor = BlackColorE3E3E3;
        [self registerNib:nibFromClass(NewCarForSaleTableViewCell) forCellReuseIdentifier:classNameFromClass(NewCarForSaleTableViewCell)];
       
         [self registerNib:nibFromClass(NewCarForSale2TableViewCell) forCellReuseIdentifier:classNameFromClass(NewCarForSale2TableViewCell)];
        
        @weakify(self);
        self.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
             @strongify(self);
            [self headerRefresh];
        }];
        //self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           // @strongify(self);
           // [self footerRefresh];
        //}];
        
        [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
           // [self.mj_footer endRefreshing];
            [self.mj_header endRefreshing];
            if (self.reloadDataFinishedBlock) {
                self.reloadDataFinishedBlock(self.viewModel.model.list.count);
            }
           
            if (self.viewModel.model.list.count > 0) {
                //self.viewModel.request.page++;
                [self dismissWithOutDataView];
               
            }else{
                [self showWithOutDataViewWithTitle:@"暂无车辆" ];
               // [self.mj_footer setState:MJRefreshStateNoMoreData];
                
            }
                       [self reloadData];
        }];
        [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.request.failed;
        }]subscribeNext:^(id x) {
          //  [self.mj_footer endRefreshing];
            [self.mj_header endRefreshing];
            if (self.reloadDataFinishedBlock) {
                self.reloadDataFinishedBlock(self.viewModel.model.list.count);
            }
          
            [self showWithOutDataViewWithTitle:@"网络或服务器异常" ];
        }];

    }
    return self;
}


-(void)headerRefresh{
    //self.viewModel.request.page = 1;
    self.viewModel.request.startRequest = YES;
}
-(void)footerRefresh{
    self.viewModel.request.startRequest = YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.model.list.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NewCarForSaleSectionModel*model = self.viewModel.model.list[section];
    return model.list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
      NewCarForSaleSectionModel*model = self.viewModel.model.list[section];
    return model.title;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView*headerView = view;
    headerView.textLabel.font = FontOfSize(14);
    headerView.textLabel.textColor = BlackColor333333;
    headerView.contentView.backgroundColor = BlackColorF1F1F1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NewCarForSaleTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(NewCarForSaleTableViewCell) forIndexPath:indexPath];
        NewCarForSaleSectionModel*sectionModel = self.viewModel.model.list[indexPath.section];
        NewCarForSaleModel*model = sectionModel.list[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
        cell.titleLabel.text = model.name;
        
    
            cell.subTitleLabel.textColor = RedColorFF2525;
            cell.subTitleLabel.text = model.price;
            cell.dateLabel.text = [NSString stringWithFormat:@"上市时间:%@",model.formattime];
          return cell;
    }else{
        NewCarForSale2TableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(NewCarForSale2TableViewCell) forIndexPath:indexPath];
        NewCarForSaleSectionModel*sectionModel = self.viewModel.model.list[indexPath.section];
        NewCarForSaleModel*model = sectionModel.list[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
        cell.titleLabel.text = model.name;
        if ([model.formattime isNotEmpty]) {
             cell.dateLabel.text = [NSString stringWithFormat:@"将于%@上市",model.formattime];
        }else{
             cell.dateLabel.text = @"即将上市";
        }
       
        return cell;
    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewCarForSaleSectionModel*sectionModel = self.viewModel.model.list[indexPath.section];
    NewCarForSaleModel*model = sectionModel.list[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
       if (model.type ==NewCarForSaleTypeOnsale) {
           CarDeptViewController *vc = [[CarDeptViewController alloc]init];
           vc.picture  = model.picUrl;
           vc.chexiid = model.id;
           [URLNavigation pushViewController:vc animated:YES];
       }else{
           ArtInfoViewController*vc = [[ArtInfoViewController alloc]init];
           vc.aid = model.id;
           vc.artType = wenzhang;
           [URLNavigation pushViewController:vc animated:YES];
       }
   
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

