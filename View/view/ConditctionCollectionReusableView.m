//
//  ConditctionCollectionReusableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ConditctionCollectionReusableView.h"
#import "CondictionTableViewCell.h"

@interface ConditctionCollectionReusableView()<UITableViewDelegate,UITableViewDataSource>

@property (assign,nonatomic) CGFloat rowheight;
@end

@implementation ConditctionCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:nibFromClass(CondictionTableViewCell) forCellReuseIdentifier:classNameFromClass(CondictionTableViewCell)];
}

-(void)updateView{
    [self.tableView reloadData];
    [self layoutIfNeeded];
    self.height = self.tableView.contentSize.height;
    if (self.block) {
        self.block(self.tableView.contentSize.height);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.dict isNotEmpty]) {
        return 1;
    }else{
        return 0;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dict[@"list"];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CondictionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CondictionTableViewCell)];
     NSArray *array = self.dict[@"list"];
     NSString*value =array[indexPath.row][@"value"];
    cell.subtitle.text = value;
    NSArray *arraylist = array[indexPath.row][@"list"];
    cell.arraylist = arraylist;
    [cell updateView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}





@end
