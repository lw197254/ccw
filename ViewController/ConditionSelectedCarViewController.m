//
//  ConditionSelectedCarViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ConditionSelectedCarViewController.h"
#import "ConditionSelectedCarPriceView.h"
#import "ConditionSelectCarMoreConditionViewController.h"
#import "CarSeriesViewController.h"
#import "CarSeriesTableViewCell.h"
#import "ConditionSelectCarViewModel.h"
#import "ConditionSelectCarCountModel.h"
#import "BrandMutableSelectViewController.h"
#import "HTHorizontalSelectionList.h"
#import "CarDeptViewController.h"
#define brandSectionKey @"pinpai"
#define priceSectionKey @"price"
@interface ConditionSelectedCarViewController ()<UITableViewDelegate,UITableViewDataSource,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *brandButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet ConditionSelectedCarPriceView *conditionPriceView;
@property (strong, nonatomic) ConditionSelectCarViewModel *viewModel;
@property (assign, nonatomic)  NSInteger minPrice;
@property (assign, nonatomic)  NSInteger maxPrice;
@property (strong, nonatomic)  RACDisposable* priceDispose;
@property (copy, nonatomic)  NSString *priceString;

///选中的条件字典
@property (strong, nonatomic) NSMutableDictionary *otherSelectedDict;

@property (strong, nonatomic) NSArray<ConditionModel*> *selectedArray;
@property (strong, nonatomic) NSMutableArray<ConditionModel*> *priceSelectedArray;
@property (strong, nonatomic) NSMutableArray<ConditionModel*> *otherSelectedArray;
@property (strong, nonatomic) NSMutableArray<ConditionModel*> *brandSelectedArray;

@property (strong, nonatomic)ConditionSelectCarCountModel*countModel;
@property (strong, nonatomic)BrandMutableSelectViewController*brandVC;

@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *conditionHorizontalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionContentViewHeightConstraint;
@end

