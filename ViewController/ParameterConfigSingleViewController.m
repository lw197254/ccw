//
//  ParameterConfigSingleViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParameterConfigSingleViewController.h"
#import "ParameterConfigViewController.h"
#import "ParameterViewModel.h"
#import "UIButton+Extend.h"
#import "AskForPriceNewViewController.h"
#import "CompareListViewController.h"
#import "CompareDict.h"
#import "DialogView.h"
#import "BrandViewController.h"
#import "UIView+SeparateLine.h"
///分类选择的视图
#import "ParagramSelectView.h"

#import "CarVikiViewController.h"
#import "ParameterConfigSingleTableViewCell.h"
#import "ParameterConfigSingleHeaderView.h"

 

@interface ParameterConfigSingleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  ParameterViewModel *viewModel;

@property (strong, nonatomic)  NSArray *mapArray;


@property (weak, nonatomic) IBOutlet UIButton *classifyButton;
@property (strong, nonatomic) ParagramSelectView *parameterSelectView;
@property (strong, nonatomic) UILabel *PKCountLabel;
@property (strong, nonatomic)  UIButton *addPKButton;

@property (strong, nonatomic)  UIButton *PKButton;

@end

@implementation ParameterConfigSingleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.s
    
   
    
    
    [self configUI];
    [self configData];
}
-(void)configUI{
  
        [self showNavigationTitle:@"参数配置"];
    self.carTypeLabel.text = self.carTypeName;
    [self.tableView registerClass:[ParameterConfigSingleHeaderView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(ParameterConfigSingleHeaderView)];
    [self.tableView registerNib:nibFromClass(ParameterConfigSingleTableViewCell) forCellReuseIdentifier:classNameFromClass(ParameterConfigSingleTableViewCell)];
    [self showRightButton];
    
}
-(void)showRightButton{
    NSInteger labelWidth = 12;
    NSInteger buttonWidth = 25;
    
    if (!self.addPKButton) {

        self.addPKButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"addGrayNormal.png"]];
         self.addPKButton.frame = CGRectMake(0, 0, buttonWidth+17, 40);
        [self.addPKButton setImage:[UIImage imageNamed:@"addGraySelected.png"] forState:UIControlStateSelected];
         [self.addPKButton setImage:[UIImage imageNamed:@"addGraySelected.png"] forState:UIControlStateHighlighted];
        [self.addPKButton setImage:[UIImage imageNamed:@"addGraySelected.png"] forState:UIControlStateDisabled];
        
        [self.addPKButton addTarget:self action:@selector(addPkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
      
    }

       UIView*PKView;

    if (!self.PKButton) {
        self.PKButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"PKBlack"]];
        [self.PKButton setImage:[UIImage imageNamed:@"PKBlackSelected.png"] forState:UIControlStateSelected];
        [self.PKButton setImage:[UIImage imageNamed:@"PKBlackSelected.png"] forState:UIControlStateHighlighted];
        
       

         NSInteger count = [CompareDict shareInstance].count;
        self.PKCountLabel = [Tool createLabelWithTitle:[NSString stringWithFormat:@"%lu",count] textColor:[UIColor whiteColor] tag:0];
        self.PKCountLabel.font = FontOfSize(9);
        self.PKCountLabel.textAlignment = NSTextAlignmentCenter;
        self.PKCountLabel.layer.masksToBounds = YES;
        self.PKCountLabel.backgroundColor = [UIColor redColor];

        self.PKCountLabel.layer.cornerRadius = labelWidth/2;

        self.PKButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
        self.PKCountLabel.frame = CGRectMake(buttonWidth-labelWidth/2-3, 0, labelWidth, labelWidth);


    }
//    PKView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
//
//    [PKView addSubview:_PKButton];
//    [PKView addSubview:_PKCountLabel];
    [self.PKButton addSubview:self.PKCountLabel];
