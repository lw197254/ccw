//
//  BuyCarCalculatorRightListViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BuyCarCalculatorRightListViewController.h"
#import "BuyCarCalculatorRightListTableViewCell.h"
@interface BuyCarCalculatorRightListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray*array;
@property(nonatomic,copy)NSString*selectedItem;
@property(nonatomic,copy)BuyCarCalculatorRightListSelectedBlock block;
@end

@implementation BuyCarCalculatorRightListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerNib:nibFromClass(BuyCarCalculatorRightListTableViewCell) forCellReuseIdentifier:classNameFromClass(BuyCarCalculatorRightListTableViewCell)];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyCarCalculatorRightListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(BuyCarCalculatorRightListTableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.titleButton setTitle:self.array[indexPath.row] forState:UIControlStateNormal];
    if ([self.array[indexPath.row] isEqualToString:self.selectedItem]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        cell.titleButton.selected = YES;
    }else{
        cell.titleButton.selected = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedItem = self.array[indexPath.row];
    if (self.block) {
        self.block(indexPath.row,self.selectedItem);
    }
    [self.rt_navigationController popViewControllerAnimated:YES];
}
-(void)selectWithArray:(NSArray *)array selectedItem:(NSString *)selectedItem selectedBlock:(BuyCarCalculatorRightListSelectedBlock)selectedBlock{
    if (self.array!=array) {
         self.array = array;
    }
    if (self.selectedItem!=selectedItem) {
        self.selectedItem = selectedItem;
    }
    if (self.block!=selectedBlock) {
        self.block = selectedBlock;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