@implementation ConditionSelectedCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:nibFromClass(CarSeriesTableViewCell) forCellReuseIdentifier:classNameFromClass(CarSeriesTableViewCell)];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self showNavigationTitle:@"条件选车"];
    [self showBarButton:NAV_RIGHT title:@"重置" fontColor:BlackColor666666];
    self.conditionHorizontalView.backgroundColor = BlackColorF8F8F8;
    self.conditionHorizontalView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
    self.conditionHorizontalView.delegate = self;
    self.conditionHorizontalView.dataSource = self;
    self.conditionHorizontalView.leftSpace = 10;
    self.conditionHorizontalView.seperateSpace = 10;
    self.conditionHorizontalView.topSpace = (44-28)/2;
    self.conditionHorizontalView.bottomSpace = (44-28)/2;
    self.conditionHorizontalView.bottomTrimColor = [UIColor clearColor];
    //    self.viewModel.configRequest.startRequest = YES;
    
   
    
    @weakify(self);
    [RACObserve(self.viewModel.countRequest, state)subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.countRequest.succeed) {
            self.countModel = [[ConditionSelectCarCountModel alloc]initWithDictionary:self.viewModel.countRequest.output[@"data"] error:nil];
            
//            self.resultButton.userInteractionEnabled = YES;
//            [self.resultSearchActivityView stopAnimating];
           if (self.countModel.chexiNum==0) {
                [self.conditionPriceView.confirmButton setTitle:[NSString stringWithFormat:@"未找到符合条件的车系"] forState:UIControlStateNormal];
            }else{
                [self.conditionPriceView.confirmButton setTitle:[NSString stringWithFormat:@"共%ld个车系",self.countModel.chexiNum] forState:UIControlStateNormal];
            }
        
        }else if(self.viewModel.countRequest.failed){
//            self.resultButton.userInteractionEnabled = YES;
//            [self.resultSearchActivityView stopAnimating];
            [self.conditionPriceView.confirmButton setTitle:[NSString stringWithFormat:@"未找到符合条件的车系"] forState:UIControlStateNormal];
       }
   }];

    self.tableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self headerRefresh];
    }];
    
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //            if (self.reloadDataFinishedBlock) {
        //                self.reloadDataFinishedBlock(self.viewModel.model.list.count);
        //            }
        
        if (self.viewModel.showList.count==0) {
            [self.tableView showWithOutDataViewWithTitle:@"未找到对应条件的车辆"];
            [self.tableView reloadData];
        }else{
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                @strongify(self);
                [self footerReffresh];
            }];
            if (self.viewModel.model.total <=self.viewModel.showList.count) {
                
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            [self.tableView dismissWithOutDataView];
            [self.tableView reloadData];
        }
        
    }];
    [[RACObserve(self.viewModel.resultRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.resultRequest.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        //            }
        
        [self.tableView showNetLost];
    }];

    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)headerRefresh{
     [self configResultSearch];
    self.viewModel.resultRequest.page = [NSNumber numberWithInteger:1];
    self.viewModel.resultRequest.startRequest = YES;
}
-(void)footerReffresh{
   
    NSInteger page = [self.viewModel.resultRequest.page integerValue];
     [self configResultSearch];
    self.viewModel.resultRequest.page =  [NSNumber numberWithInteger:1+page];
    self.viewModel.resultRequest.startRequest = YES;
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.selectedArray.count;
}
-(UIView*)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    ConditionModel*model = self.selectedArray[index];
    
    return [BrandMutableSelectViewController createBrandButtonWithTitle:model.value];
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    ConditionModel*model = self.selectedArray[index];
    if ([model.sectionKey isEqual: brandSectionKey]) {
        [self.brandSelectedArray removeObject:model];
    }else if ([model.sectionKey isEqualToString:priceSectionKey]){
        [self.priceSelectedArray removeObject:model];
        self.minPrice = 0;
        self.maxPrice = MaxPrice;
    }else{
        [self.otherSelectedArray removeObject:model];
        NSMutableDictionary*sectionDict = [[NSMutableDictionary alloc]initWithDictionary:self.otherSelectedDict[model.sectionKey]];
        if (model.rowKey) {
            NSMutableDictionary*rowDict = [[NSMutableDictionary alloc]initWithDictionary:sectionDict[model.rowKey]] ;
            [rowDict removeObjectForKey:model.value];
            if (rowDict.count > 0) {
                [sectionDict setObject:rowDict forKey:model.rowKey];
            }else{
                [sectionDict removeObjectForKey:model.rowKey];
            }
            
        }else{
            [sectionDict removeObjectForKey:model.value];
        }
        
        if(sectionDict.count > 0){
            [self.otherSelectedDict setObject:sectionDict forKey:model.sectionKey];
        }else{
            [self.otherSelectedDict removeObjectForKey:model.sectionKey];
        }
    }
    
    [self updateSelectedConditonView];
    [self.tableView.mj_header beginRefreshing];
    
}
///车系车型数量查询
-(void)countSearchWithMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice{
    NSArray*array = [self.viewModel.countRequest getAllProperties];
    [array enumerateObjectsUsingBlock:^(NSString* properity, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([properity isEqualToString:priceSectionKey]) {
            self.viewModel.countRequest.price =[NSArray arrayWithObjects:[NSNumber numberWithInteger:minPrice],[NSNumber numberWithInteger:maxPrice], nil];
        }else if ([properity isEqualToString:brandSectionKey]) {
                NSMutableArray*array = [NSMutableArray array];
                [self.brandSelectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [array addObject:obj.index];
                }];
                self.viewModel.countRequest.pinpai = array;
            
        }else if ([properity isEqualToString:@"level"]){
            NSDictionary*sectionDict=  self.otherSelectedDict[properity];
            NSMutableArray*valueArray = [NSMutableArray array];
            [sectionDict.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSArray* values = [((NSDictionary*)obj) allValues];
                    [valueArray addObjectsFromArray:values];
                }else{
                    [valueArray addObject:obj];
                }
            }];
            [self.viewModel.countRequest setValue:valueArray forKey:properity];
            
        }
        else{
            NSDictionary*sectionDict=  self.otherSelectedDict[properity];
            
            
            [self.viewModel.countRequest setValue:sectionDict.allValues forKey:properity];
        }
        
        
    }];
       self.viewModel.countRequest.startRequest = YES;
    //    [RACObserve( self.conditionLabel, text)subscribeNext:^(id x) {
    //            self.viewModel.countRequest.price =
    //    }];
}
-(void)configResultSearch{
    NSArray*array = [self.viewModel.resultRequest getAllProperties];
    [array enumerateObjectsUsingBlock:^(NSString* properity, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if ([properity isEqualToString:priceSectionKey]) {
            
            self.viewModel.resultRequest.price =[NSArray arrayWithObjects:[NSNumber numberWithInteger:self.minPrice],[NSNumber numberWithInteger:self.maxPrice], nil];
        }else if ([properity isEqualToString:brandSectionKey]) {
            NSMutableArray*array = [NSMutableArray array];
            [self.brandSelectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:obj.index];
            }];
            self.viewModel.resultRequest.pinpai = array;
        }else if ([properity isEqualToString:@"level"]){
            NSDictionary*sectionDict=  self.otherSelectedDict[properity];
            NSMutableArray*valueArray = [NSMutableArray array];
            [sectionDict.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSArray* values = [((NSDictionary*)obj) allValues];
                    [valueArray addObjectsFromArray:values];
                }else{
                    [valueArray addObject:obj];
                }
            }];
            [self.viewModel.resultRequest setValue:valueArray forKey:properity];
            
        }
        else{
            NSDictionary*sectionDict=  self.otherSelectedDict[properity];
            [self.viewModel.resultRequest setValue:sectionDict.allValues forKey:properity];
        }
        
        
    }];
    
    
}

