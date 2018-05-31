//
//  ParameterConfigViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParameterConfigViewController.h"
#import "BSNumbersView.h"
#import "ParameterCollectionViewCell.h"
#import "ParameterHeaderCollectionViewCell.h"
#import "ParameterAskPriceCollectionViewCell.h"
#import "ParameterCollectionReusableView.h"
#import "ParameterLeftCollectionViewCell.h"
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
///第一次进来的引导图
#import "ParameterLaunchView.h"
#import "CarVikiViewController.h"

#import "CompareListViewController.h"

#define MaxConut 8
#define MinConut 2

#define askForPirceCellRow 1

@interface ParameterConfigViewController ()<BSNumbersViewDelegate>
@property (weak, nonatomic) IBOutlet BSNumbersView *numbersView;
@property (strong, nonatomic)  ParameterViewModel *viewModel;

@property (strong, nonatomic)  NSArray *mapArray;
@property (strong, nonatomic)  NSArray *originMapArray;

@property (strong, nonatomic)  NSMutableArray *hideSameMapArray;
@property (strong, nonatomic)  NSMutableDictionary *selectedDict;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL needReloadHideSameMapArray;
@property(nonatomic,assign)BOOL hideSame;
///是否提示过可以横屏
@property(nonatomic,assign)BOOL hadShowAlert;

@property (weak, nonatomic) IBOutlet UIButton *classifyButton;
@property (strong, nonatomic) ParagramSelectView *parameterSelectView;
///是否可以横屏
@property(nonatomic,assign)BOOL canAutorotate;

@property (strong, nonatomic) NSMutableDictionary *compareSelectedDict;


@end

@implementation ParameterConfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    // Do any additional setup after loading the view, typically from a nib.s
   
    self.viewModel = [ParameterViewModel SceneModel];
    
    self.dataArray =[NSMutableArray array];
    self.hideSameMapArray = [NSMutableArray array];
    NSLog(@"%@",self.mapArray);
    @weakify(self);
    
    [self configUI];

    UIButton*button = [[UIButton alloc]initNavigationButtonWithTitle:@"隐藏相同选项" color:BlueColor447FF5 font:FontOfSize(14)];
    
    button.tintColor = [UIColor clearColor];
    [button setTitle:@"显示全部选项" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(hiddenSameItem:) forControlEvents:UIControlEventTouchUpInside];
    [self showBarButton:NAV_RIGHT button:button];
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
    [[RACObserve(self.viewModel, data)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.data.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.viewModel.data];
        if (self.dataArray.count == 0) {
            [[DialogView sharedInstance]showDlg:self.view textOnly:@"暂无参配信息"];
            [self.numbersView reloadData];
            return ;
        }
        self.needReloadHideSameMapArray = YES;
        ///如果提示引导已经展示过，那么是否可以横屏为yes，否则为no，引导消失后也可以横屏
        self.canAutorotate =   ![ParameterLaunchView showWithDismissBlock:^{
            self.canAutorotate = YES;
            if(self.isCompare){
                [[DialogView sharedInstance]showDlg:self.view textOnly:@"支持横屏对比哟"];
            }else{
                [[DialogView sharedInstance]showDlg:self.view textOnly:@"支持横屏显示哟"];
            }
            self.hadShowAlert = YES;
        }];
        if (!self.hadShowAlert&&self.canAutorotate) {
            if(self.isCompare){
                [[DialogView sharedInstance]showDlg:self.view textOnly:@"支持横屏对比哟"];
            }else{
                [[DialogView sharedInstance]showDlg:self.view textOnly:@"支持横屏显示哟"];
            }
            self.hadShowAlert = YES;
        }
        
        
        [self.numbersView reloadData];
    }];
}

