//
//  SelectCarTypeTableView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoSelectCarTypeTableView.h"
#import "CustomTableViewCell.h"





@interface PhotoSelectCarTypeTableView ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation PhotoSelectCarTypeTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self viewDidLoad];
    }
    return self;
}
- (void)viewDidLoad {
   
   
//    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = BlackColorF1F1F1;
    
//    [self registerNib:nibFromClass(SelectCarTypeTableViewCell) forCellReuseIdentifier:classNameFromClass(SelectCarTypeTableViewCell)];
    
//    @weakify(self);
       // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.model.list.count;
    
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    FindCarByGroupByCarTypeSectionModel*model =self.self.model.list[section];
//    return [NSString stringWithFormat:@"    %@", model.firstChar];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.textLabel.textColor = BlackColor333333;
        cell.textLabel.font = FontOfSize(15);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    CarTypeModel*model = self.model.list[indexPath.row];
    cell.textLabel.text = model.car_name;
    
    
    return cell;
    
}
//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.font = FontOfSize14;
//    
//    header.textLabel.textColor = BlackColor333333;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    CarTypeModel*model = self.model.list[indexPath.row];
    if ([self.selectedImageView.superview isKindOfClass:[UIButton class]]) {
        UIButton*button = (UIButton*)self.selectedImageView.superview;
        [button setSelected:NO];
    }else{
        UITableViewCell*cell = (UITableViewCell*)self.selectedImageView.superview;
        [cell setSelected:NO];
    }
    [cell addSubview: self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell.mas_right).with.offset(-15);
    }];
    if(self.selectedBlock){
        self.selectedBlock(model);
    }
    [[Tool currentNavigationController ] popViewControllerAnimated:YES];

}

@end
