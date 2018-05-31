//
//  CarTypeDetailViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarTypeDetailViewController.h"
#import "CarTypeDetailViewModel.h"
#import "CarTypeHeaderCollectionViewCell.h"
#import "CarTypeCollectionViewCell.h"
#import "CarTypeDetailRecommendCollectionReusableView.h"
#import "CarTypeWithoutDelearCell.h"
#import "DialogView.h"

#import "CarCollectionViewCell.h"
#import "MoreStoreAndMapCollectionViewCell.h"
#import "CarTypeDetailHeaderHTHorizontalButtonView.h"
#import "AskForPriceNewViewController.h"
#import "AskForPriceViewController.h"
#import "InformationViewController.h"
#import "ParameterConfigSingleViewController.h"
#import "CityViewController.h"
#import "InformationTypeTableViewCell.h"
#import "CarDeptViewController.h"
#import "KouBeiCarTypeModel.h"
#import "BrowseKouBeiCarTypeModel.h"
#import "BMKGeometry.h"
#import "MyUMShare.h"
#import "CarTypeStoreTitleCollectionReusableView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CustomPinAnnotationView.h"
#import "CustomAnimation.h"
#import "PhotoViewController.h"
#import "PublicPraiseViewController.h"
#import "PhoneCallWebView.h"
#import "MapViewController.h"
#import "CompareListViewController.h"
#import "CompareDict.h"


#import "DealerCarInfoViewController.h"
#import "FindCarByGroupByCarTypeGetCarModel.h"
#import "Location.h"
#import "SubjectAndSaveObject.h"
#import "BuyCarCalculatorViewController.h"
#import "BuyCarCalculatorDataModel.h"

#import "LoginViewController.h"
#import "ShadowLoginViewController.h"
//#import "UICollectionView+gestureHandle.h"

#import "MyOwnShareView.h"
#import "ListSelectView.h"
#define footerButtonTag 10000
#define cellButtonTag 10001

#define defaltMaxDealerCount 3

#define  Picture @"图片"
#define config @"配置"
#define comment @"口碑"
#define nocomment @"口碑_d"
#define information @"资讯"

#define sortTypeTotal @"综合排序"
#define sortTypeNearestWay @"离我最近"
#define StoreTypeNormalWay @"4S店"
#define StoreTypeUnixWay @"综合店"
#define headerCellHeight 310
@interface CarTypeDetailViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource,BMKMapViewDelegate,UIGestureRecognizerDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *storeTypeTableView;
@property (weak, nonatomic) IBOutlet ListSelectView *storeTypeBackgroundView;

//@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) CarTypeDetailViewModel *viewModel;
@property (strong, nonatomic) NSArray *hozirontalListArray;
@property (weak, nonatomic) IBOutlet UIButton *askForPriceButton;
@property (assign, nonatomic) NSInteger maxDealerCount;
@property (assign, nonatomic) NSInteger dealerCount;


@property (assign, nonatomic)BOOL mapIsLoad;
@property (assign, nonatomic)BOOL needReloadAnomations;

///@[@"授权店",@"综合店"]
@property (strong, nonatomic)NSArray* storeListArray;
@property (strong, nonatomic)NSArray* sortTypeListArray;
@property (strong, nonatomic)NSArray* showTypeListArray;
@property (copy, nonatomic)NSString* selectedStoreName;
@property (copy, nonatomic)NSString* currentStoreName;
@property (copy, nonatomic)NSString* currentSortName;
@property (strong, nonatomic) CarTypeStoreTitleCollectionReusableView*storeTitleView;

@property (strong, nonatomic)MoreStoreAndMapCollectionViewCell*moreStoreAndMapCell;
@property (strong, nonatomic)NSMutableArray*animationArray;
@property (strong, nonatomic)UITapGestureRecognizer* mapViewTapGesture;

@property (assign, nonatomic)NSInteger headerSection;// 0
@property (assign, nonatomic)NSInteger storeSection;// 1
@property (assign, nonatomic)NSInteger moreStoreAndMapSection;// 2
@property (assign, nonatomic)NSInteger supportCarSeriesSection; //3

@property(nonatomic,strong)SubjectAndSaveObject *subjectObject;

//弹出控件
@property(nonatomic,strong) MyOwnShareView *shareView;


@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UILabel *PKCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UIButton *PKButton;
@property(copy,nonatomic)NSString *cityId;
@property (weak, nonatomic) IBOutlet UIButton *customBackButton;
@property (weak, nonatomic) IBOutlet UIView *customNavigationView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property(nonatomic,copy)ListSelectViewAnimationComplationBlock block;

@property(nonatomic,assign)bool isCanAskPrice;
@end

@implementation CarTypeDetailViewController

-(MyOwnShareView *)shareView{
    if(!_shareView){
        _shareView = [[MyOwnShareView alloc] init];
    }
    return _shareView;
}

