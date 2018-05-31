//
//  MySubscribeViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/4/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "MySubscribeViewController.h"
#import "SubscribeTableViewCell.h"
#import "SubscribeDetailViewController.h"
#import "SubjectUserModel.h"

@interface MySubscribeViewController ()

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation MySubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"我的订阅"];
    [self initTable];
    
}

-(void)initTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:nibFromClass(SubscribeTableViewCell) forCellReuseIdentifier:@"SubscribeTableViewCell"];
    
    [self.view addSubview:self.tableView];
    [self.tableView setBackgroundColor:BlackColorF8F8F8];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count >0) {
        return 1;
    }else{
       
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeTableViewCell"];
    
    [cell setData:indexPath.row array:self.dataArray];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTopLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubscribeDetailViewController*vc = [[SubscribeDetailViewController alloc]init];
    vc.model = self.dataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.rt_navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     self.dataArray = [[SubjectUserModel findAll] reverseObjectEnumerator].allObjects;
    [self.tableView reloadData];
    if(self.dataArray.count > 0){
        [self.tableView dismissWithOutDataView];
    }else{
       [self.tableView showWithOutDataViewWithTitle:@"您暂无订阅"]; 
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