//    [self.PKButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(PKView);
//        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonWidth));
//    }];
    [self.PKCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PKButton).with.offset(buttonWidth-labelWidth/2-3);
        make.top.equalTo(self.PKButton);
        make.size.mas_equalTo(CGSizeMake(labelWidth, labelWidth));
    }];
  
    
     UIBarButtonItem*PKItem = [[UIBarButtonItem alloc]initWithCustomView:self.PKButton];
    
    UIBarButtonItem*addPKItem = [[UIBarButtonItem alloc]initWithCustomView:self.addPKButton];
   
    CompareDict*dict = [CompareDict shareInstance] ;
    if ([dict objectForKey:self.carId]) {
        [self.addPKButton setEnabled:NO];
    }else{
        self.addPKButton.enabled = YES;
    }
 [self.PKButton addTarget:self action:@selector(PKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems =@[PKItem,addPKItem];


}

-(void)configData{
    self.viewModel = [ParameterViewModel SceneModel];
    if (self.carId.isNotEmpty) {
        self.viewModel.request.carIds = @[self.carId];
        
        self.viewModel.request.startRequest = YES;
    }
    
    @weakify(self);
    [[RACObserve(self.viewModel, data)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        
          [self.tableView reloadData];
        if (self.viewModel.data.count == 0) {
            
          
            [self.tableView showWithOutDataViewWithTitle:@"暂无配置信息"];
            return ;
        }else{
            [self.tableView dismissWithOutDataView];
        }
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mapArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary*dict = self.mapArray[section];
        NSArray*array = dict[@"list"];
        return array.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ParameterConfigSingleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(ParameterConfigSingleHeaderView)];
    NSDictionary*dict = self.mapArray[section];
    //    return dict[@"name"];
    view.titleLabel.text =dict[@"name"];
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParameterConfigSingleTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ParameterConfigSingleTableViewCell) forIndexPath:indexPath];
    NSDictionary*titleDict = self.mapArray[indexPath.section];
            NSArray*array = titleDict[@"list"];
            if(indexPath.row >= array.count){
                cell.titleLabel.text = @"";
                return cell;
            }
    
            NSDictionary*dic = array[indexPath.row];
            NSString*key = [[dic allKeys]firstObject];
    
   
            NSDictionary*valueDict =  [self.viewModel.data firstObject];
            NSString*title = dic[key];
   
    
    
            NSString*value = [valueDict valueForKeyPath:key];
    
            if (!value.isNotEmpty) {
                value = @"-";
            }
    
            cell.titleLabel.text =title;
            cell.subTitleLabel.text = value;
    if ([title isEqual:@"本地参考价"]) {
        cell.subTitleLabel.textColor = RedColorFF2525;
    }else{
        cell.subTitleLabel.textColor = BlackColor666666;
    }
   


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary*dict = self.mapArray[indexPath.section];
    NSString*title;
    NSArray*array = dict[@"list"];
    if(indexPath.row >= array.count){
        title = @"";
        return;
    }
    
    NSDictionary*dic = array[indexPath.row];
    
    
    
    __block NSString*key;
    [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:@"same"]) {
            key = obj;
            *stop = YES;
        }
    }];
    NSString*value =  dic[key];
    CarVikiViewController*vc = [[CarVikiViewController alloc]init];
    
    vc.key = value;
    [self.rt_navigationController pushViewController:vc animated:YES];
}
//#pragma mark -- BSNumbersViewDelegate
//-(NSInteger)numberOfSectionInNumbersView:(BSNumbersView *)numbersView{
//    return self.mapArray.count;
//}
//-(NSInteger)numbersView:(BSNumbersView *)numbersView numberOfRowInSection:(NSInteger)section{
//    NSDictionary*dict = self.mapArray[section];
//    NSArray*array = dict[@"list"];
//    return array.count;
//}
//-(NSInteger)listCountOfNumbersView:(BSNumbersView *)numbersView{
//    return self.dataArray.count+1;
//}
//- (nullable NSString *)numbersView:(BSNumbersView *)numbersView titleForBodyHeaderInSection:(NSInteger)section{
//    NSDictionary*dict = self.mapArray[section];
//    return dict[@"name"];
//}
//-(CGSize)numbersView:(BSNumbersView *)numbersView sizeAtIndexPath:(NSIndexPath *)indexPath list:(NSInteger)list{
//    if (indexPath.section==0&&indexPath.row==askForPirceCellRow) {
//        return CGSizeMake(240/2, 60);
//    }else{
//        return CGSizeMake(240/2, 40);
//    }
//}
//-(UICollectionViewCell*)numbersView:(BSNumbersView *)numbersView viewForHeaderFreezeAtList:(NSInteger)list{
//    ParameterHeaderCollectionViewCell*cell = [numbersView.headerSlideCollectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterHeaderCollectionViewCell) forIndexPath:[NSIndexPath indexPathForRow:list inSection:0]];
//    if (list < self.dataArray.count) {
//        NSDictionary*dict =  self.dataArray[list];
//        //    car_info.car_id	int	车型Id
//        //    car_info.car_name	string	车型名称
//        //    car_info.factory_price	string	厂商指导价
//        //    car_info.sale_state	string	车系销售状态 0：在售 1停售 2 未上市
//        //    car_info.min_price	string	本地经销商最低报价
//        //    car_info.max_price	string	本地经销商最高报价
//        NSString*carName = [dict valueForKeyPath:@"car_info.car_name"];
//        cell.addButton.hidden = YES;
//        
//        
//        cell.titleLabel.hidden = NO;
//        cell.deleteButton.hidden = NO;
//        cell.titleLabel.text = carName;
//        cell.deleteButton.tag = list;
//        [cell.deleteButton addTarget:self action:@selector(deleteList:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        cell.addButton.hidden = NO;
//        [cell.addButton addTarget:self action:@selector(addList:) forControlEvents:UIControlEventTouchUpInside];
//        cell.titleLabel.hidden = YES;
//        cell.deleteButton.hidden = YES;
//        if (self.isCompare&&self.dataArray.count < CompareMaxCount) {
//            [cell.addButton setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
//            cell.addButton.userInteractionEnabled = YES;
//        }else{
//            [cell.addButton setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
//            cell.addButton.userInteractionEnabled = NO;
//        }
//    }
//    return cell;
//}
//-(UICollectionViewCell*)numbersView:(BSNumbersView *)numbersView viewForBodySlideAtIndexPath:(NSIndexPath *)indexPath list:(NSInteger)list{
//    if (list >= self.dataArray.count) {
//        ParameterCollectionViewCell*cell = [numbersView dequeueBodyColletionViewReusableCellWithReuseIdentifier:classNameFromClass(ParameterCollectionViewCell) forIndexPath:indexPath list:list];
//        cell.titleLabel.text = @"";
//        cell.backgroundColor = [UIColor clearColor];
//        return cell;
//    }
//    if (indexPath.section==0&&indexPath.row==askForPirceCellRow) {
//        ParameterAskPriceCollectionViewCell*cell = [numbersView dequeueBodyColletionViewReusableCellWithReuseIdentifier:classNameFromClass(ParameterAskPriceCollectionViewCell) forIndexPath:indexPath list:list];
//        
//        NSDictionary*dict = self.mapArray[indexPath.section];
//        NSArray*array = dict[@"list"];
//        if(indexPath.row >= array.count){
//            cell.titleLabel.text = @"";
//            return cell;
//        }
//        
//        NSDictionary*dic = array[indexPath.row];
//        NSString*key = [[dic allKeys]firstObject];
//        if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
//            cell.backgroundColor = SameColor;
//        }else{
//            cell.backgroundColor = [UIColor clearColor];
//        }
//        
//        NSDictionary*value =  self.dataArray[list];
//        
//        NSString*title = [value valueForKeyPath:key];
//        
//        if (!title.isNotEmpty) {
//            title = @"-";
//        }
//        cell.titleLabel.text = title;
//        cell.askPriceButton.tag = list;
//        
//        //        if([title isEqualToString:@"暂无报价"]||[title isEqualToString:@"-"]){
//        //            cell.askPriceButton.enabled = NO;
//        //        }else{
//        //            cell.askPriceButton.enabled = YES;
//        //        }
//        [cell.askPriceButton addTarget:self action:@selector(askForPrice:) forControlEvents:UIControlEventTouchUpInside];
//        return cell;
//    }else{
//        ParameterCollectionViewCell*cell = [numbersView dequeueBodyColletionViewReusableCellWithReuseIdentifier:classNameFromClass(ParameterCollectionViewCell) forIndexPath:indexPath list:list];
//        
//        NSDictionary*dict = self.mapArray[indexPath.section];
//        NSArray*array = dict[@"list"];
//        if(indexPath.row >= array.count){
//            cell.titleLabel.text = @"";
//            return cell;
//        }
//        
//        NSDictionary*dic = array[indexPath.row];
//        __block NSString*key;
//        [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![obj isEqual:@"same"]) {
//                key = obj;
//                *stop = YES;
//            }
//        }];
//        if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
//            cell.backgroundColor = SameColor;
//        }else{
//            cell.backgroundColor = [UIColor clearColor];
//        }
//        
//        NSDictionary*value =  self.dataArray[list];
//        
//        NSString*title = [value valueForKeyPath:key];
//        if (!title.isNotEmpty) {
//            title = @"-";
//        }
//        cell.titleLabel.text = title;
//        return cell;
//    }
//    
//}
//- (nullable UICollectionViewCell *)numbersView:(BSNumbersView *)numbersView viewForLeftFreezeBackgroundAtIndexPath:(NSIndexPath *)indexPath{
//    ParameterLeftCollectionViewCell*cell = [numbersView.leftBackgroundCollectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterLeftCollectionViewCell) forIndexPath:indexPath];
//    
//    NSDictionary*dict = self.mapArray[indexPath.section];
//    
//    NSArray*array = dict[@"list"];
//    if(indexPath.row >= array.count){
//        cell.titleLabel.text = @"";
//        return cell;
//    }
//    
//    NSDictionary*dic = array[indexPath.row];
//    __block NSString*key;
//    [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (![obj isEqual:@"same"]) {
//            key = obj;
//            *stop = YES;
//        }
//    }];
//    //    if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
//    //        cell.backgroundColor = [UIColor redColor];
//    //    }else{
//    //        cell.backgroundColor = cutlineback;
//    //    }
//    //    if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
//    //        cell.backgroundColor = [UIColor colorWithString:@"0xEDF6FF"];
//    //    }else{
//    //        cell.backgroundColor = [UIColor clearColor];
//    //    }
//    cell.backgroundColor = BackgroundColor;
//    cell.titleLabel.text = dic[key];
//    cell.titleLabel.textColor = LabelTextblackColor;
//    NSLog(@"%@%@",cell.titleLabel.font,cell.titleLabel.textColor);
//    return cell;
//    
//}
//-(UICollectionViewCell*)numbersView:(BSNumbersView *)numbersView viewForLeftFreezeAtIndexPath:(NSIndexPath *)indexPath{
//    ParameterLeftCollectionViewCell*cell = [numbersView.leftBackgroundCollectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterLeftCollectionViewCell) forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.titleLabel.hidden = YES;
//    
//    NSDictionary*dict = self.mapArray[indexPath.section];
//    NSArray*array = dict[@"list"];
//    if(indexPath.row >= array.count){
//        cell.titleLabel.text = @"";
//        return cell;
//    }
//    NSDictionary*dic = array[indexPath.row];
//    __block NSString*key;
//    [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (![obj isEqual:@"same"]) {
//            key = obj;
//            *stop = YES;
//        }
//    }];
//    
//    
//    cell.titleLabel.text = dic[key];
//    
//    return cell;
//    
//}
/////左边栏点击
//-(void)numbersView:(BSNumbersView *)numbersView leftItemSelectedAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    NSDictionary*dict = self.mapArray[indexPath.section];
//    NSString*title;
//    NSArray*array = dict[@"list"];
//    if(indexPath.row >= array.count){
//        title = @"";
//        return;
//    }
//    
//    NSDictionary*dic = array[indexPath.row];
//    
//    
//    
//    __block NSString*key;
//    [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (![obj isEqual:@"same"]) {
//            key = obj;
//            *stop = YES;
//        }
//    }];
//    NSString*value =  dic[key];
//    CarVikiViewController*vc = [[CarVikiViewController alloc]init];
//    
//    vc.key = value;
//    [self.rt_navigationController pushViewController:vc animated:YES];
//    
//    
//}


