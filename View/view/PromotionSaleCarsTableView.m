//
//  PromotionSaleCarsTableView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionSaleCarsTableView.h"

#import "PromotionMoreTableViewHeaderFooterView.h"
#import "PromotionTableViewHeaderFooterView.h"
#import "PromotionTableViewCell.h"

#define open @"1"
#define close @"0"

@interface PromotionSaleCarsTableView()

@property(nonatomic,strong)NSMutableDictionary *sectionDic;
@property(nonatomic,copy)NSMutableDictionary *temp_sectionDic;

@property(nonatomic,strong)PromotionSaleCarModel *targetModel;
@property(nonatomic,assign)int openSection;

@end

@implementation PromotionSaleCarsTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.openSection = -1;
        self.sectionDic = [[NSMutableDictionary alloc]init];
        self.temp_sectionDic =[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:nibFromClass(PromotionTableViewCell) forCellReuseIdentifier:@"PromotionTableViewCell"];
        
        [self registerClass:[PromotionTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PromotionTableViewHeaderFooterView"];
        
        [self registerClass:[PromotionMoreTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"PromotionMoreTableViewHeaderFooterView"];
    }
    return self;
}


-(void)setData:(PromotionSaleCarModel *)model{
    self.targetModel = model;
    [self reloadData];
}

#pragma table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.targetModel.typeinfo.count == 0) {
        [tableView showWithOutDataViewWithTitle:@"暂无车型"];
        return 0;
    }else{
        [tableView dismissWithOutDataView];
        return self.targetModel.typeinfo.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma 头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    PromotionTableViewHeaderFooterView *headerView= [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PromotionTableViewHeaderFooterView"];
    [headerView setData:self.targetModel Count:section];
    headerView.button.tag = section;
    
    if ([[self.temp_sectionDic objectForKey:[self int2string:section]] isEqual:open]){
        headerView.button.selected = YES;
    }else{
        headerView.button.selected = NO;
    }
    
    [headerView.button addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
    
}
-(void)headerViewClicked:(UIButton*)button{
    
    if ([[self.sectionDic objectForKey:[self int2string:button.tag]] isEqual:open]){
        [self.sectionDic setObject:close forKey:[self int2string:button.tag]];
        //        [self.temp_sectionDic setObject:close forKey:[self int2string:button.tag]];
        button.selected = NO;
        self.temp_sectionDic = [self.sectionDic copy];
        //更新对应的section
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:button.tag];
        
        [UIView performWithoutAnimation:^{
           [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    }else{
        if (self.sectionDic.count>0) {
            //全部关闭，只打开对应的列表
            for (NSString *key in self.temp_sectionDic) {
                [self.sectionDic setObject:close forKey:key];
            }
        }
        
        [self.sectionDic setObject:open forKey:[self int2string:button.tag]];
        self.temp_sectionDic = [self.sectionDic copy];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:button.tag];
        
        [UIView performWithoutAnimation:^{
            [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [self layoutIfNeeded];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath * position = [NSIndexPath indexPathForRow:0 inSection:button.tag];
            //刷新完成
            [self scrollToRowAtIndexPath:position atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }

}

#pragma 中部

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.sectionDic objectForKey:[self int2string:indexPath.section]] isEqual:open]) {
        PromotionTypeInfoModel *carList = self.targetModel.typeinfo[indexPath.section];
        __block CGFloat height = 0;
        [carList.carlist enumerateObjectsUsingBlock:^(PromotionCarList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            height +=   obj.carlist.count*102;
            height+= 30;
        }];
        return height;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromotionTableViewCell" forIndexPath:indexPath];
    cell.dealerId = self.dealer;
    [cell SetData:self.targetModel Count:indexPath.section];
    return cell;
}

-(NSString *)int2string:(NSInteger) count{
    return [NSString stringWithFormat:@"%ld",count];
}

#pragma 尾部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([[self.sectionDic objectForKey:[self int2string:section]] isEqual:open]) {
        return 54;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    PromotionMoreTableViewHeaderFooterView *view = [[PromotionMoreTableViewHeaderFooterView alloc]init];
    view.label.text=@"点击收起";
    view.label.font = FontOfSize(14);
    view.label.textColor = BlackColorBBBBBB;
    
    view.backgroundColorLabel.tag = section;
    [view.backgroundColorLabel addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    view.image.image = [UIImage imageNamed:@"箭头向上"];
    [view.backgroundColorLabel setBackgroundColor:[UIColor clearColor]];
    
    [view.contentView setBackgroundColor:[UIColor whiteColor]];
    
    
    [view setTopLine];
    if ([[self.sectionDic objectForKey:[self int2string:section]] isEqual:open]) {
        return view;
    }
        return nil;
    
}





@end
