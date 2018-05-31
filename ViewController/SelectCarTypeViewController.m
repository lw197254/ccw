//
//  SelectCarTypeViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SelectCarTypeViewController.h"
#import "SelectCarTypeTableViewCell.h"
#import "CarTypeDetailViewController.h"
#import "SelectCarTypeTableView.h"
#import "FindCarByGroupGetCarListByCarTypeViewModel.h"
#import "CompareDict.h"
#import "HTHorizontalSelectionList.h"
@interface SelectCarTypeViewController ()<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *selectionView;

@property(nonatomic,strong)FindCarByGroupGetCarListByCarTypeViewModel*viewModel;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)FindCarByGroupByCarTypeGetCarListModel*model;
@property(nonatomic,copy)CarTypeCompareSelectedBlock carTypeCompareSelectedBlock;
@property(nonatomic,strong)NSMutableDictionary *selectedDict;
@end

@implementation SelectCarTypeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self headerRefresh];
    [self showNavigationTitle:@"选择车型"];
    self.selectionView.delegate = self;
    self.selectionView.leftSpace = 10;
    self.selectionView.seperateSpace = 20;
    self.selectionView.dataSource = self;
    self.selectionView.selectionIndicatorColor = BlueColor447FF5;
    [self.selectionView setTitleColor:BlueColor447FF5 forState:UIControlStateSelected];
    [self.selectionView setTitleColor:BlackColor999999 forState:UIControlStateNormal];
   
    @weakify(self);
   
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model = self.viewModel.model;
       
        if(self.model.list.count == 0){
            [self.scrollView showWithOutDataViewWithTitle:@"该车系暂无车型"];
        }else{
            [self.scrollView dismissWithOutDataView];
        }
         [self.selectionView reloadData];
        [self configScrollView];
    }];
    [[RACObserve(self.condtionViewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.condtionViewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
       
        
        self.model = self.condtionViewModel.model;
        if(self.model.list.count == 0){
            [self.scrollView showWithOutDataViewWithTitle:@"该车系暂无车型"];
        }else{
            [self.scrollView dismissWithOutDataView];
        }
        [self.selectionView reloadData];
        [self configScrollView];
    }];
    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
         @strongify(self);
        return self.viewModel.request.failed;
    }]subscribeNext:^(id x) {
         @strongify(self);
        
        [self.scrollView showNetLost];
    }];
    [[RACObserve(self.condtionViewModel.request, state)filter:^BOOL(id value) {
         @strongify(self);
        return self.condtionViewModel.request.failed;

    }]subscribeNext:^(id x) {
         @strongify(self);
        
        [self.scrollView showNetLost];
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)configScrollView{
    for (NSInteger i = 0; i < self.model.list.count; i++) {
        FindCarByGroupByCarTypeYearModel*model = self.model.list[i];
        SelectCarTypeTableView*tableView = [[SelectCarTypeTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain carTypeCompareSelectedBlock:self.carTypeCompareSelectedBlock type:self.selectCarType typeId:self.type selectedDict:self.selectedDict carSeriesName:self.carSeriesName model:model];
        
        [self.scrollContentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.scrollContentView);
            make.left.equalTo(self.scrollContentView).with.offset(i*kwidth);
            make.width.equalTo(self.scrollView);
           
        }];
        if (i==self.model.list.count-1) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.scrollContentView);
                
            }];
        }

    }
    
}

-(void)headerRefresh{
    if (self.selectCarType == SelectCarTypeDefault) {
        if (!self.viewModel) {
            self.viewModel = [FindCarByGroupGetCarListByCarTypeViewModel SceneModel];
        }

        self.viewModel.request.type = self.type;
        self.viewModel.request.typeId = self.typeId;
        self.viewModel.request.startRequest = YES;
    }else if(self.selectCarType == SelectCarTypeConditionSelect){
        self.condtionViewModel.request.startRequest = YES;
    }else{
        if (!self.viewModel) {
           self.viewModel = [FindCarByGroupGetCarListByCarTypeViewModel SceneModel];
        }
        
        self.viewModel.request.type = 0;
        self.viewModel.request.typeId = self.typeId;
        
        self.viewModel.request.startRequest = YES;
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectedWithCarTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block type:(SelectCarType)type typeId:(NSInteger )typeId selectedDict:(NSMutableDictionary*)selectedDict{
    self.selectCarType = type;
    
    self.selectedDict = selectedDict;
    self.typeId = typeId;
    if (self.carTypeCompareSelectedBlock!=block) {
        self.carTypeCompareSelectedBlock = block;
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
   
    //如果是按钮点击，则不需要再次变幻状态
    if(scrollView.decelerating&&self.selectionView.selectedButtonIndex != page){
       
        [self.selectionView setSelectedButtonIndex:page];
        [self selectionList:self.selectionView didSelectButtonWithIndex:page];
        
       
    }

    
}
-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.model.list.count;
    
}
-(NSString*)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
       FindCarByGroupByCarTypeYearModel*model = self.model.list[index];
    if ([model.title integerValue] > 0) {
       return [NSString stringWithFormat:@"%@款",model.title];
        
    }
    return [NSString stringWithFormat:@"%@",model.title];
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*kwidth, self.scrollView.contentOffset.y) animated:YES];
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
