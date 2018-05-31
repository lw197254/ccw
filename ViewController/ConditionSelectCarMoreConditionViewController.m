//
//  ConditionSelectCarViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarMoreConditionViewController.h"
#import "ConditionSelectCarLevelCollectionViewCell.h"

#import "ConditionSelectCarNormalCollectionViewCell.h"
#import "ConditionSelectCarCollectionHeaderView.h"
#import "ConditionSelectCarViewModel.h"
#import "ConditionSelectCarLevelSubView.h"
#import "ConditionSelectCarCountModel.h"
#import "HTHorizontalSelectionList.h"
#import "BrandMutableSelectViewController.h"
#import "ConditionModel.h"

#import "ConditctionCollectionReusableView.h"

#import "ConditionCollectionViewCell.h"
#define  priceAndBrandCellHeight (312/2)

//#import "JHHeaderFlowLayout.h"
@interface ConditionSelectCarMoreConditionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,HTHorizontalSelectionListDataSource,HTHorizontalSelectionListDelegate>
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ConditionSelectCarViewModel *viewModel;
@property (copy, nonatomic) ConditionSelectCarMoreConditionBlock block;
///搜索结果按钮
@property (weak, nonatomic) IBOutlet UIButton *resultButton;
///搜索的结果背景view
@property (weak, nonatomic) IBOutlet UIView *resultView;
///搜索的菊花图
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *resultSearchActivityView;
///选中的条件字典
@property (strong, nonatomic) NSMutableDictionary *selectedDict;
@property (strong, nonatomic) NSMutableArray<ConditionModel*> *selectedArray;

//@property (assign, nonatomic)  NSInteger minPrice;
//@property (assign, nonatomic)  NSInteger maxPrice;
@property (strong, nonatomic)  RACDisposable* priceDispose;
//@property (copy, nonatomic)  NSString *priceString;

@property (strong, nonatomic)ConditionSelectCarCountModel*countModel;
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *conditionHorizontalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionContentViewHeightConstraint;
///级别子界面

//@property (strong, nonatomic) NSMutableDictionary *levelSelectedDict;
@property (strong, nonatomic)  ConditionSelectCarLevelSubView *levelView;
//
//@property (weak, nonatomic) IBOutlet UICollectionView *levelCollectionView;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


//@property (assign, nonatomic)  NSInteger footerMaxHeight;

@property (weak, nonatomic) IBOutlet UIView *customNavigationView;
@end

#define levelSection 0
#define peizhiSection 10

@implementation ConditionSelectCarMoreConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"更多条件"];
//    self.footerMaxHeight = 1;
   
    if (IOS_11_OR_LATER) {
        
    }else{
        [self.customNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(StatusHeight);
        }];
    }
    
    self.levelView = [[ConditionSelectCarLevelSubView alloc]init];
    [self.view addSubview: self.levelView];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.levelView.hidden = YES;
    
   
    
//    self.viewModel.configRequest.startRequest = YES;
    self.collectionView.allowsMultipleSelection = YES;
    self.conditionHorizontalView.backgroundColor = BlackColorF8F8F8;
    self.conditionHorizontalView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
    self.conditionHorizontalView.delegate = self;
    self.conditionHorizontalView.dataSource = self;
    self.conditionHorizontalView.leftSpace = 10;
    self.conditionHorizontalView.seperateSpace = 10;
    self.conditionHorizontalView.topSpace = (44-28)/2;
    self.conditionHorizontalView.bottomSpace = (44-28)/2;
    self.conditionHorizontalView.bottomTrimColor = [UIColor clearColor];
    UINib*nib =nibFromClass(ConditionSelectCarCollectionHeaderView);
    [self.collectionView registerNib: nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ConditionSelectCarCollectionHeaderView class])];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ConditionSelectCarNormalCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ConditionSelectCarNormalCollectionViewCell class])];
     [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ConditionSelectCarLevelCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ConditionSelectCarLevelCollectionViewCell class])];
    
    [self.collectionView registerClass:[ConditionCollectionViewCell class] forCellWithReuseIdentifier:classNameFromClass(ConditionCollectionViewCell)];
    