-(SubjectAndSaveObject *)subjectObject{
    if (!_subjectObject) {
        _subjectObject = [[SubjectAndSaveObject alloc] init];
    }
    return _subjectObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCanAskPrice = YES;
//    [self.customNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(44+StatusHeight);
//    }];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
//    _mapView.delegate = self;
    self.viewModel = [CarTypeDetailViewModel SceneModel];
    self.maxDealerCount = defaltMaxDealerCount;
    self.askForPriceButton.tag = footerButtonTag;
    
//     [self showRightButton];
   self.bottomLine.backgroundColor = BlackColorE3E3E3;
   
//    self.storeTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
       @weakify(self);
   
    
    [[RACObserve([AreaNewModel shareInstanceSelectedInstance],id)filter:^BOOL(id value) {
        return [AreaNewModel shareInstanceSelectedInstance].id.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        if (![self.cityId isEqual:[AreaNewModel shareInstanceSelectedInstance].id]) {
           
            
            self.cityId =  [AreaNewModel shareInstanceSelectedInstance].id;
            
            self.viewModel.request.chexingId = self.chexingId;
            self.viewModel.request.lat =[NSNumber numberWithDouble:[Location shareInstance].coordinate.latitude] ;
            self.viewModel.request.lon = [NSNumber numberWithDouble:[Location shareInstance].coordinate.longitude];
            self.viewModel.request.cityId= self.cityId;
            self.viewModel.request.startRequest = YES;
        }
        
    }];
    
    
    [[RACObserve([AreaNewModel shareInstanceSelectedInstance],name)filter:^BOOL(id value) {
        return [AreaNewModel shareInstanceSelectedInstance].name.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.cityButton setTitle:[AreaNewModel shareInstanceSelectedInstance].name forState:UIControlStateNormal];
       
    }];
    

        
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView dismissWithOutDataView];
        self.favouriteButton.userInteractionEnabled = YES;
        self.askForPriceButton.userInteractionEnabled = YES;
        self.shareButton.userInteractionEnabled = YES;

        NSArray *records = [BrowseKouBeiCarTypeModel findByColumn:@"id" value:self.chexingId];
        if ( ![records count] ) {
            [self saveBrowesModel];
        }else{
            [self deleteBrowesModel:records[0]];
            [self saveBrowesModel];
        }
               
//        [self showRightButton];
        
       
        self.selectedStoreName = self.currentStoreName;
        [self.collectionView reloadData];
        [self.collectionView setContentOffset: CGPointMake(0, 0)];
        
    }];
    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
        
        @strongify(self);
        return self.viewModel.request.failed;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        [self.collectionView showNetLost];
        self.favouriteButton.userInteractionEnabled = NO;
        self.askForPriceButton.userInteractionEnabled = NO;
        self.shareButton.userInteractionEnabled = NO;
        
    }];
    [[RACSignal combineLatest:@[RACObserve(self, needReloadAnomations),RACObserve(self, mapIsLoad)]reduce:^(NSNumber*needReloadAnomations,NSNumber*mapIsLoad){
        return @([needReloadAnomations boolValue]&&[mapIsLoad boolValue]);
        
    }]subscribeNext:^(NSNumber* x) {
         @strongify(self);
        if ([x boolValue]) {
            [self addMap];
        }
        
    }];
    [self.collectionView registerNib:nibFromClass(CarTypeStoreTitleCollectionReusableView) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classNameFromClass(CarTypeStoreTitleCollectionReusableView)];
     [self.collectionView registerNib:nibFromClass(CarTypeDetailRecommendCollectionReusableView) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classNameFromClass(CarTypeDetailRecommendCollectionReusableView)];
   [self.collectionView registerNib:nibFromClass(CarTypeWithoutDelearCell) forCellWithReuseIdentifier:classNameFromClass(CarTypeWithoutDelearCell)];
     [self.collectionView registerNib:nibFromClass(CarTypeHeaderCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(CarTypeHeaderCollectionViewCell)];
    [self.collectionView registerNib:nibFromClass(CarCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(CarCollectionViewCell)];
     [self.collectionView registerNib:nibFromClass(MoreStoreAndMapCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(MoreStoreAndMapCollectionViewCell)];
    [self.collectionView registerNib:nibFromClass(CarTypeCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(CarTypeCollectionViewCell)];

    [self updateView];
    
    
    if (IOS_11_OR_LATER) {
        [self.customNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
        }];;
    }else{
        
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (!self.viewModel.model) {
        return 0;
    }
    if (self.dealerCount==0) {
        return 3;
    }else{
        return 4;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section==self.headerSection) {
        return 1;
    }else if (section==self.storeSection){
        if (self.dealerCount==0) {
            return 0;
        }else{
            return self.dealerCount;
        }

        
    }else if(section==self.supportCarSeriesSection){
        return self.viewModel.model.see_others.count;
    }else if(section==self.moreStoreAndMapSection){
        return 1;
    }else{
        return 0;
    }
   }

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==self.headerSection) {
        return CGSizeMake(kwidth, headerCellHeight);
    }else if(indexPath.section==self.storeSection){
        if (self.dealerCount == 0) {
            return CGSizeMake(kwidth, kheight - 64-48 - (330+20)/2);
        }else{
            return CGSizeMake(kwidth, (180+80+10)/2);
        }
        
    }else if(indexPath.section==self.supportCarSeriesSection){
        
        return CGSizeMake((kwidth-15*2-10*2)/3, 390/2);
       
    }else{
        NSInteger count = self.viewModel.model.dealers.showList.count;
        if (count <= 0) {
            return CGSizeMake(kwidth, 88/2);
            
        }else if(count <= defaltMaxDealerCount){
            //这边加了20的高度，实际只有10的高度，为了添加地图下的线条
            return CGSizeMake(kwidth, (20+360+20)/2);
            
        }else{
            //这边加了20的高度，实际只有10的高度，为了添加地图下的线条
            return CGSizeMake(kwidth, (88+20+360+20)/2);
        }

        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section==self.storeSection){
        if (self.dealerCount==0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(kwidth, (88+20)/2);
        }
        
    }else if (section == self.supportCarSeriesSection){
        return CGSizeMake(kwidth, (80)/2);
    }else{
        return CGSizeZero;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == self.supportCarSeriesSection) {
         return UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        return UIEdgeInsetsZero;
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == self.supportCarSeriesSection) {
        return 5;
    }else{
        return 0;
    }
    
}
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == supportCarSeriesSection) {
//        return 5;
//    }else{
//        return 0;
//    }
//}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.headerSection==indexPath.section){
        
            CarTypeHeaderCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(CarTypeHeaderCollectionViewCell) forIndexPath:indexPath];
            cell.carNameLabel.text = self.viewModel.model.car_name;
            if(self.viewModel.model.factory_price.isNotEmpty && ![self.viewModel.model.factory_price isEqualToString:@"0.00"]){
                 cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@万", self.viewModel.model.factory_price];
                self.askForPriceButton.userInteractionEnabled =YES;
                
                [self.askForPriceButton setBackgroundImage:[UIImage imageNamed:@"buttonBlueNormal"] forState:UIControlStateNormal];
            }else{
                self.isCanAskPrice = NO;
//                self.askForPriceButton.enabled = NO;
                self.askForPriceButton.userInteractionEnabled =NO;
               
                [self.askForPriceButton setBackgroundImage:[UIImage imageWithColor:BlueColorD1E1FF size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
                
//            [self.askForPriceButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
 
                cell.priceLabel.text = @"暂无报价";
            }
           
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.picture.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
            [cell.headerImageViewTapGesture addTarget:self action:@selector(headerImageViewTouchDown:)];
            cell.horizontalListView.delegate = self;
            cell.horizontalListView.dataSource = self;
            cell.horizontalListView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
            cell.horizontalListView.maxShowCount = 4;
            cell.horizontalListView.minShowCount = 4;
            [cell.horizontalListView reloadData];
        [cell.daiKuanButton addTarget:self action:@selector(daiKuanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.quanKuanButton addTarget:self action:@selector(quanKuanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
         [cell.pkButton addTarget:self action:@selector(addPkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.askForPriceButton.tag = cellButtonTag;
        [cell.askForPriceButton addTarget:self action:@selector(askForPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
        CompareDict*dict = [CompareDict shareInstance] ;
        if ([dict objectForKey:self.chexingId]) {
            cell.pkButton.enabled = NO;
        }else{
            cell.pkButton.enabled = YES;
        }
        
        BuyCarCalculatorViewController*vc  = [[ BuyCarCalculatorViewController alloc]init];
       
    
        vc.cheXingString = self.viewModel.model.car_name;
        if (self.viewModel.model.factory_price.isNotEmpty) {
            vc.price = [self.viewModel.model.factory_price floatValue]*10000;
        }else{
            vc.price =0;
        }
        vc.buyType = BuyTypeDaiKuan;
        vc.dataModel =  [[BuyCarCalculatorDataModel alloc]init];
        
        [vc updateDataModel];
        vc.dataModel.isDaiKuan = YES;
        NSString*yueGong = [Tool changeNumberFormat:vc.dataModel.yueGong];
        cell.daiKuanPriceLabel.text = [NSString stringWithFormat:@"%@元/月",yueGong];
        vc.dataModel.isDaiKuan = NO;
        [vc.dataModel selectAllBaoxian];
        
       
        if (!self.isCanAskPrice) {
            [cell.askForPriceButton setEnabled:NO];
        }
        cell.quanKuanPriceLabel.text = [NSString stringWithFormat:@"%.2f万",vc.dataModel.zongJia*1.0/10000];
    
        return cell;
            
    }else if(self.storeSection==indexPath.section){

            if (self.dealerCount == 0) {
                CarTypeWithoutDelearCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(CarTypeWithoutDelearCell) forIndexPath:indexPath];
                cell.titleLabel.text = @"暂无经销商";
                cell.imageView.image = [UIImage imageNamed:@"暂无经销商"];
                return cell;
            }
            
            CarTypeCollectionViewCell*cell =  [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(CarTypeCollectionViewCell) forIndexPath:indexPath];
          
         CarTypeDetailDealerModel*model =   self.viewModel.model.dealers.showList[indexPath.row];
            cell.storeNameLabel.text = model.dealer_name;
            cell.addressLabel.text = model.address;
            if(model.price.isNotEmpty){
                cell.priceLabel.text = [model.price stringByAppendingString:@"万"];
            }else{
                cell.priceLabel.text = @"暂无报价";
            }
            
            cell.askForPrice.tag = indexPath.row;
            cell.callButton.tag = indexPath.row;
            [cell.callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.askForPrice addTarget:self action:@selector(askForPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
    }else if(self.moreStoreAndMapSection == indexPath.section){
    
            
            self.moreStoreAndMapCell.mapView.delegate = nil;
            
                 self.moreStoreAndMapCell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(MoreStoreAndMapCollectionViewCell) forIndexPath:indexPath];
            self.moreStoreAndMapCell.mapView.delegate = self;
                 [self.moreStoreAndMapCell.storeNumberButton addTarget:self action:@selector(moreStoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
                
//            }
            NSInteger count = self.viewModel.model.dealers.showList.count;
            if (count <= 0) {
                [self.moreStoreAndMapCell hideMapViewAndShowStoreNumberButton];
                [self.moreStoreAndMapCell.storeNumberButton setTitle:@"当前城市暂无经销商" forState:UIControlStateNormal];
                [self.moreStoreAndMapCell.storeNumberButton setImage:nil forState:UIControlStateNormal];
                [self.moreStoreAndMapCell.storeNumberButton setImage:nil forState:UIControlStateSelected];
            }else if(count <= defaltMaxDealerCount){
               [self.moreStoreAndMapCell hideStoreNumberButtonAndShowMapView];
                
                self.needReloadAnomations = YES;

            }else{
                [self.moreStoreAndMapCell showMapViewAndShowStoreNumberButton];

                [self.moreStoreAndMapCell.storeNumberButton setTitle:[NSString stringWithFormat:@"共%ld家经销商",count] forState:UIControlStateNormal];
                [self.moreStoreAndMapCell.storeNumberButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
                [self.moreStoreAndMapCell.storeNumberButton setImage:[UIImage imageNamed:@"箭头向上"] forState:UIControlStateSelected];
                
                [self.moreStoreAndMapCell.storeNumberButton exchangeImageAndTitle];
                self.moreStoreAndMapCell.mapView.delegate = self;
                self.needReloadAnomations = YES;
            }
            
           self.moreStoreAndMapCell.mapView.scrollEnabled = NO;
            
//            if (!self.mapViewTapGesture) {
//                self.mapViewTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapViewTouchDown:)];
//            }
//            [self.moreStoreAndMapCell.mapView addGestureRecognizer:self.mapViewTapGesture];
            return self.moreStoreAndMapCell;
        }else if ( self.supportCarSeriesSection== indexPath.section){
            CarCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(CarCollectionViewCell) forIndexPath:indexPath];
            CarTypeDetailSeeOtherModel*model = self.viewModel.model.see_others[indexPath.row];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
            cell.carName.text = model.name;
            
            if ([model.kb_average isNotEmpty]&&!([model.kb_average floatValue] ==0.00)){
                NSString *kb = [NSString stringWithFormat:@"口碑:%@",model.kb_average];
                cell.source.text = kb;
            }else{
                cell.source.text = @"口碑:暂无数据";
            }
          
            if(model.zhidaoPrice.isNotEmpty){
                cell.price.text = model.zhidaoPrice;
            }else{
                cell.price.text = @"暂无报价";
            }

            
            return cell;
        }else{
            return nil;
        }
    
}

-(void)searchPriceClickedNothing:(UIButton *)button{
    NSLog(@"点击无效");
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==self.supportCarSeriesSection ) {
          CarTypeDetailSeeOtherModel*model = self.viewModel.model.see_others[indexPath.row];;
        CarDeptViewController*vc = [[CarDeptViewController alloc]init];
        vc.chexiid =model.id;
        vc.picture =model.pic_url;
        
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == self.storeSection) {
        
        DealerCarInfoViewController *vc = [[DealerCarInfoViewController alloc] init];
        if ([self.viewModel.model.dealers.showList isNotEmpty]) {
            CarTypeDetailDealerModel *model= self.viewModel.model.dealers.showList[indexPath.row];
            vc.dealerId = model.dealer_id;
            
            vc.typeId =self.viewModel.model.car_brand_type_id;
            vc.carId = self.chexingId;

            [self.rt_navigationController pushViewController:vc animated:YES];
        }
       
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == self.storeSection) {
            if (!self.storeTitleView) {
                self.storeTitleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classNameFromClass(CarTypeStoreTitleCollectionReusableView) forIndexPath:indexPath];
                [self.storeTitleView.storeButton addTarget:self action:@selector(storeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.storeTitleView.sortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            return self.storeTitleView;
        }else{
         CarTypeDetailRecommendCollectionReusableView*view=   [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classNameFromClass(CarTypeDetailRecommendCollectionReusableView) forIndexPath:indexPath];
            return view;
        }
       
    }
    return nil;
}
-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.hozirontalListArray.count;
}
-(UIView*)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    CarTypeDetailHeaderHTHorizontalButtonView*view = [[[NSBundle mainBundle]loadNibNamed:classNameFromClass(CarTypeDetailHeaderHTHorizontalButtonView) owner:nil options:nil]firstObject];
    NSDictionary*dict = self.hozirontalListArray[index];
    view.titleLabel.text = dict[@"title"];
    switch (index) {
        case 0:{
            ///
            NSString*image = dict[@"imageName"];
            if (self.viewModel.model.hasPic) {
                view.imageView.image = [UIImage imageNamed:image  ];
                 view.titleLabel.textColor  = BlackColor333333;
            }else{
                 view.imageView.image = [UIImage imageNamed:[image stringByAppendingString:@"_d"] ];
                 view.titleLabel.textColor  = BlackColor999999;
            }
            
        }
            
            break;
        case 1:{
            NSString*image = dict[@"imageName"];
            if (self.viewModel.model.hasParam) {
                view.imageView.image = [UIImage imageNamed:image  ];
                view.titleLabel.textColor  = BlackColor333333;
            }else{
                view.imageView.image = [UIImage imageNamed:[image stringByAppendingString:@"_d"] ];
                view.titleLabel.textColor  = BlackColor999999;
            }

        }
            
            break;
        case 2:{
            NSString*image = dict[@"imageName"];
            if (self.viewModel.model.hasKoubei) {
                view.imageView.image = [UIImage imageNamed:image  ];
                view.titleLabel.textColor  = BlackColor333333;
            }else{
                view.imageView.image = [UIImage imageNamed:[image stringByAppendingString:@"_d"] ];
                view.titleLabel.textColor  = BlackColor999999;
            }

        }
            
            break;
        case 3:{
            NSString*image = dict[@"imageName"];
            if (self.viewModel.model.hasArt) {
                view.imageView.image = [UIImage imageNamed:image  ];
                view.titleLabel.textColor  = BlackColor333333;
            }else{
                view.imageView.image = [UIImage imageNamed:[image stringByAppendingString:@"_d"] ];
                view.titleLabel.textColor  = BlackColor999999;
            }

        }
            
            break;
            
        default:
            break;
    }
    
   
    
    
   
    
    return view;
}

//头部四大入口
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    NSDictionary*dict = self.hozirontalListArray[index];
   
    NSString*title = dict[@"title"];
    if ([title isEqualToString:Picture]) {
        if (!self.viewModel.model.hasPic) {
            return;
        }
        PhotoViewController *controller = [[PhotoViewController alloc] init];
        controller.carId = self.viewModel.model.car_id;
        controller.typeId = nil;
        controller.carName = self.viewModel.model.car_name;
        controller.carType = self.viewModel.model.car_brand_type_name;
        controller.carPrice =[NSString stringWithFormat:@"%@万",self.viewModel.model.factory_price];
        
        [self.rt_navigationController pushViewController:controller animated:YES];
        
    }else if ([title isEqualToString:config]){
        if (!self.viewModel.model.hasParam) {
            return;
        }
        ParameterConfigSingleViewController*vc = [[ParameterConfigSingleViewController alloc]init];
        vc.carId = self.chexingId;
        vc.typeId = self.viewModel.model.car_brand_type_id;
         vc.carTypeName = [NSString stringWithFormat:@"%@ %@",self.viewModel.model.car_brand_type_name, self.viewModel.model.car_name];
       
        [self.rt_navigationController pushViewController:vc animated:YES];
        
    }else if ([title isEqualToString:comment]){
        if (!self.viewModel.model.hasKoubei) {
            return;
        }
      
        PublicPraiseViewController *controller = [[PublicPraiseViewController alloc] init];
        controller.chexingId = self.viewModel.model.car_id;
        controller.catTypeId = @"";
        controller.carSeriesName = self.viewModel.model.car_brand_type_name;
        controller.carTypeName = self.viewModel.model.car_name;
        [URLNavigation pushViewController:controller animated:YES];
    }else{
        if (!self.viewModel.model.hasArt) {
            return;
        }
//        资讯
        InformationViewController*infor = [[InformationViewController alloc]init];

        infor.carTypeId = self.viewModel.model.car_id;

        [self.rt_navigationController pushViewController: infor animated:YES];
    }

   
}
///图片点击
-(void)headerImageViewTouchDown:(UITapGestureRecognizer*)tap{
    PhotoViewController *controller = [[PhotoViewController alloc] init];
    controller.carId = self.viewModel.model.car_id;
    controller.typeId = nil;
    controller.carName = self.viewModel.model.car_name;
    controller.carType = self.viewModel.model.car_brand_type_name;
    [self.rt_navigationController pushViewController:controller animated:YES];
}
///拨打电话
-(void)callButtonClicked:(UIButton*)button{
//    [[GCDQueue mainQueue]queueBlock:^{
        CarTypeDetailDealerModel*model =   self.viewModel.model.dealers.showList[button.tag];
        if (model.phone.isNotEmpty) {
            [PhoneCallWebView showWithTel:model.phone];
        }else{
            
            [UIAlertController showAlertInViewController:self withTitle:@"" message:@"经销商电话为空" cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
            }];
        }

//    }];
    
   
//    model.phone;
}
- (IBAction)askForPriceClicked:(UIButton *)button {
//    if (self.dealerCount==0) {
//        [[DialogView sharedInstance]showDlg:self.view textOnly:@"没有可用车型"];
//        return;
//    }

    
    switch (button.tag) {
        case footerButtonTag:
            [ClueIdObject setClueId:xunjia_05];
            break;
        case cellButtonTag:
            [ClueIdObject setClueId:xunjia_07];
            break;
        default:
            [ClueIdObject setClueId:xunjia_06];
            break;
    }
    
    if (button.tag == footerButtonTag || button.tag == cellButtonTag) {
        ///经销商为空
        AskForPriceNewViewController*vc = [[AskForPriceNewViewController alloc]init];
         vc.imageUrl = self.viewModel.model.picture.pic_url;
        if (self.cityId.isNotEmpty) {
            vc.cityId = self.cityId;
            vc.cityName = self.cityButton.titleLabel.text;
        }
        vc.carTypeId = self.viewModel.model.car_id;
        vc.carSerieasId = self.viewModel.model.car_brand_type_id;
        vc.carTypeName = self.viewModel.model.car_name;
         [self.rt_navigationController pushViewController:vc animated:YES];
       
    }else{
        AskForPriceViewController*vc = [[AskForPriceViewController alloc]init];
        vc.carTypeId = self.viewModel.model.car_id;
        vc.carSerieasId = self.viewModel.model.car_brand_type_id;
         CarTypeDetailDealerModel*model =   self.viewModel.model.dealers.showList[button.tag];
        
        
        vc.delearId = model.dealer_id;
        vc.carTypeName = self.viewModel.model.car_name;
         [self.rt_navigationController pushViewController:vc animated:YES];
    }
   
   
}

//经销商展开全部，隐藏部分
-(void)moreStoreButtonClicked:(UIButton*)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.maxDealerCount = NSIntegerMax;
    }else{
        self.maxDealerCount = defaltMaxDealerCount;
    }
    [button exchangeImageAndTitle];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.storeSection]];
}


#pragma mark 授权综合店切换


///排序切换
-(void)sortButtonClicked:(UIButton*)button{
    button.selected = !button.selected;
    self.currentSortName = self.storeTitleView.sortButton.titleLabel.text;
    
    self.selectedStoreName = self.storeTitleView.sortButton.titleLabel.text;
    [self typeButtonClicked:button];
}
///展示类型切换的方法，判断按钮的选中与否
-(void)typeButtonClicked:(UIButton*)button{
    @weakify(self);
    if (button.selected) {
        
        if (self.collectionView.contentOffset.y !=headerCellHeight) {
          
                [self.collectionView setContentOffset:CGPointMake(0, headerCellHeight)animated:YES ] ;
            self.block = ^(BOOL finished){
                @strongify(self);
                [self storeTypeBackgroundViewShowWithButton:button];
            };
         }else{
            
            [self storeTypeBackgroundViewShowWithButton:button];

        }
        
        
    }else{
        [self.storeTypeBackgroundView dismissWithAnimationComplation:^(BOOL isFinished) {
            button.selected = NO;
        }];
        //        [self hideStoreTableView:nil];
    }

}
///展示类型切换的方法
-(void)storeTypeBackgroundViewShowWithButton:(UIButton*)button{
    @weakify(self);
        [self.storeTypeBackgroundView showWithlistArray:self.showTypeListArray selectedString:self.selectedStoreName animationComplation:^(BOOL isFinished) {
            
        } itemSelectedBlock:^(NSInteger index, NSString *itemString) {
            @strongify(self);
            if ([itemString isEqual:sortTypeNearestWay]||[itemString isEqual:sortTypeTotal]) {
                [self.storeTitleView.sortButton setTitle:itemString forState:UIControlStateNormal];
                [self.storeTitleView.sortButton exchangeImageAndTitle];
                self.currentSortName = itemString;
                [self storeButtonClicked:self.storeTitleView.sortButton];
            }else{
                [self.storeTitleView.storeButton setTitle:itemString forState:UIControlStateNormal];
                [self.storeTitleView.storeButton exchangeImageAndTitle];
                self.currentStoreName = itemString;
                [self storeButtonClicked:self.storeTitleView.storeButton];
            }
            
            self.selectedStoreName = itemString;
            
            [self.collectionView reloadData];
        } dismissAnimationCompletionBlock:^(BOOL isFinished) {
            button.selected = NO;
        }];
        
    

}
///授权店综合店切换
-(void)storeButtonClicked:(UIButton*)button{
    button.selected = !button.selected;
    self.currentStoreName = self.storeTitleView.storeButton.titleLabel.text;
    self.selectedStoreName = self.storeTitleView.storeButton.titleLabel.text;
    [self typeButtonClicked:button];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.block&&self.collectionView.contentOffset.y ==headerCellHeight) {
        ///滚动结束，如果需要显示类型切换界面，执行该方法
        self.block(YES);
        self.block = nil;
    }
}


