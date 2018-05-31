//
//  PromotionSaleCarsViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionSaleCarsViewController.h"
#import "HTHorizontalSelectionList.h"

#import "PromotionTableViewHeaderFooterView.h"
#import "PromotionSaleCarTableViewCell.h"

#import "PromotionSaleCarViewModel.h"
#import "PromotionSaleCarModel.h"
#import "PromotionCarModel.h"

#import "PromotionTableViewCell.h"
#import "PromotionMoreTableViewHeaderFooterView.h"

#import "PromotionSaleCarsTableView.h"


@interface PromotionSaleCarsViewController ()<HTHorizontalSelectionListDelegate,UIScrollViewDelegate,HTHorizontalSelectionListDataSource>


@property(nonatomic,strong)HTHorizontalSelectionList *selectionList;

@property(nonatomic,strong)PromotionSaleCarViewModel *carViewModel;

@property(nonatomic,strong)PromotionSaleCarModel *targetModel;
//增加侧滑功能
@property(nonnull,strong)UIScrollView *scrollView;

@property(nonatomic,strong)PromotionSaleCarsTableView *currentTableView;
@property(nonatomic,strong)NSMutableArray<PromotionSaleCarsTableView *> *tableList;

@property(nonatomic,assign)NSInteger currentpage;

@end

@implementation PromotionSaleCarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableList = [[NSMutableArray alloc] init];
    
    [self setNavigationtitle:@"在售车型" textColor:BlackColor333333];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initSelectionList];
    [self initData];
}

-(void)initData{
    self.carViewModel = [PromotionSaleCarViewModel SceneModel];
    self.carViewModel.request.dealerId = self.dealer;
    self.carViewModel.request.startRequest = YES;
    
    
    @weakify(self);
    [[RACObserve(self.carViewModel,data)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.carViewModel.data.isNotEmpty;
     }]subscribeNext:^(id x) {
         @strongify(self);
         if (x) {
             if(self.carViewModel.data.data.count>0){
            self.currentpage = 0;
            self.targetModel = self.carViewModel.data.data[0];
            [self.selectionList reloadData];
            [self initScrollView];
            [self initTableView];
        }
        }
    }];
}

//初始化 ScrollView
-(void)initScrollView{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled =YES;
    [self.scrollView setScrollEnabled:YES];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.selectionList.mas_bottom);
    }];
    //设置滚动视图的位置
    [self.scrollView setContentSize:CGSizeMake(self.carViewModel.data.data.count*kwidth, self.scrollView.bounds.size.height)];
}


#pragma tableView设置
-(void)initTableView{
    
    for (int i = 0; i<self.carViewModel.data.data.count; i++) {
        PromotionSaleCarsTableView *view = [[PromotionSaleCarsTableView alloc] initWithFrame:CGRectMake(i*kwidth,0,kwidth,kheight-self.selectionList.size.height-64) style:UITableViewStylePlain];
        view.estimatedSectionHeaderHeight = 0;
        view.estimatedSectionFooterHeight = 0;
        view.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottom, 0);
        view.dealer = self.dealer;
        [view setData:self.carViewModel.data.data[i]];
        [self.scrollView addSubview:view];
        [self.tableList addObject:view];
    }
  
}
#pragma selectionlist设置

-(void)initSelectionList{
    _selectionList = [[HTHorizontalSelectionList alloc]init];
        
    _selectionList.showRightMaskView = YES;
        
    _selectionList.buttonInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _selectionList.leftSpace = 10;
    _selectionList.rightSpace = 10;
    _selectionList.bottomTrimHidden = YES;
        
    [_selectionList setTitleColor:BlackColor999999 forState:UIControlStateNormal];
        
    _selectionList.selectionIndicatorColor = BlueColor447FF5;
    _selectionList.dataSource = self;
    _selectionList.delegate = self;
    
    [_selectionList setBackgroundColor:BlackColorEFEFF4 ];
    [self.view addSubview:_selectionList];
    //加入seclection
    [_selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.left.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.mas_equalTo(40);
            
        }];

}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.carViewModel.data.data.count;
}

-(NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    PromotionSaleCarModel *model=  self.carViewModel.data.data[index];
    return model.title;
}

-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
//    PromotionSaleCarModel *model = self.carViewModel.data.data[index];
//    self.targetModel = model;
    self.currentpage = index;
    PromotionSaleCarsTableView *view = self.tableList[index];
    [self.scrollView setContentOffset:view.frame.origin animated:YES];
}

//滑动 ScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        NSInteger current = (self.scrollView.contentOffset.x+kwidth/2)/kwidth;
        //如果是按钮点击，则不需要再次变幻状态
        if(scrollView.decelerating&&self.currentpage != current){
            self.currentpage  = current;
            [self.selectionList setSelectedButtonIndex:current];
            [self selectionList:self.selectionList didSelectButtonWithIndex:current];
            NSLog(@"正常切换");
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