//    [self.collectionView registerNib:nibFromClass(ConditctionCollectionReusableView) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:classNameFromClass(ConditctionCollectionReusableView)];
    
    
    @weakify(self);
       [RACObserve(self.viewModel.countRequest, state)subscribeNext:^(id x) {
         @strongify(self);
        if (self.viewModel.countRequest.succeed) {
            self.countModel = [[ConditionSelectCarCountModel alloc]initWithDictionary:self.viewModel.countRequest.output[@"data"] error:nil];
            self.resultButton.userInteractionEnabled = YES;
           [self.resultSearchActivityView stopAnimating];
            if (self.countModel.chexiNum==0&&self.countModel.chexingNum==0) {
                 [self.resultButton setTitle:[NSString stringWithFormat:@"未找到符合条件的车系"] forState:UIControlStateNormal];
            }else{
                 [self.resultButton setTitle:[NSString stringWithFormat:@"共%ld个车系",self.countModel.chexiNum] forState:UIControlStateNormal];
            }
            
        }else if(self.viewModel.countRequest.failed){
               self.resultButton.userInteractionEnabled = YES;
            [self.resultSearchActivityView stopAnimating];
             [self.resultButton setTitle:[NSString stringWithFormat:@"未找到符合条件的车系"] forState:UIControlStateNormal];
        }
    }];
    [self countSearch];

