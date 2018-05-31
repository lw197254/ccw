//
//  FindCarByGroupViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FindCarByGroupViewController.h"
#import "FindCarByGroupViewModel.h"
#import "HTHorizontalSelectionList.h"
#import "FindCarByGroupTableView.h"
#define tableViewTagHeader 100
@interface FindCarByGroupViewController ()<UIScrollViewDelegate,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *headerSelectionView;
@property (strong, nonatomic)  FindCarByGroupViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic)NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation FindCarByGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"人群找车"];
    self.headerSelectionView.delegate = self;
    self.headerSelectionView.dataSource = self;
    self.headerSelectionView.minShowCount = 4;
    self.headerSelectionView.maxShowCount = 5;
    self.headerSelectionView.selectionIndicatorColor = BlueColor447FF5;
    self.viewModel = [FindCarByGroupViewModel SceneModel];
    self.viewModel.getConditionListRequest.startRequest = YES;
        @weakify(self);
    [[RACObserve(self.viewModel, getConditionListModel)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.getConditionListModel.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.headerSelectionView reloadData];
         [self configUI];
    }];
   
    // Do any additional setup after loading the view from its nib.
}
-(void)configUI{
     @weakify(self);
    [self.viewModel.getConditionListModel.data enumerateObjectsUsingBlock:^(FindCarByGroupGetConditionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        FindCarByGroupTableView*tableView = [[FindCarByGroupTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.tag = tableViewTagHeader +idx;
        tableView.conditionModel = obj;
        [self.contentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(kwidth*idx);
            make.width.equalTo(self.view);
            if (idx ==self.viewModel.getConditionListModel.data.count-1) {
                make.right.equalTo(self.contentView);
            }
        }];
    }];
    
}
-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.viewModel.getConditionListModel.data.count;
}
-(NSString*)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    FindCarByGroupGetConditionModel*model = self.viewModel.getConditionListModel.data[index];
    return model.typeName;
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    self.currentPage = index;
    [self.scrollView setContentOffset:CGPointMake(kwidth*index, 0) animated:YES];
  
    FindCarByGroupTableView*tableView = [self.contentView viewWithTag:index+tableViewTagHeader];
    
   
}

- (IBAction)priceButtonClicked:(UIButton *)sender {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        if (current!=self.currentPage) {
            self.currentPage = current;
            //            UIButton*button = [self.titleView viewWithTag:current+buttonTag];
            //            [self selectButton:button];
            [self.headerSelectionView setSelectedButtonIndex:self.currentPage];
            //            NewsTableView*tableView = [self.scrollView.contentView viewWithTag:self.currentPage +tableViewTag ];
            //            self.currentTableView = tableView;
            
            //            [tableView refreshWithCarIdType:self.carIdType];
        }
        
        
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
