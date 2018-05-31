//
//  VideoViewListViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoViewListViewController.h"
#import "VideoViewController.h"
#import "VideoViewModel.h"
#import "VideoModel.h"

#import "VideoTableViewCell.h"


@interface VideoViewListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)VideoViewModel *videoViewModel;
//视屏列表
@property (nonatomic,copy) NSMutableArray<VideoModel> *videoList;
@end

@implementation VideoViewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:self.titlename];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:nibFromClass(VideoTableViewCell) forCellReuseIdentifier:classNameFromClass(VideoTableViewCell)];
    
    self.videoViewModel.listRequest.page = 1;
    self.videoViewModel.listRequest.cate = self.catid;
    self.videoViewModel.listRequest.startRequest = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.videoList.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(VideoTableViewCell) forIndexPath:indexPath];
    
    VideoModel *model = self.videoList[indexPath.row];
    
    cell.des.text = model.des;
    cell.title.text = model.title;
    
    [cell.bigimage setImageWithURL:[NSURL URLWithString:model.big_img_url]  placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewController *controller = [[VideoViewController alloc] init];
    VideoModel *model = self.videoList[indexPath.row];
    controller.baseModel = model;
    [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
}

#pragma 懒加载

-(NSMutableArray<VideoModel> *)videoList{
    if (!_videoList) {
        _videoList = [NSMutableArray arrayWithCapacity:1];
    }
    return _videoList;
}

-(VideoViewModel *)videoViewModel
{
    if (!_videoViewModel) {
        _videoViewModel = [VideoViewModel SceneModel];
        _videoViewModel.listRequest.page = 1;
        
        @weakify(self);
        @weakify(_videoViewModel);
        
        [[RACObserve(_videoViewModel,info)
          filter:^BOOL(id value) {
              
              @strongify(_videoViewModel);
              
              return _videoViewModel.info.isNotEmpty;
          }]subscribeNext:^(id x) {
              
               @strongify(self);
               @strongify(_videoViewModel);
              
              [self.tableView.mj_header endRefreshing];
              if (_videoViewModel.listRequest.page == 1) {
                  _videoViewModel.labelRequest.startRequest = YES;
                  [self.videoList removeAllObjects];
                  [self.videoList addObjectsFromArray:_videoViewModel.info.list];
                  
                  
                  if (_videoViewModel.info.list.count ==10) {
                      self.tableView.mj_footer.state = MJRefreshStateIdle;
                      if (self.tableView.mj_footer==nil) {
                          @weakify(self);
                          @weakify(_videoViewModel);
                          self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                              @strongify(self);
                              @strongify(_videoViewModel);
                              [self.tableView.mj_footer beginRefreshing];
                              _videoViewModel.listRequest.page++;
                              _videoViewModel.listRequest.startRequest = YES;
                          }
                                            ];
                      }
                  }else{
                      //无数据活着是显示数据为空
                  }
              }else{
                  [self.tableView.mj_footer endRefreshing];
                  
                  if (_videoViewModel.info.list.count<10) {
                      self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                      ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
                  }else{
                      [self.videoList addObjectsFromArray:_videoViewModel.info.list];
                  }
                  
              }
              [self.tableView reloadData];
          }];
        
    }
    return _videoViewModel;
}

@end