//    [RACObserve(self, footerMaxHeight) subscribeNext:^(id x) {
//        if (self_weak_.footerMaxHeight == 1) {
//            return ;
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^(){
//
//                [UIView performWithoutAnimation:^{
//                    [self_weak_.collectionView reloadSections:[NSIndexSet indexSetWithIndex:peizhiSection]];
//                }];
//
//
//            });
//
//        }
//    }];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)resetWithPriceArray:(NSArray<NSString *> *)priceArray brandIdArray:(NSArray<NSString *> *)brandIdArray originalSelectedDict:(NSDictionary *)originalSelectedDict originalSelectedArray:(NSArray<ConditionModel*> *)originalSelectedArray confirmClickedBlock:(ConditionSelectCarMoreConditionBlock)block count:(NSInteger)count{
    if (self.block!=block) {
        self.block = block;
    }
    if (count > 0) {
         [self.resultButton setTitle:[NSString stringWithFormat:@"共%ld个车系",self.countModel.chexiNum] forState:UIControlStateNormal];
    }else{
        [self.resultButton setTitle:[NSString stringWithFormat:@"未找到符合条件的车系"] forState:UIControlStateNormal];
    }
    self.viewModel.countRequest.price = priceArray;
    self.viewModel.countRequest.pinpai = brandIdArray;
    [self.selectedDict removeAllObjects];
    [self.selectedDict setValuesForKeysWithDictionary:originalSelectedDict];
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObjectsFromArray:originalSelectedArray];
    self.viewModel.countRequest.startRequest = YES;
}
- (void)creatCountSearchSignal {
    [self.resultSearchActivityView startAnimating];
       self.resultButton.userInteractionEnabled = NO;
     [self.resultButton setTitle:[NSString stringWithFormat:@"正在筛选。。。"] forState:UIControlStateNormal];
    [self.priceDispose dispose];//上次信号还没处理，取消它(距离上次生成还不到1秒)
    @weakify(self);
    self.priceDispose = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendCompleted];
        return nil;
    }] delay:0.5] //延时一秒
                           subscribeCompleted:^{
                               @strongify(self);
                               [self countSearch];
                               self.priceDispose = nil;
                           }];  
}
///车系车型数量查询
-(void)countSearch{
   NSArray*array = [self.viewModel.countRequest getAllProperties];
    [array enumerateObjectsUsingBlock:^(NSString* properity, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([properity isEqualToString:@"price"]||[properity isEqualToString:@"pinpai"]) {
            
        }else if ([properity isEqualToString:@"level"]){
            NSDictionary*sectionDict=  self.selectedDict[properity];
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
            NSDictionary*sectionDict=  self.selectedDict[properity];
            
          
            [self.viewModel.countRequest setValue:sectionDict.allValues forKey:properity];
        }
       
        
    }];
   
    
    self.viewModel.countRequest.startRequest = YES;
//    [RACObserve( self.conditionLabel, text)subscribeNext:^(id x) {
//            self.viewModel.countRequest.price =
//    }];
}
//-(void)configResultSearch{
//    NSArray*array = [self.viewModel.resultRequest getAllProperties];
//    [array enumerateObjectsUsingBlock:^(NSString* properity, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//        
//        if ([properity isEqualToString:@"price"]) {
//            self.viewModel.resultRequest.price =[NSArray arrayWithObjects:[NSNumber numberWithInteger:self.minPrice],[NSNumber numberWithInteger:self.maxPrice], nil];
//        }else if ([properity isEqualToString:@"level"]){
//            NSDictionary*sectionDict=  self.selectedDict[properity];
//            NSMutableArray*valueArray = [NSMutableArray array];
//            [sectionDict.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    NSArray* values = [((NSDictionary*)obj) allValues];
//                    [valueArray addObjectsFromArray:values];
//                }else{
//                    [valueArray addObject:obj];
//                }
//            }];
//            [self.viewModel.resultRequest setValue:valueArray forKey:properity];
//            
//        }
//        else{
//            NSDictionary*sectionDict=  self.selectedDict[properity];
//            
//            
//            [self.viewModel.resultRequest setValue:sectionDict.allValues forKey:properity];
//        }
//        
//        
//    }];
//    NSMutableArray*brandArray = [NSMutableArray array];
//   
//    self.viewModel.resultRequest.pinpai = brandArray;
//    
//}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.selectedArray.count;
}
-(UIView*)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    ConditionModel*model = self.selectedArray[index];
    
    return [BrandMutableSelectViewController createBrandButtonWithTitle:model.value];
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    ConditionModel*model = self.selectedArray[index];
    [self selectedArrayAddObject:nil deleteModel:model];
    if (model.sectionKey) {
        NSMutableDictionary*dict =[NSMutableDictionary dictionaryWithDictionary: self.selectedDict[model.sectionKey]];
        if (model.rowKey) {
            NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithDictionary:dict[model.rowKey]];
            [dic removeObjectForKey:model.value];
            [dict setObject:dic forKey:model.rowKey];
        }else{
            [dict removeObjectForKey:model.value];
        }
        [self.selectedDict setObject:dict forKey:model.sectionKey];
    }
    [self.conditionHorizontalView reloadData];
    [self.collectionView reloadData];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.viewModel.data.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger number = 10;
   
        NSDictionary*dict = self.viewModel.data[section];
        NSArray*list = dict[@"list"];
        number = list.count;
   
   return number;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
      
        case levelSection:
        {
            return CGSizeMake(kwidth/3, 90);
        }
            break;
        case peizhiSection:
        {
            ConditionCollectionViewCell *cell = [[ConditionCollectionViewCell alloc] init];
            NSDictionary*dict = self.viewModel.data[peizhiSection];
            NSArray *array = dict[@"list"];
            NSArray *arraylist = array[indexPath.row][@"list"];
            [cell rebuildArray:arraylist title:array[indexPath.row][@"value"]];
            return  CGSizeMake(kwidth,cell.cellheight);
        }
            break;
            
        default:
            break;
    }
    NSDictionary*dict = self.viewModel.data[indexPath.section];
    if( [dict[@"title"] isEqualToString:@"结构"]||[dict[@"title"] isEqualToString:@"配置"]){
        return CGSizeMake((kwidth-4*cellInteritemSpace)/3, 34);
    }
    return CGSizeMake((kwidth-5*cellInteritemSpace)/4, 34);

}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    switch (section) {
       
        case levelSection:
        {
             return 0;
        }
            break;
        case peizhiSection:
        {
            return 0.0001;
        }
            break;
            
        default:
            break;
    }