-(void)configUI{
    if (self.isCompare) {
        [self showNavigationTitle:@"车型对比"];
    }else{
        [self showNavigationTitle:@"参数配置"];
    }
    
   self.numbersView.delegate = self;
    
    self.numbersView.layer.borderColor = BlackColorCCCCCC.CGColor;
    self.numbersView.layer.borderWidth = 0.5;
    [self.numbersView.headerSlideCollectionView registerNib:nibFromClass(ParameterHeaderCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ParameterHeaderCollectionViewCell)];
    [self.numbersView.leftCollectionView registerNib:nibFromClass(ParameterLeftCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ParameterLeftCollectionViewCell)];
    [self.numbersView.leftBackgroundCollectionView registerNib:nibFromClass(ParameterLeftCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ParameterLeftCollectionViewCell)];
    [self.numbersView.slideCollectionView registerNib:nibFromClass(ParameterCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ParameterCollectionViewCell)];
    [self.numbersView.slideCollectionView registerNib:nibFromClass(ParameterAskPriceCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ParameterAskPriceCollectionViewCell)];
    
    [self.numbersView reloadData];

}

-(void)initData{
     if([self.typeId isNotEmpty]){
        self.viewModel.carSeariesRequest.typeId = self.typeId;
        self.viewModel.carSeariesRequest.startRequest = YES;
    }
     else if (self.carIds.count>1 || ![self.carIds isNotEmpty]) {
        self.carIds = self.compareSelectedDict.allKeys;
        self.viewModel.request.carIds = self.compareSelectedDict.allKeys;
        self.viewModel.request.startRequest = YES;
    }else{
        self.carIds = self.carIds;
        self.viewModel.request.carIds =  self.carIds;
        self.viewModel.request.startRequest = YES;
    }
}

