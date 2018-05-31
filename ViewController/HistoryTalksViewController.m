//
//  HistoryTalksViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "HistoryTalksViewController.h"

#import "TalkMessageTableViewCell.h"
#import "HistoryTalksViewModel.h"

@interface HistoryTalksViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)HistoryTalksViewModel *viewModel;

@end

@implementation HistoryTalksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self setTitle:@"历史对话"];
    
    [self uiConfig];
    [self initdata];
}


-(void)uiConfig{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:nibFromClass(TalkMessageTableViewCell) forCellReuseIdentifier:classNameFromClass(TalkMessageTableViewCell)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)initdata{
    self.viewModel.request.id = self.model.id;
    self.viewModel.request.aid = self.model.aid;
    NSString *uid = [UserModel shareInstance].uid;
    
    if ([uid isNotEmpty]) {
        self.viewModel.request.uid = uid;
    }else{
         self.viewModel.request.uid = @"0";
    }
    
    [[RACObserve(self.viewModel,data)
    filter:^BOOL(id value) {
        return self.viewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    

    self.viewModel.request.startRequest =YES;
}

#pragma mark tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewModel.data.data.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewModel.data.data.count>0) {
        return self.viewModel.data.data.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TalkMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(TalkMessageTableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommiteModel *model = self.viewModel.data.data[indexPath.row];
    [cell setCurrentData:self.model];
    [cell setMessageData:model];

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(HistoryTalksViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [HistoryTalksViewModel SceneModel];
    }
    return _viewModel;
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