//    NSDictionary*dict = self.viewModel.data[section-1];
//    if( [dict[@"title"] isEqualToString:@"结构"]||[dict[@"title"] isEqualToString:@"配置"]){
//        return cellLineSpace;
//    }
    return cellLineSpace;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    switch (section) {
      
        case levelSection:
        {
            return 0;
        }
            break;
        case peizhiSection:
        {
            return 0;
        }
            break;
            
        default:
            break;
    }
    //    NSDictionary*dict = self.viewModel.data[section-1];
    //    if( [dict[@"title"] isEqualToString:@"结构"]||[dict[@"title"] isEqualToString:@"配置"]){
    //        return cellLineSpace;
    //    }
    return cellInteritemSpace;

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    switch (section) {
       
        case levelSection:
        {
             return UIEdgeInsetsMake(cellLineSpace, 0, cellLineSpace, 0);
        }
            break;
            
        case peizhiSection:
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
        default:
        {
             return UIEdgeInsetsMake(cellLineSpace, cellInteritemSpace, cellLineSpace, cellInteritemSpace);
        }
            break;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kwidth, 24);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
//    if (section == 10) {
//        //设置区尾 高度
//        CGSize size = CGSizeMake(kwidth, self.footerMaxHeight);
//        NSLog(@"高度更新footerMaxHeight:%ld",self.footerMaxHeight);
//        return size;
//    }
    return CGSizeZero;
    
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        ConditionSelectCarCollectionHeaderView*headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ConditionSelectCarCollectionHeaderView class]) forIndexPath:indexPath];
        
         NSDictionary*dict = self.viewModel.data[indexPath.section];

        headerView.titleLabel.text = dict[@"title"];
        
        return headerView;
    }
    
