//
//  FindCarByGroupTableView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FindCarByGroupTableView.h"
#import "FindCarByGroupTableViewCell.h"
#import "SelectCarTypeViewController.h"
#import "CarDeptViewController.h"
@interface FindCarByGroupTableView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) FindCarByGroupGetCarListViewModel*viewModel;
@end
@implementation FindCarByGroupTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.viewModel = [FindCarByGroupGetCarListViewModel
                          SceneModel];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerNib:nibFromClass(FindCarByGroupTableViewCell) forCellReuseIdentifier:classNameFromClass(FindCarByGroupTableViewCell)];
        
        @weakify(self);
        self.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self headerRefresh];
        }];
      
        [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.mj_footer endRefreshing];
            [self.mj_header endRefreshing];
            [[GCDQueue mainQueue]queueBlock:^{
                self.viewModel.request.page = self.viewModel.model.curPage;
                if (self.viewModel.model.data.count >0) {
                    self.viewModel.carListArray = [self.viewModel.model success:self.viewModel.carListArray newArray:self.viewModel.model.data];
                   
                        if (self.mj_footer==nil) {
                            self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                                @strongify(self);
                                [self footerRefresh];
                            }];
                        }
                    
                     [self dismissWithOutDataView];
                }else{
                     if (self.viewModel.carListArray.count >0) {
                        [self.mj_footer setState:MJRefreshStateNoMoreData];
                        [self dismissWithOutDataView];
                    }else{
                        [self showWithOutDataViewWithTitle:@"暂无车辆"];
                    }
                }
               
               
                //            if (self.reloadDataFinishedBlock) {
                //                self.reloadDataFinishedBlock(self.viewModel.model.list.count);
                //            }
                
                [self reloadData];
            }];
          
        }];
        [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.request.failed;
        }]subscribeNext:^(id x) {
            [[GCDQueue mainQueue]queueBlock:^{
                [self.mj_footer endRefreshing];
                [self.mj_header endRefreshing];
                self.viewModel.request.page = self.viewModel.model.curPage;
                //            if (self.reloadDataFinishedBlock) {
                //                self.reloadDataFinishedBlock(self.viewModel.model.list.count);
                //            }
                [self showWithOutDataViewWithTitle:@"网络或服务器异常" ];            }];

           
        }];
        
    }
   
    return self;
}
//-(void)setCurrentDate:(NSString *)currentDate{
//    if (![_currentDate isEqual:currentDate]) {
//        _currentDate = currentDate;
//    }
//    self.viewModel.request.date = currentDate;
//    self.viewModel.request.startRequest = YES;
//}
-(void)setConditionModel:(FindCarByGroupGetConditionModel *)conditionModel{
    _conditionModel = conditionModel;
     self.viewModel.request.page = 1;
    self.viewModel.request.type = self.conditionModel.type;
//    self.viewModel.request.price = [NSString stringWithFormat:@"%ld_%ld",self.conditionModel.minPrice,self.conditionModel.maxPrice];
    [self.mj_header beginRefreshing];
}
-(void)headerRefresh{
    self.viewModel.request.page = 1;
    self.viewModel.request.startRequest = YES;
}
-(void)footerRefresh{
    self.viewModel.request.page ++;
     self.viewModel.request.startRequest = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
    }
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.carListArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.000001;
    }
    return 10;
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
    FindCarByGroupTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(FindCarByGroupTableViewCell) forIndexPath:indexPath];
    
    FindCarByGroupGetCarModel*model = self.viewModel.carListArray[indexPath.section];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
    cell.nameLabel.text = model.name;
    cell.priceLabel.text = model.guidePrice;
    NSString *info= [NSString stringWithFormat:@"共%@款车型符合要求",model.num];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:info];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:RedColorFF2525 range:NSMakeRange(1, model.num.length)];
    cell.CarCountLabel.attributedText = attributedStr;

    
    cell.CarNumberButton.tag = indexPath.section;
    [cell.CarNumberButton addTarget:self action:@selector(carNumberClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     FindCarByGroupGetCarModel*model = self.viewModel.carListArray[indexPath.section];
    CarDeptViewController*vc = [[CarDeptViewController alloc]init];
    vc.chexiid = model.carSeriesId;
    if (model.picUrl.isNotEmpty) {
        vc.picture = model.picUrl;
    }else{
        vc.picture = model.pic_url;
    }
    
    
    [URLNavigation pushViewController:vc animated:YES];
}
-(void)carNumberClicked:(UIButton*)button{
    FindCarByGroupGetCarModel*model = self.viewModel.carListArray[button.tag];
    SelectCarTypeViewController*vc = [[SelectCarTypeViewController alloc]init];
    vc.type = self.conditionModel.type;
    vc.typeId = [model.carSeriesId integerValue];
    [URLNavigation pushViewController:vc animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