#pragma mark -- BSNumbersViewDelegate
-(NSInteger)numberOfSectionInNumbersView:(BSNumbersView *)numbersView{
     return self.mapArray.count;
}
-(NSInteger)numbersView:(BSNumbersView *)numbersView numberOfRowInSection:(NSInteger)section{
    NSDictionary*dict = self.mapArray[section];
    NSArray*array = dict[@"list"];
    return array.count;
} 
-(NSInteger)listCountOfNumbersView:(BSNumbersView *)numbersView{
    if (self.dataArray.count == CompareMaxCount) {
        return self.dataArray.count;
    }else if(!self.isCompare){
         return self.dataArray.count;
    }
    return self.dataArray.count+1;
}
- (nullable NSString *)numbersView:(BSNumbersView *)numbersView titleForBodyHeaderInSection:(NSInteger)section{
     NSDictionary*dict = self.mapArray[section];
    return dict[@"name"];
}
-(CGSize)numbersView:(BSNumbersView *)numbersView sizeAtIndexPath:(NSIndexPath *)indexPath list:(NSInteger)list{
    if (indexPath.section==0&&indexPath.row==askForPirceCellRow) {
        return CGSizeMake(240/2, 60);
    }else{
        return CGSizeMake(240/2, 40);
    }
}
-(UICollectionViewCell*)numbersView:(BSNumbersView *)numbersView viewForHeaderFreezeAtList:(NSInteger)list{
    ParameterHeaderCollectionViewCell*cell = [numbersView.headerSlideCollectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterHeaderCollectionViewCell) forIndexPath:[NSIndexPath indexPathForRow:list inSection:0]];
    
   
    
    if (list < self.dataArray.count) {
        NSDictionary*dict =  self.dataArray[list];
        //    car_info.car_id	int	车型Id
        //    car_info.car_name	string	车型名称
        //    car_info.factory_price	string	厂商指导价
        //    car_info.sale_state	string	车系销售状态 0：在售 1停售 2 未上市
        //    car_info.min_price	string	本地经销商最低报价
        //    car_info.max_price	string	本地经销商最高报价
        NSString*carName = [dict valueForKeyPath:@"car_info.car_name"];
        cell.addButton.hidden = YES;
       
        
        cell.titleLabel.hidden = NO;
        cell.deleteButton.hidden = NO;
        cell.titleLabel.text = carName;
        cell.deleteButton.tag = list;
        [cell.deleteButton addTarget:self action:@selector(deleteList:) forControlEvents:UIControlEventTouchUpInside];
        
        //当数量等于2的时候，将按钮隐藏
        if (self.carIds.count<=2) {
            [cell.deleteButton setHidden:YES];
        }else{
            [cell.deleteButton setHidden:NO];
        }

    }else{
        cell.addButton.hidden = NO;
        [cell.addButton addTarget:self action:@selector(addList:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleLabel.hidden = YES;
        cell.deleteButton.hidden = YES;
        if (self.isCompare&&self.dataArray.count < CompareMaxCount) {
            [cell.addButton setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
            cell.addButton.userInteractionEnabled = YES;
        }else{
            [cell.addButton setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
            cell.addButton.userInteractionEnabled = NO;
        }
        
        [cell.deleteButton setHidden:YES];
    }
    
    
    
    return cell;
}
-(UICollectionViewCell*)numbersView:(BSNumbersView *)numbersView viewForBodySlideAtIndexPath:(NSIndexPath *)indexPath list:(NSInteger)list{
      if (list >= self.dataArray.count) {
           ParameterCollectionViewCell*cell = [numbersView dequeueBodyColletionViewReusableCellWithReuseIdentifier:classNameFromClass(ParameterCollectionViewCell) forIndexPath:indexPath list:list];
          cell.titleLabel.text = @"";
          cell.backgroundColor = [UIColor clearColor];
          return cell;
      }
    if (indexPath.section==0&&indexPath.row==askForPirceCellRow) {
        ParameterAskPriceCollectionViewCell*cell = [numbersView dequeueBodyColletionViewReusableCellWithReuseIdentifier:classNameFromClass(ParameterAskPriceCollectionViewCell) forIndexPath:indexPath list:list];
        
        NSDictionary*dict = self.mapArray[indexPath.section];
        NSArray*array = dict[@"list"];
        if(indexPath.row >= array.count){
            cell.titleLabel.text = @"";
            return cell;
        }

        NSDictionary*dic = array[indexPath.row];
        NSString*key = [[dic allKeys]firstObject];
        if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
            cell.backgroundColor = BlueColorEFF7FF;
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        
         NSDictionary*value =  self.dataArray[list];
        
         NSString*title = [value valueForKeyPath:key];
       
        if (!title.isNotEmpty) {
            title = @"-";
        }
        cell.titleLabel.text = title;
        cell.askPriceButton.tag = list;
        
//        if([title isEqualToString:@"暂无报价"]||[title isEqualToString:@"-"]){
//            cell.askPriceButton.enabled = NO;
//        }else{
//            cell.askPriceButton.enabled = YES;
//        }
        [cell.askPriceButton addTarget:self action:@selector(askForPrice:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
         ParameterCollectionViewCell*cell = [numbersView dequeueBodyColletionViewReusableCellWithReuseIdentifier:classNameFromClass(ParameterCollectionViewCell) forIndexPath:indexPath list:list];
       
        NSDictionary*dict = self.mapArray[indexPath.section];
        NSArray*array = dict[@"list"];
        if(indexPath.row >= array.count){
            cell.titleLabel.text = @"";
            return cell;
        }

        NSDictionary*dic = array[indexPath.row];
              __block NSString*key;
         [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if (![obj isEqual:@"same"]) {
                 key = obj;
                 *stop = YES;
             }
        }];
        if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
            cell.backgroundColor = BlueColorEFF7FF;
        }else{
             cell.backgroundColor = [UIColor clearColor];
        }

        NSDictionary*value =  self.dataArray[list];
        
        NSString*title = [value valueForKeyPath:key];
        if (!title.isNotEmpty) {
            title = @"-";
        }
        cell.titleLabel.text = title;
        return cell;
    }

}
- (nullable UICollectionViewCell *)numbersView:(BSNumbersView *)numbersView viewForLeftFreezeBackgroundAtIndexPath:(NSIndexPath *)indexPath{
    ParameterLeftCollectionViewCell*cell = [numbersView.leftBackgroundCollectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterLeftCollectionViewCell) forIndexPath:indexPath];
   
    NSDictionary*dict = self.mapArray[indexPath.section];
    
    NSArray*array = dict[@"list"];
    if(indexPath.row >= array.count){
        cell.titleLabel.text = @"";
        return cell;
    }

    NSDictionary*dic = array[indexPath.row];
    __block NSString*key;
    [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:@"same"]) {
            key = obj;
            *stop = YES;
        }
    }];