- (IBAction)priceButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        @weakify(self);
        NSString*title;
        if (self.priceSelectedArray.count >0) {
            ConditionModel*model = [self.priceSelectedArray firstObject];
            title = model.value;
        }
        
        [self.conditionPriceView showWithPriceButtonTitle:title selctedBlock:^(NSInteger minPrice, NSInteger maxPrice) {
            @strongify(self);
            
            self.minPrice = minPrice;
            self.maxPrice= maxPrice;
             [self.priceSelectedArray removeAllObjects];
            if (maxPrice ==MaxPrice&&minPrice==0) {
                
            }else if (maxPrice==MaxPrice){
                ConditionModel*model = [[ConditionModel alloc]init];
                model.sectionKey = priceSectionKey;

                model.value =[NSString stringWithFormat:@"%ld万以上",minPrice];
                 [self.priceSelectedArray addObject:model];
            }else{
                ConditionModel*model = [[ConditionModel alloc]init];
                model.sectionKey = priceSectionKey;

                model.value =[NSString stringWithFormat:@"%ld-%ld万",minPrice,maxPrice];
                 [self.priceSelectedArray addObject:model];
            }
            
           
           
            [self updateSelectedConditonView];
            self.priceButton.selected = NO;
            [self headerRefresh];
        } priceChangeBlock:^(NSInteger minPrice, NSInteger maxPrice) {
            [self countSearchWithMinPrice:minPrice maxPrice:maxPrice];
            
        }cancelBlock:^{
            self.priceButton.selected = NO;
        } carSeriesCount:self.countModel.chexiNum];
    }else{
        [self.conditionPriceView dismiss];
    }
    
}
- (IBAction)brandButtonClicked:(UIButton *)sender {
    if (self.conditionPriceView.hidden==NO) {
        [self priceButtonClicked:self.priceButton];
    }
    @weakify(self);
    
   
      [self.brandVC resetWithSelectedArray:self.brandSelectedArray selectedFinishedBlock:^(NSArray<ConditionModel *> *selectedArray) {
            @strongify(self);
       ///添加新的品牌
          NSMutableArray*pinpaiArray = [NSMutableArray array];
          [selectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              [pinpaiArray addObject:obj.index];
          }];
          [self.brandSelectedArray removeAllObjects];
          [self.brandSelectedArray addObjectsFromArray:selectedArray];
          self.viewModel.resultRequest.pinpai = pinpaiArray;
           [self headerRefresh];
          [self countSearchWithMinPrice:self.minPrice maxPrice:self.maxPrice];
          
          
          [self updateSelectedConditonView];
      } sectionKey:brandSectionKey];
   
    [self presentViewController:self.brandVC animated:YES completion:nil];
    
}
- (IBAction)moreButtonClicked:(UIButton *)sender {
    if (self.conditionPriceView.hidden==NO) {
        [self priceButtonClicked:self.priceButton];
    }
    ConditionSelectCarMoreConditionViewController*vc = [[ConditionSelectCarMoreConditionViewController alloc]init];
    NSArray*price = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.minPrice],[NSNumber numberWithInteger:self.maxPrice], nil] ;
    [vc resetWithPriceArray:price brandIdArray:self.viewModel.resultRequest.pinpai originalSelectedDict:self.otherSelectedDict originalSelectedArray:self.otherSelectedArray confirmClickedBlock:^(NSDictionary *selectedDict, NSArray<ConditionModel *> *selectedArray,NSInteger chexiNumber) {
        [self.otherSelectedDict removeAllObjects];
        [self.otherSelectedDict setDictionary:selectedDict];
        [self.otherSelectedArray removeAllObjects];
        [self.otherSelectedArray addObjectsFromArray:selectedArray];
        [self configResultSearch];
        [self.conditionHorizontalView reloadData];
        [self headerRefresh];
        if (!self.countModel) {
            self.countModel = [[ConditionSelectCarCountModel alloc]init];
            
        }
        self.countModel.chexiNum = chexiNumber;
    } count:self.countModel.chexiNum];

    [self presentViewController:vc animated:YES completion:^{
       
    }];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.showList.count;
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 0.000001;
//    }
//    return 0;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.000001;
//}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarSeriesTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CarSeriesTableViewCell) forIndexPath:indexPath];
    ConditonSelectCarResultModel*model = self.viewModel.showList[indexPath.section];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
    cell.titleLabel.text = model.name;
    cell.subTitleLabel.text = model.guidePrice;
    //     cell.CarCountLabel.text
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CarDeptViewController*vc = [[CarDeptViewController alloc]init];
    ConditonSelectCarResultModel*model = self.viewModel.showList[indexPath.section];
    vc.chexiid = model.id;
    [URLNavigation pushViewController:vc animated:YES];
}
-(void)updateSelectedConditonView{
    [self.conditionHorizontalView reloadData];
    if (self.selectedArray.count ==0) {
        self.conditionContentViewHeightConstraint.constant = 0;
    }else{
        self.conditionContentViewHeightConstraint.constant = 45;
    }
    
}