///授权店综合店选择界面设置当前选中界面后更改展示数据
-(void)setSelectedStoreName:(NSString *)selectedStoreName{
   
    
    [self setShowListWithSortType:self.currentSortName storeType:self.currentStoreName];
    
    
    
   
    
    _selectedStoreName = selectedStoreName;
}
-(void)setShowListWithSortType:(NSString*)sortType storeType:(NSString*)storeType{
    if ([sortType isEqualToString:sortTypeNearestWay ]&&[storeType isEqualToString:StoreTypeNormalWay ]) {
        self.viewModel.model.dealers.showList =self.viewModel.model.dealers.normalDistanceList;
    }else  if ([sortType isEqualToString:sortTypeNearestWay ]&&[storeType isEqualToString:StoreTypeUnixWay ]) {
        self.viewModel.model.dealers.showList = self.viewModel.model.dealers.unixDistanceList;
    }else  if ([sortType isEqualToString:sortTypeTotal ]&&[storeType isEqualToString:StoreTypeNormalWay ]) {
        self.viewModel.model.dealers.showList = self.viewModel.model.dealers.normalList;
    }else  if ([sortType isEqualToString:sortTypeTotal ]&&[storeType isEqualToString:StoreTypeUnixWay ]) {
        self.viewModel.model.dealers.showList = self.viewModel.model.dealers.unixList;
    }
   
    
}