//    if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
//        cell.backgroundColor = [UIColor redColor];
//    }else{
//        cell.backgroundColor = cutlineback;
//    }
//    if (dic[@"same"]!=nil&&[dic[@"same"] boolValue]==YES) {
//        cell.backgroundColor = [UIColor colorWithString:@"0xEDF6FF"];
//    }else{
//        cell.backgroundColor = [UIColor clearColor];
//    }
    cell.backgroundColor = BlackColorF1F1F1;
     cell.titleLabel.text = dic[key];
    cell.titleLabel.textColor = BlackColor333333;
    NSLog(@"%@%@",cell.titleLabel.font,cell.titleLabel.textColor);
    return cell;

}
-(UICollectionViewCell*)numbersView:(BSNumbersView *)numbersView viewForLeftFreezeAtIndexPath:(NSIndexPath *)indexPath{
    ParameterLeftCollectionViewCell*cell = [numbersView.leftBackgroundCollectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(ParameterLeftCollectionViewCell) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
     cell.titleLabel.hidden = YES;
    
    NSDictionary*dict = self.mapArray[indexPath.section];
    NSArray*array = dict[@"list"];
    if(indexPath.row >= array.count){
        cell.titleLabel.text = @"";
        return cell;
    }
    NSDictionary*dic = array[indexPath.row];
    __block NSString*key;
    [[dic allKeys] enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:@"same"]) {
            key = obj;
            *stop = YES;
        }
    }];
    

    cell.titleLabel.text = dic[key];
   
    return cell;

}
///左边栏点击
-(void)numbersView:(BSNumbersView *)numbersView leftItemSelectedAtIndexPath:(NSIndexPath *)indexPath{
   
   
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
-(void)askForPrice:(UIButton*)button{
    
    if (self.isCompare) {
//        [self showNavigationTitle:@"车型对比"];
          [ClueIdObject setClueId:xunjia_09];
    }else{
//        [self showNavigationTitle:@"参数配置"];
        if ([self.typeId isNotEmpty]) {
             //车系配置
            [ClueIdObject setClueId:xunjia_04];
        }else{
             //车型配置
            [ClueIdObject setClueId:xunjia_08];
        }

        
    }

    
  
    
    NSInteger list = button.tag;
    NSDictionary*dict =  self.dataArray[list];
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
-(void)hiddenSameItem:(UIButton*)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.hideSame = YES;
    }else{
        self.hideSame = NO;
    }
    [self.numbersView reloadData];
    
}
-(NSMutableDictionary*)selectedDict{
    if (!_selectedDict) {
        _selectedDict = [NSMutableDictionary dictionary];
    }
    return _selectedDict;
}
-(NSArray*)mapArray{
    if (self.hideSame) {
        [self handleData];
        _mapArray = self.hideSameMapArray;
    }else{
        [self handleData];
        _mapArray = self.originMapArray;
    }
    return _mapArray;
}
-(void)handleData{
    NSMutableArray*newMapArray = [NSMutableArray array];
    if (self.needReloadHideSameMapArray&&self.dataArray.count >1) {
        [_hideSameMapArray removeAllObjects];
        [self.viewModel.mapArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            NSArray*array = obj[@"list"];
            NSMutableArray*mutableArray = [NSMutableArray array];
            NSMutableArray*new1MapArray = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString*key = [[dict allKeys]firstObject];
                __block NSString*title ;
                __block BOOL isEquel = YES;
                [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary* value, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx==0) {
                        title = [value valueForKeyPath:key];
                    }else{
                        NSString*  newTitle = [value valueForKeyPath:key];
                        if ( ![ title isEqual:newTitle] ) {
                            isEquel = NO;
                        }
                    }
                }];
                NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                if (!isEquel) {
                    [mutableArray addObject:dict];
                    
                    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"same"];
                    
                }else{
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"same"];
                }
                
                [new1MapArray addObject:dic];
                
                
            }];
            if (mutableArray.count!=0) {
                NSDictionary*dic =[NSDictionary dictionaryWithObjectsAndKeys:obj[@"name"],@"name",mutableArray,@"list", nil];
              
                [_hideSameMapArray addObject:dic];
            }
            if (new1MapArray.count !=0) {
                NSDictionary*di =[NSDictionary dictionaryWithObjectsAndKeys:obj[@"name"],@"name",new1MapArray,@"list", nil];
                [newMapArray addObject:di];
            }
            
            
        }];
         self.originMapArray = newMapArray;
        self.needReloadHideSameMapArray = NO;
    }else if (_hideSameMapArray.count==0){
         self.originMapArray = self.viewModel.mapArray;
        [_hideSameMapArray addObjectsFromArray:self.viewModel.mapArray];
        self.needReloadHideSameMapArray = NO;
    }
    
   

}


