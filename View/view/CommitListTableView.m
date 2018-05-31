//
//  CommitListTableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/9.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CommitListTableView.h"

#import "CommitHeaderFooterView.h"
//评论
#import "MyCommentTableViewCell.h"
#import "DoubleCommentTableViewCell.h"
#import "DoubleSingleCommentTableViewCell.h"

@interface CommitListTableView()

@property(nonatomic,strong)UITableView *cellTableView;

@end

@implementation CommitListTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame
                               style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.separatorStyle =  UITableViewCellSeparatorStyleNone;
        
        //评论
        [self registerNib:nibFromClass(MyCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(MyCommentTableViewCell)];
        
        [self registerNib:nibFromClass(DoubleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleCommentTableViewCell)];
        
        [self registerNib:nibFromClass(DoubleSingleCommentTableViewCell) forCellReuseIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell)];
        
    }
    return self;
}


#pragma 加载数据

 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.commitList.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commitList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommiteModel *model = self.commitList[indexPath.row];
    if (![model.recontent isNotEmpty]) {
        MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(MyCommentTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setMessageModel:model];
        [cell setMessageModelIndex:indexPath.row];
        [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        
        if (model.maxnum>2) {
            DoubleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleCommentTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setMessageModel:model];
            [cell setMessageModelIndex:indexPath.row];
            [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }else{
            
            DoubleSingleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(DoubleSingleCommentTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell setMessageModel:model];
            [cell setMessageModelIndex:indexPath.row];
            [cell.commite addTarget:self action:@selector(cellCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CommitHeaderFooterView *headview = [[CommitHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 46)];
    headview.label.text = @"评论";
    [headview.image setBackgroundColor:BlackColor333333];

    headview.label.textColor =BlackColor333333;
    headview.contentView.backgroundColor = [UIColor whiteColor];
    [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    return headview;
}
 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

#pragma 点击
-(void)cellCommentMessage:(UIButton *)button{
    if (self.messageBlock) {
        self.messageBlock(button);
    }
 
}

#pragma 功能

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        if (self.block) {
            self.block(scrollView);
        }
}

#pragma 懒加载

-(NSMutableArray *)commitList{
    if (!_commitList) {
        _commitList = [NSMutableArray arrayWithCapacity:5];
    }
    return _commitList;
    
}

@end
