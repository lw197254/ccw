//
//  SalesInformationViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SalesInformationViewController.h"
#import "SalesInformationTableViewCell.h"
#import "SalesInfoViewModel.h"

#import "PromotionViewController.h"

#define limitcount 10;

@interface SalesInformationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)SalesInfoViewModel *saleViewModel;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger limit;

@property(nonatomic,strong)NSMutableArray<SalesInformationModel*> *data;

@end

@implementation SalesInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.limit = 10;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self showNavigationTitle:@"促销信息"];
    
    self.data = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self initTable];
    [self initData];
    
}


-(void)initData{
    self.saleViewModel = [SalesInfoViewModel  SceneModel];
    self.saleViewModel.request.dealerId=self.dealerId;//@"6755";
    self.saleViewModel.request.page = self.page;
    self.saleViewModel.request.limit = limitcount;
    
    [self.tableView.mj_header beginRefreshing];
    @weakify(self);
    [[RACObserve(self.saleViewModel, data)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.saleViewModel.data.isNotEmpty;
     }]subscribeNext:^(id x) {
           @strongify(self);
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];

         
         
         if (self.saleViewModel.data.data.count==0) {
          [self.tableView showWithOutDataViewWithTitle:@"暂无促销信息"];
             [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
             ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
         }else{
             [self.tableView dismissWithOutDataView];
             
             if(self.data.count< 10){
                 [self.data addObjectsFromArray:self.saleViewModel.data.data];
                 [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
              ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
                 
             }else{
                 if(self.tableView.mj_footer==nil){
                      @weakify(self);
                     self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
                         @strongify(self);
                         self.saleViewModel.request.page = self.page;
                         self.saleViewModel.request.startRequest =YES;
                     }];
                 }
                 
                 self.page++;
                 [self.data addObjectsFromArray:self.saleViewModel.data.data];
             }
         }
         

         
        [self.tableView reloadData];
         
     }];
    
    [[RACObserve(self.saleViewModel.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.saleViewModel.request.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView showNetLost];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
}


-(void)initTable{
    [self.tableView registerNib:nibFromClass(SalesInformationTableViewCell) forCellReuseIdentifier:classNameFromClass(SalesInformationTableViewCell)];
        @weakify(self);
        self.tableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self.data removeAllObjects];
            self.saleViewModel.request.page = self.page;
            self.saleViewModel.request.startRequest =YES;
        }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  
  return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SalesInformationTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(SalesInformationTableViewCell) forIndexPath:indexPath];
    
    SalesInformationModel *model =self.data[indexPath.row];
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.titleLabel.text = model.title;
    cell.dateLabel.text =model.inputdate;
    
    
    // 文字变色
    NSString *info = [NSString stringWithFormat:@"%@",model.days];
    
    NSMutableAttributedString *ssa = [[NSMutableAttributedString alloc] initWithString:info];
    
    [ssa addAttribute:NSForegroundColorAttributeName value:RedColorFF2525 range:NSMakeRange(0,model.days.length)];
    
     cell.endTimeLabel.attributedText = ssa;
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PromotionViewController *vc = [[PromotionViewController alloc] init];
    SalesInformationModel *model =self.data[indexPath.row];
    vc.dealerId = self.dealerId;
    vc.newsid = model.newsid;
    
    [self.rt_navigationController pushViewController:vc animated:YES];
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