///贷款计算
-(void)daiKuanButtonClicked:(UIButton*)button{
   
    BuyCarCalculatorViewController*vc  = [[ BuyCarCalculatorViewController alloc]init];
//    vc.paiLiangString =self.viewModel.model.  car.engine_capacity;
//    vc.seatNumber = car.seatnum;
    vc.cheXingString = self.viewModel.model.car_name;
    if (self.viewModel.model.factory_price.isNotEmpty) {
        vc.price = [self.viewModel.model.factory_price floatValue]*10000;
    }else{
        vc.price =0;
    }
     vc.buyType = BuyTypeDaiKuan;
  
    
    [self.rt_navigationController pushViewController:vc animated:YES];
}
///全款计算
-(void)quanKuanButtonClicked:(UIButton*)button{
    BuyCarCalculatorViewController*vc  = [[ BuyCarCalculatorViewController alloc]init];
    //    vc.paiLiangString =self.viewModel.model.  car.engine_capacity;
    //    vc.seatNumber = car.seatnum;
    vc.cheXingString = self.viewModel.model.car_name;
    if (self.viewModel.model.factory_price.isNotEmpty) {
        vc.price = [self.viewModel.model.factory_price floatValue]*10000;
    }else{
        vc.price =0;
    }
    vc.buyType = BuyTypeQuanKuan;
    [self.rt_navigationController pushViewController:vc animated:YES];
}
///加入pk
-(void)addPkButtonClicked:(UIButton*)button{
    if(CompareMaxCount == [CompareDict shareInstance].count){
        [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"最多支持%d款车型！",CompareMaxCount] ];
        return;
    }
    button.enabled = NO;
   
    FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel alloc]init];
    model.car_id = self.chexingId;
    
    model.car_name = [NSString stringWithFormat:@"%@ %@",self.viewModel.model.car_brand_type_name, self.viewModel.model.car_name];
    model.factory_price = self.viewModel.model.factory_price;
    
    [[CompareDict shareInstance] setObject:model forKey:self.chexingId];
    CompareListViewController*vc = [[CompareListViewController alloc]init];
    [vc editCompareSlectedDictWithModel:model isDelete:NO];
    [model save];
    if([CompareDict shareInstance].count == 0){
        self.PKCountLabel.hidden = YES;
    }else{
        self.PKCountLabel.hidden = NO;
        self.PKCountLabel.text =[NSString stringWithFormat:@"%lu",  [CompareDict shareInstance].count];
    }
      CarTypeHeaderCollectionViewCell*cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.headerSection]];
    CGRect frame = [cell convertRect:[cell.pkButton.superview convertRect:cell.pkButton.frame toView:cell] toView:self.view];
    UIButton*newButton = [Tool createButtonWithImage:button.imageView.image target:nil action:nil tag:0];
    newButton.frame = frame;
    [self.view addSubview:newButton];
    
    [newButton layoutIfNeeded];
    
    CGRect pkFrame = [self.customNavigationView convertRect:self.PKButton.frame toView:self.view];
    //    newButton.frame = CGRectMake(pkFrame.origin.x, frame.origin.y, frame.size.width/2, frame.size.height/2);
    //    [UIView animateWithDuration:0.5 animations:^{
    //        newButton.frame = CGRectMake(pkFrame.origin.x, frame.origin.y, frame.size.width/2, frame.size.height/2);
    //    }completion:^(BOOL finished) {
    [UIView animateWithDuration:0.5 animations:^{
        newButton.center =  CGPointMake(pkFrame.origin.x+pkFrame.size.width/2, pkFrame.origin.y+pkFrame.size.height/2);
        newButton.frame = CGRectMake(pkFrame.origin.x+pkFrame.size.width/2, pkFrame.origin.y+pkFrame.size.height/2, frame.size.width/2, frame.size.height/2);
        //newButton.bounds = CGRectMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        
        [newButton removeFromSuperview];
        [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"车型添加成功"] ];
    }];
    