-(NSArray*)mapArray{
    return self.viewModel.mapArray;
}


//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
//
//// 支持设备自动旋转
//- (BOOL)shouldAutorotate
//{
//    return NO;;
//}
//
//// 支持横屏显示
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//   
//        return  UIInterfaceOrientationMaskPortrait;
//   
//    
//    
//    // 如果该界面仅支持横屏
//    // return UIInterfaceOrientationMaskLandscapeRight；
//}
-(void)leftButtonTouch{
    [super leftButtonTouch];
    if (_parameterSelectView) {
        [_parameterSelectView removeFromSuperview];
    }
    
}
- (IBAction)classifyClicked:(UIButton *)sender {
    sender.selected  = YES;
    NSMutableArray*titleArray = [NSMutableArray array];
    if (!self.parameterSelectView.superview) {
        self.parameterSelectView.viewBottomConstraint.constant +=64;
        UIWindow*window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_parameterSelectView];
        [_parameterSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
    }
   

    [self.mapArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:obj[@"name"]];
    }];
    
    [self.parameterSelectView showWithTitleArray:titleArray titleClicked:^(NSInteger i) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //       [self.numbersView.leftCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }];
}
//- (IBAction)moveToRightClicked:(UIButton *)sender {
//    [self.numbersView moveWithISLeft:NO finishedBlock:^(BOOL isLeftZero, BOOL isRightZero) {
//        if (isLeftZero) {
//            self.moveToLeftButton.hidden = YES;
//        }else{
//            self.moveToLeftButton.hidden = NO;
//        }
//        if (isRightZero) {
//            self.moveToRightButton.hidden = YES;
//        }else{
//            self.moveToRightButton.hidden = NO;
//        }
//    }];
//
//}
//- (IBAction)moveToLeftClicked:(UIButton *)sender {
//    [self.numbersView moveWithISLeft:YES finishedBlock:^(BOOL isLeftZero, BOOL isRightZero) {
//        if (isLeftZero) {
//            self.moveToLeftButton.hidden = YES;
//        }else{
//            self.moveToLeftButton.hidden = NO;
//        }
//        if (isRightZero) {
//            self.moveToRightButton.hidden = YES;
//        }else{
//            self.moveToRightButton.hidden = NO;
//        }
//    }];
//
//}