//    if ([kind isEqual:UICollectionElementKindSectionFooter] && indexPath.section ==10 ) {
//        ConditctionCollectionReusableView*footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([ConditctionCollectionReusableView class]) forIndexPath:indexPath];
//
//        footerView.dict = self.viewModel.data[peizhiSection];
//
//        @weakify(self);
//        footerView.block = ^(NSInteger height) {
//            if (self_weak_.footerMaxHeight < height) {
//                self_weak_.footerMaxHeight = height;
//            }
//        };
//
//        [footerView updateView];
//
//        return footerView;
//    }
    return nil;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
               case levelSection:
        {
            ConditionSelectCarLevelCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ConditionSelectCarLevelCollectionViewCell class]) forIndexPath:indexPath];
            NSDictionary*dict = self.viewModel.data[indexPath.section];
            NSArray*list = dict[@"list"];
            //            "index": 1,
            //            "key": 1,
            //            "value": "微型车"
            NSDictionary*dic = list[indexPath.row];
            NSString*value =dic[@"value" ];
            cell.imageView.image = [UIImage imageNamed:value];
             cell.imageView.highlightedImage = [UIImage imageNamed:[value stringByAppendingString:@"选中"]];
            [cell.titleButton setTitle:value forState:UIControlStateNormal];
            if (self.selectedDict[dict[@"key"]][value]) {
                cell.selected = YES;
                 [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }else {
                NSArray*array = dic[@"list"];
                __block BOOL findObj = NO;
                if (array) {
                    [array enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString*key = obj[@"value"];
                        if (self.selectedDict[dict[@"key"]][dic[@"key"]][key]) {
                            findObj = YES;
                            *stop = YES;
                        }
                    }];
                }
                if (findObj) {
                    cell.selected = YES;
                    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }else{
                    cell.selected = NO;
                }
            }
           
            return cell;
        }
            break;
            case peizhiSection:
        {
            ConditionCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ConditionCollectionViewCell class]) forIndexPath:indexPath];
            NSDictionary*dict = self.viewModel.data[peizhiSection];
            NSArray *array = dict[@"list"];
            NSArray *arraylist = array[indexPath.row][@"list"];
            
            cell.selectedArray = [self.selectedArray copy];
            
            [cell rebuildArray:arraylist title:array[indexPath.row][@"value"] tag:indexPath.row];
            
            cell.block = ^(NSString *title, bool isSelected,NSInteger tag) {
                NSDictionary*dict = self.viewModel.data[peizhiSection];
                NSArray *array = dict[@"list"];
                NSArray *arraylist = array[indexPath.row][@"list"];
                NSDictionary*rowDic;
                
                for (int i=0; i<arraylist.count; i++) {
                    rowDic = arraylist[i];
                    if ([rowDic[@"value"] isEqualToString:title]) {
                        break;
                    }else{
                        continue;
                    }
                }
                
                NSDictionary*dic =  self.selectedDict[dict[@"key"]];
                NSMutableDictionary*selectDict = [[NSMutableDictionary alloc]initWithDictionary:dic];
               
        
                if (isSelected) {
                    [selectDict setObject:rowDic[@"index"] forKey:rowDic[@"value"]];
                    [self.selectedDict setObject:selectDict forKey:dict[@"key"]];
                    ConditionModel*model = [[ConditionModel alloc]initWithDictionary:rowDic error:nil];
                    model.rowKey = nil;
                    model.sectionKey = rowDic[@"key"];
                    if (model) {
                        [self selectedArrayAddObject:model deleteModel:nil];
                    }
                }else{
                     [selectDict removeObjectForKey:rowDic[@"value"]];
                     [self.selectedDict setObject:selectDict forKey:dict[@"key"]];
                     [self.selectedArray removeObject:rowDic[@"value"]];
                    ConditionModel*model = [[ConditionModel alloc]initWithDictionary:rowDic error:nil];
                    model.rowKey = nil;
                    model.sectionKey = rowDic[@"key"];
                    if (model) {
                        [self selectedArrayAddObject:nil deleteModel:model];
                    }
                }
            };
            
            return cell;
        }
            break;
            
        default:{
            ConditionSelectCarNormalCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ConditionSelectCarNormalCollectionViewCell class]) forIndexPath:indexPath];
            NSDictionary*dict = self.viewModel.data[indexPath.section];
            NSArray*list = dict[@"list"];