//    [[DialogView sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"车型添加成功"] ];

}
///pk
-(IBAction)PKButtonClicked:(UIButton*)button{
    CompareListViewController*VC = [[CompareListViewController alloc]init];
    [self.rt_navigationController pushViewController:VC animated:YES];
}

///分享
-(IBAction)shareButtonClicked:(UIButton*)button{
    NSString *title = @"";
    title = [NSString stringWithFormat:@"%@ %@万",self.viewModel.model.car_name,self.viewModel.model.factory_price];
    
    NSString *commentShare = shareContent;
    NSString *content = [NSString stringWithFormat:@"【%@】%@",self.viewModel.model.car_name,commentShare];
    
    
    self.shareView.title = title;
    self.shareView.content = content;
    self.shareView.share_url = self.viewModel.model.share_link;
    self.shareView.pic_url = self.viewModel.model.picture.pic_url;
    [self.shareView setMyownshareType:ShareArt];
    
    [self.shareView initPopView];

}
//收藏

-(IBAction)favouriteButtonClicked:(UIButton*)button{
    if(button.selected){
        [self deleteModel:button];
    }else{
        if ([[UserModel shareInstance].uid isNotEmpty]) {
            [self saveModel:button];
        }else{
            //这边是用来重新登录并且绘制界面
            ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
            [URLNavigation pushViewController:controller animated:YES];
            
            @weakify(self)
            controller.loginSuccessDataBlock = ^{
                [self_weak_ updateView];
            };
        }        
    }
    
}

