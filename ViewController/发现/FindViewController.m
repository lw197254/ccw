//
//  FindViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FindViewController.h"
#import "ActiveViewController.h"

#import "FindeTableViewCell.h"
#import "FindViewModel.h"
#import "FindTongJiViewModel.h"

#import "FindListModel.h"
#import "FindBaseModel.h"

@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FindViewModel *viewModel;
@property (strong, nonatomic) FindListModel *baseData;

@property (strong, nonatomic) FindTongJiViewModel *tongjiViewModel;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"发现"];
    
    self.viewModel.request.page = 1;
    self.viewModel.request.startRequest = YES;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    [self.tableView registerNib:nibFromClass(FindeTableViewCell) forCellReuseIdentifier:classNameFromClass(FindeTableViewCell)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.baseData.data.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.baseData.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(FindeTableViewCell) forIndexPath:indexPath];
    [cell setCellData:self.baseData.data[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FindBaseModel *model = self.baseData.data[indexPath.row];
    
    self.tongjiViewModel.request.id = model.id;
    self.tongjiViewModel.request.startRequest = YES;
    
    ActiveViewController*vc = [[ActiveViewController alloc]init];
    vc.urlString = model.url;
    vc.titleString = model.title;
    vc.cityShow = NO;
    [self.rt_navigationController pushViewController:vc animated:YES];
}

-(FindTongJiViewModel *)tongjiViewModel{
    if (!_tongjiViewModel) {
        _tongjiViewModel = [FindTongJiViewModel SceneModel];
    }
    return _tongjiViewModel;
}

-(FindViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [FindViewModel SceneModel];
        
        @weakify(self);
        @weakify(_viewModel);
        [[RACObserve(_viewModel, data)filter:^BOOL(id value) {
            @strongify(self);
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
              @strongify(self);
             @strongify(_viewModel);
            if (x) {
                self.baseData = _viewModel.data;
          
                [self.tableView reloadData];
            }
        }];
    }
    return _viewModel;
}

@end
