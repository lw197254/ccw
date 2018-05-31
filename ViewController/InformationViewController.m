//
//  InformationViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "InformationTypeTableViewCell.h"
#import "InformationViewModel.h"

#import "ArtInfoViewController.h"
#import "DeliverModel.h"
#import "ReadRecordModel.h"
#import "ListSelectView.h"
@interface InformationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet ListSelectView *typeBackgroundView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) InformationViewModel*viewModel;
@property(nonatomic,copy)NSString*catId;

@property (weak, nonatomic) IBOutlet UIView *seperateLine;

@property(nonatomic,strong)NSMutableArray<InformationModel>*list;


@property(strong,nonatomic)DeliverModel *deliverModel;
@property(nonatomic,strong)NSArray<NSString*>*menuArray;
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"资讯"];
    self.seperateLine.backgroundColor = BlackColorE3E3E3;
    self.deliverModel =  [[DeliverModel alloc] init];
    self.list = [[NSMutableArray<InformationModel> alloc] init];
    
    self.viewModel = [InformationViewModel SceneModel];
     self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    [self configMenu];
    [self configData];
    [self configCarTypeData];
    [self configCarSeriesData];
    [self headerRfresh];
    
    @weakify(self);

    self.tableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRfresh];
    }];
    
    
//    self.viewModel.carTypeRequest.
       [self.tableView registerNib:nibFromClass(InformationTableViewCell) forCellReuseIdentifier:classNameFromClass(InformationTableViewCell)];
    // Do any additional setup after loading the view from its nib.
}
-(void)configMenu{
    @weakify(self);
    
    if (self.viewModel.menuModel.menu.count==0) {
        self.viewModel.menuRequst.startRequest = YES;
        [[RACObserve(self.viewModel, menuModel)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.menuModel.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            NSMutableArray*array = [NSMutableArray array];
            [self.viewModel.menuModel.menu enumerateObjectsUsingBlock:^(MenuModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj.typename];
            }];
            self.menuArray = array;
            MenuModel*model =[self.viewModel.menuModel.menu firstObject];
            self.catId = model.id;
        }];
    }else{
        NSMutableArray*array = [NSMutableArray array];
        [self.viewModel.menuModel.menu enumerateObjectsUsingBlock:^(MenuModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj.typename];
        }];
        self.menuArray = array;
        MenuModel*model =[self.viewModel.menuModel.menu firstObject];
        self.catId = model.id;
    }

}
-(void)configData{
    @weakify(self);
    if (self.tableView.mj_footer==nil) {
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self footerRefresh];
        }];
        self.tableView.mj_footer.automaticallyHidden = YES;
    }

    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        if (self.viewModel.list.count ==0) {
            [self.tableView showWithOutDataViewWithTitle:@"未找到相关资讯"];
            
            
            
        }else{
            if (self.viewModel.model.list.count==0) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
            }else if(self.viewModel.model.list.count<10){
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                ((MJRefreshAutoNormalFooter*)self.tableView.mj_footer).stateLabel.text = @"";
            }
            
            [self.list removeAllObjects];
           [self.list addObjectsFromArray:self.viewModel.list];
             [self.deliverModel deliverInformationModel:self.list];
            [self.tableView dismissWithOutDataView];
        }
        
        [self.tableView reloadData];
    }];

}
-(void)configCarSeriesData{
    @weakify(self);
    [[RACObserve(self.viewModel.carSeriesRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.carSeriesRequest.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (self.viewModel.list.count ==0) {
            [self.tableView showNetLost];
        }
        
    }];
    
}
-(void)configCarTypeData{
    @weakify(self);
    [[RACObserve(self.viewModel.carTypeRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.carTypeRequest.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.viewModel.list.count ==0) {
            [self.tableView showWithOutDataViewWithTitle:@"未找到相关资讯"];
            
            
        }else{
            if (self.tableView.mj_footer==nil) {
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    @strongify(self);
                    [self footerRefresh];
                }];
            }
            
            
        }
        [self.tableView reloadData];
    }];

}

- (IBAction)typeClicked:(UIButton *)sender {
    sender.selected =!sender.selected;
    @weakify(self);
    if (sender.selected) {
        
       [self.typeBackgroundView showWithlistArray:self.menuArray selectedString:self.typeLabel.text animationComplation:^(BOOL isFinished) {
           
       } itemSelectedBlock:^(NSInteger index, NSString *itemString) {
           @strongify(self);
           MenuModel*model =self.viewModel.menuModel.menu [index];
           self.typeLabel.text = model.typename;
           self.catId = model.id;
           [self.tableView.mj_header beginRefreshing];
           sender.selected = NO;

       } dismissAnimationCompletionBlock:^(BOOL isFinished) {
           sender.selected = NO;
       }];
    }else{
            @strongify(self);
        [self.typeBackgroundView dismissWithAnimationComplation:^(BOOL isFinished) {
            sender.selected = NO;
        }];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.list.count;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return UITableViewAutomaticDimension;
   
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        return 80;
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
           InformationTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(InformationTableViewCell) forIndexPath:indexPath];
        InformationModel*model = self.list[indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
        cell.titleLabel.text = model.title;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       cell.commentCountLabel.text = model.authorName;
       cell.dateLabel.text = [NSString stringWithFormat:@"%@人阅读",model.click];
        
        if ([model.isRead isEqualToString:isread]) {
            cell.titleLabel.textColor = BlackColor999999;
        }else{
            cell.titleLabel.textColor = BlackColor333333;
        }
        
        return cell;
    }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        InformationModel*model = self.list[indexPath.row];
        ArtInfoViewController*vc = [[ArtInfoViewController alloc]init];
        vc.aid = model.id;
        
//        vc.listInfo = [[PicShowModel alloc]init];
//        vc.listInfo.id = model.id;
//        vc.listInfo.title = model.title;
//        vc.listInfo.thumb = model.thumb;
//        vc.listInfo.inputtime = model.inputtime;
//        vc.listInfo.click = model.click;
//        vc.listInfo.authorName = model.authorName;
//
//    vc.aid =
        vc.artType = wenzhang;
    
        [self.rt_navigationController pushViewController:vc animated:YES];
        
        if ([model.isRead isEqualToString:notread]) {
            model.isRead = isread;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    
    

}
-(void)headerRfresh{
   
    if(self.carTypeId.isNotEmpty){
        self.viewModel.carTypeRequest.chexingId = self.carTypeId;
        self.viewModel.carTypeRequest.catId = self.catId;
        self.viewModel.carTypeRequest.page = 1;
        self.viewModel.carTypeRequest.startRequest = YES;
    }else{
        self.viewModel.carSeriesRequest.chexiId = self.carSeriesId;
        self.viewModel.carSeriesRequest.catId = self.catId;
        self.viewModel.carSeriesRequest.page = 1;
        self.viewModel.carSeriesRequest.startRequest = YES;
    }

}
-(void)footerRefresh{
    if(self.carTypeId.isNotEmpty){
       
        self.viewModel.carTypeRequest.catId = self.catId;
        
        self.viewModel.carTypeRequest.startRequest = YES;
    }else{
       
        self.viewModel.carSeriesRequest.catId = self.catId;
       
        self.viewModel.carSeriesRequest.startRequest = YES;
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
