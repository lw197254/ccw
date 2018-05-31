//
//  DealerCarPopUIView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerCarPopUIView.h"
#import "ColorTableViewHeaderFooterView.h"
#import "DealerPopTableViewCell.h"

#import "PromotionSaleCarTableViewCell.h"
#import "PromotionTitleHeaderFooterView.h"
#import "PromotionSaleCarModel.h"


@interface DealerCarPopUIView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray<PromotionCarList> *carList;
@end

@implementation DealerCarPopUIView

-(instancetype)init{
    if (self = [super init]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.height.mas_offset(370);
        }];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self initTable];
        //这边还要加一个关闭符号
        
        self.close = [[UIButton alloc] init];
        [self.close setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];;
        [self addSubview:self.close];
        
        [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tableView.mas_top).offset(-20);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.width.mas_equalTo(20);
        }];
        
        self.close.hidden = YES;
        
        self.button = [[UIButton alloc] init];
        [self addSubview:self.button];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self.tableView.mas_top);
        }];
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.7]];
        
    }
    return self;
}

-(void)initTable{
    [self.tableView registerNib:nibFromClass(PromotionSaleCarTableViewCell) forCellReuseIdentifier:@"PromotionSaleCarTableViewCell"];
    
    [self.tableView registerClass:[PromotionTitleHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PromotionTitleHeaderFooterView"];
}


-(void)SetDataList:(NSArray<PromotionCarList> *)model{
    self.carList = model;
    [self.tableView reloadData];
}



#pragma table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.carList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    PromotionCarList *model = self.carList[section];
    return model.carlist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionSaleCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionSaleCarTableViewCell" forIndexPath:indexPath];
    cell.delearId = self.delearId;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    PromotionCarList *model = self.carList[indexPath.section];
    PromotionCarModel *info = model.carlist[indexPath.row];
    [cell setDataWithModel:info];
    return cell;
}

#pragma 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    PromotionTitleHeaderFooterView *headView = [[PromotionTitleHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 30)];
//    PromotionCarList *model = self.carList[section];
//    headView.label.text = model.title;
//    return headView;
    PromotionTitleHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PromotionTitleHeaderFooterView"];
    PromotionCarList *model = self.carList[section];
    headView.label.text = model.title;
    return headView;
}

#pragma 尾部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 00000.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionCarList *model = self.carList[indexPath.section];
    PromotionCarModel *info = model.carlist[indexPath.row];
    self.CallService(info);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
