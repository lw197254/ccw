//
//  NewCarForSaleViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "NewCarForSaleViewController.h"
#import "HTHorizontalSelectionList.h"
#import "DateModel.h"
#import "NewCarForSaleTableView.h"

#define maxMonthCount 8
#define beforeMonthCount 5
#define tableViewTagHeader 100
@interface NewCarForSaleViewController ()

@property (assign, nonatomic)NSInteger currentPage;


@end

@implementation NewCarForSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self showNavigationTitle:@"新车上市"];
  
 
    
    [self configUI];
    
   
    
    
       // Do any additional setup after loading the view from its nib.
}
-(void)configUI{
   
        NewCarForSaleTableView*tableView = [[NewCarForSaleTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
    [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    [tableView.mj_header beginRefreshing];
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