///加入pk
-(void)addPkButtonClicked:(UIButton*)button{
    if(CompareMaxCount == [CompareDict shareInstance].count){
        [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"最多支持%d款车型！",CompareMaxCount] ];
        return;
    }
    
    
    button.enabled = NO;
    
    FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel alloc]init];
    NSDictionary*dict =  [self.viewModel.data firstObject];
    //    car_info.car_id	int	车型Id
    //    car_info.car_name	string	车型名称
    //    car_info.factory_price	string	厂商指导价
    //    car_info.sale_state	string	车系销售状态 0：在售 1停售 2 未上市
    //    car_info.min_price	string	本地经销商最低报价
    //    car_info.max_price	string	本地经销商最高报价
    /// car_info.reference_price 本地参考价
   
    NSString*factoryPrice = [dict valueForKeyPath:@"car_info.factory_price"];
   
   


    model.car_id = self.carId;
    
    model.car_name = self.carTypeName;
    model.factory_price = factoryPrice;
    
    [[CompareDict shareInstance] setObject:model forKey:self.carId];
    CompareListViewController*vc = [[CompareListViewController alloc]init];
    [vc editCompareSlectedDictWithModel:model isDelete:NO];
    [model save];
    if([CompareDict shareInstance].count == 0){
        self.PKCountLabel.hidden = YES;
    }else{
        self.PKCountLabel.hidden = NO;
        self.PKCountLabel.text =[NSString stringWithFormat:@"%lu",  [CompareDict shareInstance].count];
    }
    
    
    [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"车型添加成功"] ];
    
}
///pk
-(void)PKButtonClicked:(UIButton*)button{
    CompareListViewController*VC = [[CompareListViewController alloc]init];
    [self.rt_navigationController pushViewController:VC animated:YES];
}