-(void)setSelectedConditionModel:(FindCarCondtionModel *)selectedConditionModel{
    
    if (selectedConditionModel!=_selectedConditionModel) {
        _selectedConditionModel = selectedConditionModel;
    }
    if (selectedConditionModel.type == CondtionTypePrice) {
        ConditionModel*model = [[ConditionModel alloc]init];
        model.sectionKey = priceSectionKey;
        model.value =selectedConditionModel.value;
        [self.priceSelectedArray addObject:model];
        
        NSString* temp;
        //这边是修改价格的
        if([model.value length] > 0){
            temp = [model.value substringToIndex:([model.value length]-1)];// 去掉最后一个","
            if([temp containsString:@"-"]){
            NSArray *aArray = [temp componentsSeparatedByString:@"-"];
            self.minPrice = [aArray[0] intValue];
            self.maxPrice = [aArray[1] intValue];
            }else{
                self.minPrice =0;
                self.maxPrice =5;
            }
        }
        
    }else if(selectedConditionModel.type == CondtionTypeLevel){
//        ConditionModel*model = [[ConditionModel alloc]init];
//        model.sectionKey = @"level";
//        model.index = selectedConditionModel.index;
//        
//        model.value =selectedConditionModel.value;
      NSDictionary*level =  [self.viewModel.data firstObject];
        NSArray*list = level[@"list"];
        [list enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
           
                if ([obj[@"index"] integerValue] == [selectedConditionModel.index integerValue] ) {
                     NSMutableDictionary*levelDict = [NSMutableDictionary dictionary];
                    if([obj[@"list"] isKindOfClass:[NSArray class]]){
                        
                         NSArray*arr = obj[@"list"];
                        NSMutableDictionary*dic = [NSMutableDictionary dictionary];
                        [arr enumerateObjectsUsingBlock:^(NSDictionary*mod, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            
                            
                            ConditionModel*mo = [[ConditionModel alloc]init];
                            mo.sectionKey =@"level";
                            mo.rowKey = obj[@"key"];
                            mo.index = mod[@"index"];
                            mo.value = mod[@"value"];
                            
                            [dic setObject:mo.index forKey:mo.value];
                            [self.otherSelectedArray addObject:mo];
                         }];
                        [levelDict setObject:dic forKey:obj[@"key"]];
                         [self.otherSelectedDict setObject:levelDict forKey:@"level"];
                        
                    }else{
                        ConditionModel*mo = [[ConditionModel alloc]init];
                        mo.sectionKey =@"level";
                        mo.rowKey = nil;
                        mo.index = obj[@"index"];
                        mo.value = obj[@"value"];
                        

                        [levelDict setObject:mo.value forKey:mo.index];
                         [self.otherSelectedDict setObject:levelDict forKey:mo.sectionKey];
                    }
                   
                    
                   
                    *stop = YES;
                    
                }else if([obj[@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray*arr = obj[@"list"];
                    __block BOOL findObj = NO;
                    [arr enumerateObjectsUsingBlock:^(NSDictionary*mod, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        
                        
                        if ([mod[@"index"] integerValue] == [selectedConditionModel.index integerValue]) {
                           
                            ConditionModel*mo = [[ConditionModel alloc]init];
                            mo.sectionKey =@"level";
                            mo.rowKey =  obj[@"key"];
                            mo.index = mod[@"index"];
                            mo.value = selectedConditionModel.value;
                            [self.otherSelectedArray addObject:mo];
                            NSMutableDictionary*levelDict = [NSMutableDictionary dictionary];
                            
                           
                                NSDictionary*obj = [NSDictionary dictionaryWithObjectsAndKeys:mo.index,mo.value, nil];
                                [levelDict setObject:obj forKey:mo.rowKey];
                           
                            [self.otherSelectedDict setObject:levelDict forKey:mo.sectionKey];
                            *stop = YES;
                        }
                    }];
                    if (findObj) {
                        *stop = YES;
                    }
                }
        }];
        
        
       
    }else if(selectedConditionModel.type == CondtionTypeZuowei){
        ConditionModel*mo = [[ConditionModel alloc]init];
        mo.sectionKey =@"zws";
        mo.rowKey =  selectedConditionModel.key;
        mo.index = selectedConditionModel.index;
        mo.value = selectedConditionModel.value;
        [self.otherSelectedArray addObject:mo];
        
        NSMutableDictionary*levelDict = [NSMutableDictionary dictionary];
//        NSDictionary*obj = [NSDictionary dictionaryWithObjectsAndKeys:mo.index,mo.value, nil];
        [levelDict setObject:mo.index forKey:mo.rowKey];
        
        [self.otherSelectedDict setObject:levelDict forKey:mo.sectionKey];
    }else if(selectedConditionModel.type == CondtionTypeShushi){
        ConditionModel*mo = [[ConditionModel alloc]init];
        mo.sectionKey =@"shushi";
        mo.rowKey =  selectedConditionModel.key;
        mo.index = selectedConditionModel.index;
        mo.value = selectedConditionModel.value;
        [self.otherSelectedArray addObject:mo];
        
        NSMutableDictionary*levelDict = [NSMutableDictionary dictionary];
        NSDictionary*obj = [NSDictionary dictionaryWithObjectsAndKeys:mo.index,mo.value, nil];
        [levelDict setObject:obj forKey:mo.rowKey];
        
        [self.otherSelectedDict setObject:levelDict forKey:mo.sectionKey];
    }

    
}
///重置
-(void)rightButtonTouch{
    [self.priceSelectedArray removeAllObjects];
    self.minPrice = 0;
    self.maxPrice = MaxPrice;
    [self.brandSelectedArray removeAllObjects];
    [self.otherSelectedDict removeAllObjects];
    [self.otherSelectedArray removeAllObjects];
    [self updateSelectedConditonView];
    [self.tableView.mj_header beginRefreshing];
    [self.conditionPriceView dismiss];
    self.priceButton.selected = NO;
}
-(BrandMutableSelectViewController*)brandVC{
    if (!_brandVC) {
        _brandVC = [[BrandMutableSelectViewController alloc]init];
    }
    return _brandVC;
}
-(NSMutableDictionary*)otherSelectedDict{
    if (!_otherSelectedDict) {
        _otherSelectedDict = [NSMutableDictionary dictionary];
    }
    return _otherSelectedDict;
}
-(NSArray<ConditionModel*>*)selectedArray{
    return [[self.priceSelectedArray arrayByAddingObjectsFromArray:self.brandSelectedArray] arrayByAddingObjectsFromArray:self.otherSelectedArray];
    
}
-(NSMutableArray<ConditionModel*>*)priceSelectedArray{
    if (!_priceSelectedArray) {
        _priceSelectedArray = [NSMutableArray<ConditionModel*> array];
    }
    return _priceSelectedArray;
}
-(NSMutableArray<ConditionModel*>*)brandSelectedArray{
    if (!_brandSelectedArray) {
        _brandSelectedArray = [NSMutableArray<ConditionModel*> array];
    }
    return _brandSelectedArray;
}
-(NSMutableArray<ConditionModel*>*)otherSelectedArray{
    if (!_otherSelectedArray) {
        _otherSelectedArray = [NSMutableArray<ConditionModel*> array];
    }
    return _otherSelectedArray;
}
-(ConditionSelectCarViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [ConditionSelectCarViewModel SceneModel];


    }
    return _viewModel;
}
-(NSInteger)maxPrice{
    if (_maxPrice<=0) {
        _maxPrice = MaxPrice;
    }
    return _maxPrice;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSelectedConditonView];
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