//            "index": 1,
//            "key": 1,
//            "value": "微型车"
            NSDictionary*dic = list[indexPath.row];
            
           [ cell.titleButton setTitle:dic[@"value" ] forState:UIControlStateNormal];
            if (self.selectedDict[dict[@"key"]][dic[@"value" ]]) {
                cell.selected = YES;
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }else{
                cell.selected = NO;
            }

            return cell;
        }
            break;
    }

    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击deseciton:%ld",indexPath.section);
    if (indexPath.section == peizhiSection) {
        return ;
    }
    
        NSDictionary*sectionDict = self.viewModel.data[indexPath.section];
        NSArray*list = sectionDict[@"list"];
        //            "index": 1,
        //            "key": 1,
        //            "value": "微型车"
        NSDictionary*rowDic = list[indexPath.row];
        
   
    if ([rowDic[@"list"] isKindOfClass:[NSArray class]]) {
        [self showLevelSubViewWithSectionDict:sectionDict rowDict:rowDic indexPath:indexPath];
        }else{
            NSDictionary*dic =  self.selectedDict[sectionDict[@"key"]];
            NSMutableDictionary*selectDict = [[NSMutableDictionary alloc]initWithDictionary:dic];
            [selectDict setObject:rowDic[@"index"] forKey:rowDic[@"value"]];
            [self.selectedDict setObject:selectDict forKey:sectionDict[@"key"]];
           
            ConditionModel*model = [[ConditionModel alloc]initWithDictionary:rowDic error:nil];
            model.rowKey = nil;
            model.sectionKey = sectionDict[@"key"];
            if (model) {
                [self selectedArrayAddObject:model deleteModel:nil];
            }
        }
   
}
-(void)showLevelSubViewWithSectionDict:(NSDictionary*)sectionDict rowDict:(NSDictionary*)rowDic indexPath:(NSIndexPath*)indexPath{
    
    NSArray*list = rowDic[@"list"];
    NSDictionary*sectionSelectDict= self.selectedDict [sectionDict[@"key"]];
    NSDictionary*rowSelectDict = sectionSelectDict[rowDic[@"key"]];
    @weakify(self);
   
    [self.levelView showWithArray:list SelectFinishBlock:^(NSDictionary *selectedDict, NSString *sectionKey,NSString*rowKey,NSArray*deSelectedArray) {
        @strongify(self);
        if (selectedDict==nil||selectedDict.count==0) {
            NSMutableDictionary*sectionDict =[[NSMutableDictionary alloc]initWithDictionary: self.selectedDict[sectionKey]];
            [sectionDict removeObjectForKey:rowKey];
           
            [self.selectedDict setObject:sectionDict forKey:sectionKey];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            
        }else{
           
            NSMutableDictionary*sectionDict =[[NSMutableDictionary alloc]initWithDictionary: self.selectedDict[sectionKey]];
            [sectionDict setObject:selectedDict forKey:rowKey];
            
            [self.selectedDict setObject:sectionDict forKey:sectionKey];

            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        [deSelectedArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ConditionModel*model = [[ConditionModel alloc]init];
            
            model.value =obj.allKeys.firstObject;
            model.index = obj[model.value];
            model.rowKey = rowKey;
            model.sectionKey = sectionKey;
            if (model) {
                [self selectedArrayAddObject:nil deleteModel:model];
            }

        }];
        [self.selectedArray removeObjectsInArray:deSelectedArray];
        [selectedDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ConditionModel*model = [[ConditionModel alloc]init];
            model.index = selectedDict[obj];
            model.value =obj;
            model.rowKey = rowKey;
            model.sectionKey = sectionKey;
            if (model) {
                [self selectedArrayAddObject:model deleteModel:nil];
            }

            
        }];
        
        
     
       
        [self creatCountSearchSignal];
        
    } selectedDict:rowSelectDict sectionKey:sectionDict[@"key"] rowKey:rowDic[@"key"] ];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == peizhiSection) {
        return;
    }
    
    NSDictionary*sectionDict = self.viewModel.data[indexPath.section];
    NSArray*list = sectionDict[@"list"];
    //            "index": 1,
    //            "key": 1,
    //            "value": "微型车"
    NSDictionary*rowDic = list[indexPath.row];
    
//    NSMutableDictionary*currentSelectDict = [NSMutableDictionary dictionary];
    if ([rowDic[@"list"] isKindOfClass:[NSArray class]]) {
        [self showLevelSubViewWithSectionDict:sectionDict rowDict:rowDic indexPath:indexPath];
    }else{
        NSDictionary*dic =  self.selectedDict[sectionDict[@"key"]];
        NSMutableDictionary*selectDict = [[NSMutableDictionary alloc]initWithDictionary:dic];
         [selectDict removeObjectForKey:rowDic[@"value"]];
        [self.selectedDict setObject:selectDict forKey:sectionDict[@"key"]];
       
        [self.selectedArray removeObject:rowDic[@"value"]];
        
        ConditionModel*model = [[ConditionModel alloc]initWithDictionary:rowDic error:nil];
        model.rowKey = nil;
        model.sectionKey = sectionDict[@"key"];
        if (model) {
            [self selectedArrayAddObject:nil deleteModel:model];
        }

        
        [self creatCountSearchSignal];
    }
   
    [self.conditionHorizontalView reloadData];
    
}