///这边是用来重新登录并且绘制界面
-(void)updateView{
    NSArray *records = [KouBeiCarTypeModel findByColumn:@"colId" value:self.chexingId];
    if ( [records count] ) {
        self.favouriteButton.selected = YES;
    }else{
        self.favouriteButton.selected = NO;
    }
    
}
//城市选择
-(IBAction)cityButtonClicked:(UIButton*)button{
    if (self.storeTitleView.storeButton.selected) {
         [self storeButtonClicked:self.storeTitleView.storeButton];
    }
    if (self.storeTitleView.sortButton.selected) {
        [self sortButtonClicked:self.storeTitleView.sortButton];
    }
    CityViewController*vc = [[CityViewController alloc]init];
//    @weakify(self);
//    vc.citySelectedBlock = ^(AreaNewModel*model){
//        @strongify(self);
//        if (![self.cityId isEqual:model.id]) {
//            self.cityId = model.id;
//            self.viewModel.request.cityId= self.cityId;
//            self.viewModel.request.startRequest = YES;
//            [self addjustButton:self.cityButton WithTitle:model.name];
//        }
//       
//    };
    [self.rt_navigationController pushViewController:vc animated:YES];
    
}
///收藏 
-(void)saveModel:(UIButton*)button{
    KouBeiCarTypeModel *art = [[KouBeiCarTypeModel alloc]init];
    if([self.pic isNotEmpty]){
        art.imgurl = self.pic;
    }
    else{
        art.imgurl = self.viewModel.model.picture.pic_url;
    }

    
    art.name = self.viewModel.model.car_name;
    art.zhidaoPrice = self.viewModel.model.factory_price;
    art.colId = self.chexingId;
    art.tag = chexing;
    art.typeName = self.viewModel.model.car_brand_type_name;

    
    [self.subjectObject InfoSaveObject:art typeid:chexing];
    
    @weakify(self)
    self.subjectObject.infoBlock = ^(bool isok) {
         if (isok) {
             [self_weak_ showSaveSuccess];
             button.selected =YES;
         }else{
             [self_weak_ showSaveSuccessWithTitle:@"收藏失败"];
         }
        
    };

}
///返回
- (IBAction)backClicked:(UIButton *)sender {
    [self leftButtonTouch];
}

