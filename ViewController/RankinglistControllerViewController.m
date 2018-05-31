//
//  RankinglistControllerViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/29.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "RankinglistControllerViewController.h"
#import "HTHorizontalSelectionList.h"
#import "RanklistUITableView.h"

#import "RankingListViewModel.h"

typedef NS_ENUM(NSInteger,RankType) {
    car = 101,
    suv = 9,
    mpv = 8,
    moresmallcar = 102,
    smallcar = 103,
    middlecar = 104,
    bigcar = 105
};

@interface RankinglistControllerViewController ()<HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *selectionList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic)RanklistUITableView *currentTableView;
@property (strong, nonatomic)NSMutableArray *tableviewlist;

@property(nonatomic,strong)NSArray *array;

@property(nonatomic,assign)NSInteger currentpage;

@property(nonatomic,strong)RankingListViewModel *viewModel;

@end

@implementation RankinglistControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showNavigationTitle:@"热销排行"];
    self.currentpage = 0;
    self.array = @[@"紧凑级",@"SUV",@"微型车",@"小型车",@"中型车",@"中大型车",@"MPV"];
    self.tableviewlist = [NSMutableArray arrayWithCapacity:self.array.count];
    [self initUiConfig];
}

-(void)initUiConfig{
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.selectionList.minShowCount = self.array.count;
    self.selectionList.maxShowCount = self.array.count;
    
     self.selectionList.buttonInsets = UIEdgeInsetsMake(0, 15, 0, 15);
     self.selectionList.leftSpace = 10;
     self.selectionList.rightSpace = 10;
    
    self.selectionList.tintColor = BlueColor447FF5;
    [self.selectionList setTitleColor:BlackColor333333 forState:UIControlStateNormal];
    [self.selectionList setTitleFont:FontOfSize(15)];
    
    self.selectionList.selectionIndicatorColor = BlueColor447FF5;

    
    for (int i = 0; i<self.array.count; i++) {
        RanklistUITableView *view = [[RanklistUITableView alloc] init];
        [self.tableviewlist addObject:view];
        [self.contentView addSubview:view];
        
        switch (i) {
            case 0:
            {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.equalTo(self.contentView);
                    make.width.mas_equalTo(kwidth);
                }];
                
               
            }
                break;
            case 1:
            {
                RanklistUITableView *temp = self.tableviewlist[0];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView);
                    make.left.equalTo(temp.mas_right);
                    make.width.mas_equalTo(kwidth);
                    make.bottom.equalTo(self.contentView);
                }];
                
                
            }
                break;
            case 2:
            {
                RanklistUITableView *temp = self.tableviewlist[1];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView);
                    make.left.equalTo(temp.mas_right);
                    make.width.mas_equalTo(kwidth);
                    make.bottom.equalTo(self.contentView);
                }];
                
            }
                break;
            case 3:
            {
                RanklistUITableView *temp = self.tableviewlist[2];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView);
                    make.left.equalTo(temp.mas_right);
                    make.width.mas_equalTo(kwidth);
                    make.bottom.equalTo(self.contentView);
                }];
                
            }
                break;
            case 4:
            {
                RanklistUITableView *temp = self.tableviewlist[3];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView);
                    make.left.equalTo(temp.mas_right);
                    make.width.mas_equalTo(kwidth);
                    make.bottom.equalTo(self.contentView);
                }];
                
            }
                break;
            case 5:
            {
                RanklistUITableView *temp = self.tableviewlist[4];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView);
                    make.left.equalTo(temp.mas_right);
                    make.width.mas_equalTo(kwidth);
                    make.bottom.equalTo(self.contentView);
                }];
                
            }
                break;
            case 6:
            {
                RanklistUITableView *temp = self.tableviewlist[5];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.contentView);
                    make.left.equalTo(temp.mas_right);
                    make.width.mas_equalTo(kwidth);
                    make.right.equalTo(self.contentView);
                    make.bottom.equalTo(self.contentView);
                }];
                
            }
                break;
            default:
                break;
        }
    }
    
    
    self.currentTableView = self.tableviewlist[0];
    self.viewModel.request.type = car;
    self.viewModel.request.startRequest = YES;

}

#pragma selectionlist

-(NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return self.array[index];
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.array.count;
}

-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    RanklistUITableView* temp = self.tableviewlist[index];
    self.currentTableView = temp;
    [self.scrollView setContentOffset:temp.frame.origin animated:YES];
    switch (index) {
        case 0:
            self.viewModel.request.type = car;
            self.viewModel.request.startRequest = YES;
            break;
        case 1:
            self.viewModel.request.type = suv;
            self.viewModel.request.startRequest = YES;
            break;
        case 2:
            self.viewModel.request.type = moresmallcar;
            self.viewModel.request.startRequest = YES;
            break;
        case 3:
            self.viewModel.request.type = smallcar;
            self.viewModel.request.startRequest = YES;
            break;
        case 4:
            self.viewModel.request.type = middlecar;
            self.viewModel.request.startRequest = YES;
            break;
        case 5:
            self.viewModel.request.type = bigcar;
            self.viewModel.request.startRequest = YES;
            break;
        case 6:
            self.viewModel.request.type = mpv;
            self.viewModel.request.startRequest = YES;
            break;
        default:
            break;
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating&&self.currentpage!=current){
            self.currentpage = current;
            NSLog(@"正常切换");
            [self.selectionList setSelectedButtonIndex:self.currentpage];
            self.currentTableView = self.tableviewlist[self.currentpage];
            switch (self.currentpage) {
                case 0:
                    self.viewModel.request.type = car;
                    self.viewModel.request.startRequest = YES;
                    break;
                case 1:
                    self.viewModel.request.type = suv;
                    self.viewModel.request.startRequest = YES;
                    break;
                case 2:
                    self.viewModel.request.type = moresmallcar;
                    self.viewModel.request.startRequest = YES;
                    break;
                case 3:
                    self.viewModel.request.type = smallcar;
                    self.viewModel.request.startRequest = YES;
                    break;
                case 4:
                    self.viewModel.request.type = middlecar;
                    self.viewModel.request.startRequest = YES;
                    break;
                case 5:
                    self.viewModel.request.type = bigcar;
                    self.viewModel.request.startRequest = YES;
                    break;
                case 6:
                    self.viewModel.request.type = mpv;
                    self.viewModel.request.startRequest = YES;
                    break;
                default:
                    break;
            }

        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(RankingListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [RankingListViewModel SceneModel];
        @weakify(self);
        @weakify(_viewModel);
        [[RACObserve(_viewModel, data)
        filter:^BOOL(id value) {
            @strongify(_viewModel);
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(_viewModel);
            @strongify(self);
            if (x) {
                [self.currentTableView dismissWithOutDataView];
                self.currentTableView.cars = [_viewModel.data.showList copy];
                [self.currentTableView reloadData];
            }else{
                [self.currentTableView showWithOutDataViewWithTitle:@"暂无数据"];
            }
        }];
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