- (IBAction)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//结果
- (IBAction)resultClicked:(UIButton *)sender {
    if(self.countModel.chexingNum > 0||self.countModel.chexiNum > 0){
    
//        ConditionSelectCarResultViewController*result = [[ConditionSelectCarResultViewController alloc]init];
//        [self configResultSearch];
//        result.viewModel = self.viewModel;
//        result.viewModel.model = nil;
//        [result.viewModel.showList removeAllObjects];
        
    }
    if (self.block) {
        NSInteger number = 0;
        if (self.countModel) {
            number = self.countModel.chexiNum;
        }
        self.block(self.selectedDict, self.selectedArray,self.countModel.chexiNum);
    }
    [self backButtonClicked:nil];
}
-(void)selectedArrayAddObject:(ConditionModel*)model deleteModel:(ConditionModel*)deleteModel{
    if (model) {
        __block BOOL findObj = NO;
        [self.selectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.sectionKey isEqual:model.sectionKey]&&(!model.rowKey||[obj.rowKey isEqual:model.rowKey])&&[obj.index isEqual:model.index]) {
                findObj =YES;
                *stop = YES;
            }
            ///index国货2 非国货14 日本0 非日本12 德国1 非德系13 美系3 非美15 韩系4 非韩系16
            
            if ([model.sectionKey isEqualToString:@"nation"]) {
                if (([model.index intValue] == 2 && [obj.index isEqual:@"14"])||
                    ([model.index intValue] == 14 && [obj.index isEqual:@"2"])||
                    ([model.index intValue] == 0 && [obj.index isEqual:@"12"])||([model.index intValue] == 12 && [obj.index isEqual:@"0"])||
                    ([model.index intValue] == 1 && [obj.index isEqual:@"13"])||
                    ([model.index intValue] == 13 && [obj.index isEqual:@"1"])||
                    ([model.index intValue] == 3 && [obj.index isEqual:@"15"])||
                    ([model.index intValue] == 15 && [obj.index isEqual:@"3"])||
                    ([model.index intValue] == 4 && [obj.index isEqual:@"16"])||
                    ([model.index intValue] == 16 && [obj.index isEqual:@"4"])) {
                    
                    
                    NSDictionary*dic =  self.selectedDict[@"nation"];
                    NSMutableDictionary*selectDict = [[NSMutableDictionary alloc]initWithDictionary:dic];
                    [selectDict removeObjectForKey:obj.value];
                    [self.selectedDict setObject:selectDict forKey:@"nation"];
                    [self.selectedArray removeObject:obj];
                    
                    [UIView performWithoutAnimation:^{
                        [self.collectionView reloadSections:[[NSIndexSet alloc]initWithIndex:1]];
                    }];
                    *stop = YES;
                    
                }
            }
            
        }];
        if (!findObj) {
            [self.selectedArray insertObject:model atIndex:0 ];
        }
        
    }
    if (deleteModel) {
        [self.selectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.sectionKey isEqual:deleteModel.sectionKey]&&(!deleteModel.rowKey||[obj.rowKey isEqual:deleteModel.rowKey])&&[obj.index isEqual:deleteModel.index]) {
                [self.selectedArray removeObject:obj];
                *stop = YES;
            }
        }];
        
    }
    [self.conditionHorizontalView reloadData];
    [self creatCountSearchSignal];
    if (self.selectedArray.count==0) {
        self.conditionContentViewHeightConstraint.constant = 0;
    }else{
        self.conditionContentViewHeightConstraint.constant = 45;
    }
    
}

-(NSMutableArray<ConditionModel*>*)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray<ConditionModel*> array];
    }
    return _selectedArray;
}

-(NSMutableDictionary*)selectedDict{
    if (!_selectedDict) {
        _selectedDict = [NSMutableDictionary dictionary];
    }
    return _selectedDict;
}

-(ConditionSelectCarViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel =[ConditionSelectCarViewModel SceneModel];
    }
    return _viewModel;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.selectedArray.count==0) {
        self.conditionContentViewHeightConstraint.constant = 0;
    }else{
        self.conditionContentViewHeightConstraint.constant = 45;
    }
    [self.conditionHorizontalView reloadData];
    [self.collectionView reloadData];
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