-(void)leftButtonTouch{
    [super  leftButtonTouch];
}



///历史记录
-(void)saveBrowesModel{
    BrowseKouBeiCarTypeModel *model = [[BrowseKouBeiCarTypeModel alloc] init];
    
    
    if([self.pic isNotEmpty]){
    model.pic = self.pic;
    }
    else{
        model.pic = self.viewModel.model.picture.pic_url;
    }
    model.name = self.viewModel.model.car_name;
    model.price = self.viewModel.model.factory_price;
    model.id = self.chexingId;
    model.tag = chexing;
    model.typeName = self.viewModel.model.car_brand_type_name;
    
    if([model.id isNotEmpty]){
        [model save];
        
    }
    
}

-(void)deleteBrowesModel:(BrowseKouBeiCarTypeModel *) model{
    BrowseKouBeiCarTypeModel *temp = model;
    [temp deleteSelf];
}

-(void)deleteModel:(UIButton*)button{
    NSArray *art = [KouBeiCarTypeModel findByColumn:@"colId" value:self.chexingId];
    if ([art count]) {
        KouBeiCarTypeModel *temp = art[0];
        [self.subjectObject InfoMoveObject:temp typeid:chexing];
        
        @weakify(self)
        self.subjectObject.infoBlock = ^(bool isok) {
            if (isok) {
                [self_weak_ showSaveRemove];
                 button.selected =NO;
            }else{
                [self_weak_ showSaveSuccessWithTitle:@"收藏失败"];
            }
            
        };
    }
}
#pragma mark 地图
-(void)addMap{
    [self.view layoutIfNeeded];
    if(self.moreStoreAndMapCell.mapView.hidden==YES){
        return;
    }

    if (!self.animationArray) {
        self.animationArray = [NSMutableArray array];
    }else{
       
        [self.moreStoreAndMapCell.mapView removeAnnotations:self.animationArray];
         [self.animationArray removeAllObjects];
    }
   
  __block  CGFloat minLat = 0;
  __block  CGFloat maxLat = 0;
    __block CGFloat minLon = 0;
  __block  CGFloat maxLon = 0;
    
    [self.viewModel.model.dealers.showList enumerateObjectsUsingBlock:^(CarTypeDetailDealerModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CustomAnimation* item = [[CustomAnimation alloc]init];
        item.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
        item.title = model.dealer_name;
        //            item.positionName = @"P";
        item.isStop = YES;
       
        
        item.subtitle = [NSString stringWithFormat:@"%@万",model.price];
        [self.animationArray addObject:item];
        
        if (minLon==0) {
            minLon = model.lon;
        }
        if (minLat ==0) {
            minLat = model.lat;
        }
        
        minLat = (minLat < model.lat?minLat:model.lat);
        maxLat = (maxLat > model.lat?maxLat:model.lat);
        minLon = (minLon < model.lon?minLon:model.lon);
        maxLon = (maxLon > model.lon?maxLon:model.lon);

    }];
    
    //计算中心点
    CLLocationCoordinate2D centCoor;
    centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
    centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
    BMKCoordinateSpan span;
    //计算地理位置的跨度
    span.latitudeDelta = maxLat - minLat;
    span.longitudeDelta = maxLon - minLon;
    //得出数据的坐标区域
    BMKCoordinateRegion region = BMKCoordinateRegionMake(centCoor, span);
    
    
    [self.moreStoreAndMapCell.mapView addAnnotations:self.animationArray];
    if (self.animationArray.count >=1) {
        [self.moreStoreAndMapCell.mapView selectAnnotation: [self.animationArray firstObject] animated:NO];
    }
    
    //百度地图的坐标范围转换成相对视图的位置
    CGRect fitRect = [self.moreStoreAndMapCell.mapView convertRegion:region toRectToView:self.moreStoreAndMapCell.mapView];
    NSLog(@"%f,%f,%f,%f",fitRect.origin.x,fitRect.origin.y,fitRect.size.width,fitRect.size.height);
    NSInteger width = 15;
    NSInteger height = 15;
    fitRect.origin.x -= width;
    fitRect.origin.y -= height;
    fitRect.size.width  += (width*2);
    fitRect.size.height += (height*2);
   NSLog(@"%f,%f,%f,%f",fitRect.origin.x,fitRect.origin.y,fitRect.size.width,fitRect.size.height);
    //将地图视图的位置转换成地图的位置，
    BMKMapRect fitMapRect = [self.moreStoreAndMapCell.mapView convertRect:fitRect toMapRectFromView:self.moreStoreAndMapCell.mapView];
    //设置地图可视范围为数据所在的地图位置
    [self.moreStoreAndMapCell.mapView setVisibleMapRect:fitMapRect animated:YES];
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"parking";
    BMKAnnotationView* annotationView;
    AnnotationViewID = @"location";
        // 生成重用标示identifier
        
        
        // 检查是否有重用的缓存
        annotationView= [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (annotationView == nil) {
            annotationView = [[CustomPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            //            ((CustomPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            // 设置重天上掉下的效果(annotation)
            //            ((CustomPinAnnotationView*)annotationView).animatesDrop = YES;
        }
        
        annotationView.image = [UIImage imageNamed:@"定位红"];
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        annotationView.canShowCallout = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
//        [annotationView addGestureRecognizer:tap];
//    }
    
    
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    ((CustomPinAnnotationView*)annotationView).indexString =((CustomAnimation*)annotation).positionName;
    //真是的数字
    int realcount = [((CustomAnimation*)annotation).positionName intValue]-2;
    if(realcount < 0){
        realcount = 0;
    }
    annotationView.tag = realcount;
    
    return annotationView;
}

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    self.mapIsLoad = YES;
    
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    BMKMapRect fitMapRect =  mapView.visibleMapRect;
    CGRect fitRect = [mapView convertMapRect:fitMapRect toRectToView:mapView];
    NSInteger height = 65;
    if (view.frame.origin.y < height) {
        height = height - view.frame.origin.y;
    }else if(mapView.frame.size.height - view.frame.origin.y < 35){
        height = mapView.frame.size.height - view.frame.origin.y-35;
    }else{
        height = 0;
    }
    
    
    fitRect.origin.y -=height;
    
    
    NSLog(@"%f,%f,%f,%f",fitRect.origin.x,fitRect.origin.y,fitRect.size.width,fitRect.size.height);
    //将地图视图的位置转换成地图的位置，
    fitMapRect = [mapView convertRect:fitRect toMapRectFromView:mapView];
    //  view.calloutOffset =
    // 设置位置
    [mapView setVisibleMapRect:fitMapRect animated:YES];
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    MapViewController*map = [[MapViewController alloc]init];
    map.animationArray = self.animationArray;
    [self.rt_navigationController pushViewController:map animated:YES];
}
#pragma mark 地图结束
//-(void)mapViewTouchDown:(UITapGestureRecognizer*)tap{
//    MapViewController*map = [[MapViewController alloc]init];
//    map.animationArray = self.animationArray;
//    [self.rt_navigationController pushViewController:map animated:YES];
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([CompareDict shareInstance].count == 0){
        self.PKCountLabel.hidden = YES;
    }else{
        self.PKCountLabel.hidden = NO;
        self.PKCountLabel.text =[NSString stringWithFormat:@"%lu",  [CompareDict shareInstance].count];
    }
    if (self.collectionView.numberOfSections >0) {
         CarTypeHeaderCollectionViewCell*cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:self.headerSection]];
        CompareDict*dict = [CompareDict shareInstance] ;
        if ([dict objectForKey:self.chexingId]) {
            cell.pkButton.enabled = NO;
        }else{
            cell.pkButton.enabled = YES;
        }
    }
    
    
   
    
   
    
}