- (IBAction)askForPriceClicked:(UIButton *)sender {
    
    //车型配置
    [ClueIdObject setClueId:xunjia_08];
    
    NSDictionary*dict =  [self.viewModel.data firstObject];
    //    car_info.car_id	int	车型Id
    //    car_info.car_name	string	车型名称
    //    car_info.factory_price	string	厂商指导价
    //    car_info.sale_state	string	车系销售状态 0：在售 1停售 2 未上市
    //    car_info.min_price	string	本地经销商最低报价
    //    car_info.max_price	string	本地经销商最高报价
    /// car_info.reference_price 本地参考价
    NSString*carName = [dict valueForKeyPath:@"car_info.car_name"];
    NSString*carid = [dict valueForKeyPath:@"car_info.car_id"];
    NSString*carSeriesId = [dict valueForKeyPath:@"car_info.type_id"];
    AskForPriceNewViewController*vc = [[AskForPriceNewViewController alloc]init];
    
    vc.carTypeId = carid;
    vc.carSerieasId = carSeriesId;
    vc.carTypeName = carName;
    
    [self.rt_navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([CompareDict shareInstance].count == 0){
        self.PKCountLabel.hidden = YES;
    }else{
        self.PKCountLabel.hidden = NO;
        self.PKCountLabel.text =[NSString stringWithFormat:@"%lu",  [CompareDict shareInstance].count];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(ParagramSelectView*)parameterSelectView{
    if (!_parameterSelectView) {
        _parameterSelectView = [[[NSBundle mainBundle]loadNibNamed:classNameFromClass(ParagramSelectView) owner:nil options:nil] firstObject];
           }
    return _parameterSelectView;
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