-(void)addList:(UIButton*)button{
    
    CompareListViewController *vc = [[CompareListViewController alloc] init];
    vc.fatherType = ENUM_ViewController_TypeParamsCompare;
    [self.rt_navigationController pushViewController:vc animated:YES];
//    BrandViewController*VC = [[BrandViewController alloc]init];
//    [self.carIds enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.selectedDict setObject:obj forKey:obj];
//    }];
//    [VC selectedWithCarTypeCompareSelectedBlock:^(FindCarByGroupByCarTypeGetCarModel *model) {
//        self.carIds = [self.carIds arrayByAddingObject:model.car_id];
//        self.viewModel.request.carIds = self.carIds;
//
//        self.viewModel.request.startRequest = YES;
//    } type:SelectCarTypeCompare selectedDict:self.selectedDict ];
//    [self.rt_navigationController pushViewController:VC animated:YES];
    
    
    
   
}
-(void)deleteList:(UIButton*)button{
    
    
    ///最少只能是两个
    if (self.dataArray.count<=CompareMinCount) {
        return;
    }
    
    NSInteger list = button.tag;
    if(list >= self.dataArray.count){
        return;
    }
    NSDictionary*dict =  self.dataArray[list];
     NSString*carid = [dict valueForKeyPath:@"car_info.car_id"];
    
    //删除
    [self editCompareSlectedDictWithCarId:carid];
    
    [self.dataArray removeObjectAtIndex:list];
    NSMutableArray*array = [NSMutableArray arrayWithArray:self.carIds];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:carid]) {
            [array removeObject:obj];
            *stop = YES;
        }
    }];
   
    self.carIds = array;
    
    self.needReloadHideSameMapArray = YES;
    [self.numbersView reloadData];
}





- (BOOL)prefersStatusBarHidden
{
    return NO;
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return self.canAutorotate;
}

// 支持横屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.canAutorotate) {
         // 如果该界面需要支持横竖屏切换
         return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscapeLeft;
    }else{
         return  UIInterfaceOrientationMaskPortrait;
    }
   
  
    // 如果该界面仅支持横屏
    // return UIInterfaceOrientationMaskLandscapeRight；
}
-(void)leftButtonTouch{
    [super leftButtonTouch];
    [self.parameterSelectView removeFromSuperview];
}
- (IBAction)classifyClicked:(UIButton *)sender {
    sender.selected  = YES;
    NSMutableArray*titleArray = [NSMutableArray array];
       [self.mapArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:obj[@"name"]];
    }];
    if (!self.parameterSelectView.superview) {
        UIWindow*window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_parameterSelectView];
        [_parameterSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
        
    }

    [self.parameterSelectView showWithTitleArray:titleArray titleClicked:^(NSInteger i) {
        [self.numbersView scrollToSection:i animated:NO];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.fd_interactivePopDisabled = YES;
    
    [self.compareSelectedDict removeAllObjects];
    NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
    @weakify(self);
    [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
        [self_weak_.compareSelectedDict setObject:model forKey:obj];
    }];
    
    [self_weak_ initData];
   
}
-(ParagramSelectView*)parameterSelectView{
    if (!_parameterSelectView) {
        _parameterSelectView = [[[NSBundle mainBundle]loadNibNamed:classNameFromClass(ParagramSelectView) owner:nil options:nil] firstObject];
           }
    return _parameterSelectView;
}



-(NSString*)compareSelectedDictPath{
    NSString*path =[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@compareSelectedDict",classNameFromClass([CompareListViewController class])];
    return path;
}

//记录删除对比的车型
-(void)editCompareSlectedDictWithCarId:(NSString *)car_id{
    
    [self.compareSelectedDict removeObjectForKey:car_id ];
    [self.compareSelectedDict.allKeys writeToFile:[self compareSelectedDictPath] atomically:YES];
    
}

-(NSMutableDictionary*)compareSelectedDict{
    
    if (!_compareSelectedDict) {
        _compareSelectedDict = [NSMutableDictionary dictionary];
        NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
        [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
            [_compareSelectedDict setObject:model forKey:obj];
        }];
        
    }
    return _compareSelectedDict;
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