-(NSInteger)headerSection{
    return 0;
}
-(NSInteger)storeSection{
    return 1;
}
-(NSInteger)moreStoreAndMapSection{
    if (self.dealerCount > 0) {
        return 2;
    }else{
        return 3;
    }
    
    
}
-(NSInteger)supportCarSeriesSection{
    if (self.dealerCount > 0) {
        return 3;
    }else{
        return 2;
    }
    
    
}

-(NSInteger)dealerCount{
    if ( self.viewModel.model.dealers.showList.count > self.maxDealerCount) {
        _dealerCount = self.maxDealerCount;
    }else{
        _dealerCount = self.viewModel.model.dealers.showList.count;
    }
    return _dealerCount;
}
-(NSArray*)sortTypeListArray{
   
    
    if(self.viewModel.model.dealers.listbydis > 0){
        return _sortTypeListArray = @[sortTypeTotal,sortTypeNearestWay];
    }else{
        return  _sortTypeListArray = @[sortTypeTotal];
    }
}
-(NSArray*)storeListArray{
    ///授权店综合店选择界面数据更新
   
    if ([self.currentSortName isEqual:sortTypeTotal]) {
       
            _storeListArray = @[StoreTypeNormalWay];
            
       
        if (self.viewModel.model.dealers.unixList.count > 0) {
            
            _storeListArray =[_storeListArray arrayByAddingObject:StoreTypeUnixWay];
        }

    }else{
        
            _storeListArray = @[StoreTypeNormalWay];
            
        
        if (self.viewModel.model.dealers.unixDistanceList.count > 0) {
            
            _storeListArray =[_storeListArray arrayByAddingObject:StoreTypeUnixWay];
        }

    }
    
    
    
    return _storeListArray;
    
    
}
-(NSArray*)showTypeListArray{
    if ([self.selectedStoreName isEqual:sortTypeNearestWay]||[self.selectedStoreName isEqual:sortTypeTotal]) {
         _showTypeListArray = self.sortTypeListArray;
    }else{
        
          _showTypeListArray = self.storeListArray;
    }
    
    return _showTypeListArray;
}
-(NSArray*)hozirontalListArray{
    if (!_hozirontalListArray) {
        _hozirontalListArray = @[@{@"title":Picture,@"imageName":Picture,},
                                 @{@"title":config,@"imageName":config},
                                 @{@"title":comment,@"imageName":comment},
                                 @{@"title":information,@"imageName":information}];
    }
    return _hozirontalListArray;
}
-(NSString*)currentSortName{
    if (!_currentSortName) {
        _currentSortName = sortTypeTotal;
    }
    return _currentSortName;
}
-(NSString*)currentStoreName{
    if (!_currentStoreName) {
        _currentStoreName = StoreTypeNormalWay;
    }
    return _currentStoreName;
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
