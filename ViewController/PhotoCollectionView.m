//
//  PhotoUICollectionView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoDetailViewController.h"
#import "WithOutDataCollectionViewCell.h"
#import "PicModel.h"

#import "PhotoMoreViewController.h"

@interface PhotoCollectionView()

@property(nonatomic,strong) PhotoViewModel *morePhoto;

@property(nonatomic,strong)NSString *color;

//判断是否是刷新
@property(nonatomic,assign)bool isheadfresh;
@property(nonatomic,strong)NSMutableArray<PicModel*> *pic;
//@property(nonatomic,assign)BOOL isWithOutData;
//传递值
///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;

@end
@implementation PhotoCollectionView


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource =self;
        self.delegate = self;
        self.page =1;
        [self bindXib:self];
        //头部高度
        self.backgroundColor = [UIColor whiteColor];
        //数据
        self.model = [PhotoViewModel SceneModel];
        self.morePhoto= [PhotoViewModel SceneModel];
        @weakify(self);
        //下拉更新
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.isheadfresh = true;
            [self headerRefresh];
            
        }];
       
        //上拉加载
        [self updateDate];
    }
    self.photos = [[NSMutableArray alloc]init];
//    [self.mj_header beginRefreshing];
    return self;
}


-(void)headerRefresh{
    self.page = 1;
    self.model.request.categoryId = self.catgoryId;
    self.model.request.typeId = self.typeId;
    self.model.request.carId = self.carId;
    self.model.request.limit = 21;
    self.model.request.page = 1;
    self.model.request.needLoadingView = NO;
    self.model.request.startRequest = YES;
}
/// 切换的时候加载数据
-(void)changeView{
    bool needUpdate = NO;
    NSDictionary*dict = self.model.request.output;
    if (![dict isNotEmpty]||![self.model.request.carId isEqual:self.carId]||![self.model.request.typeId isEqual:self.typeId]) {
        needUpdate = YES;
    }
    
    
    if (needUpdate) {
        self.page = 1;
        self.model.request.categoryId = self.catgoryId;
        self.model.request.typeId = self.typeId;
        self.model.request.carId = self.carId;
        self.model.request.limit = 21;
        self.model.request.page = 1;
        self.model.request.needLoadingView = NO;
        self.model.request.startRequest = YES;
    }

}

-(void)updateDate{
    self.pic = [[NSMutableArray alloc] init];


   
    @weakify(self);
    [[RACObserve(self.model.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.model.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSError*error;
          PhotoFatherModel*model = [[PhotoFatherModel alloc]initWithDictionary:self.model.request.output[@"data"] error:&error];
          
          if (error) {
              NSLog(@"%@", error.description);
          }
          self.page++;
          self.pic = [model.list mutableCopy];
          
          //将第一笔数据放入到 首页面
          self.block(self.pic,self.catgoryId);
          [self initPhotos];
          [self.mj_header endRefreshing];
          [self.mj_footer endRefreshing];
          if (self.pic.count >0) {
              if (self.mj_footer==nil) {
                  self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                      @strongify(self);
                      self.isheadfresh = false;
                      [self loadMore];
                  }];
                  
              }
              if (model.count ==self.pic.count) {
                  [self.mj_footer setState:MJRefreshStateNoMoreData];
                  ((MJRefreshAutoNormalFooter*)self.mj_footer).stateLabel.text = [NSString stringWithFormat:@"共有%ld张图片",self.pic.count];
              }
              [self dismissWithOutDataView];
              [self reloadData];
          }else{
              [self showWithOutDataViewWithTitle:@"暂无图片"];
             
              [self reloadData];
          }
          
      }];

    [[RACObserve(self.model.request,state)filter:^BOOL(id value) {
         @strongify(self);
        return  self.model.request.failed;
    }]subscribeNext:^(id x) {
         @strongify(self);
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
        self.pic = nil;
        [self initPhotos];
        if (self.pic.count >0) {
            [self dismissWithOutDataView];
            [self reloadData];
        }else{
            [self showWithOutDataViewWithTitle:@"暂无图片"];
            [self reloadData];
        }
    }];
    self.model.request.color = @"0";
    self.model.request.page = self.page;
    self.model.request.limit = 21;
    
    
     [[RACObserve(self.morePhoto.request, state)
                         filter:^BOOL(id value) {
                             @strongify(self);
                             return self.morePhoto.request.succeed;
                         }]subscribeNext:^(id x) {
                             @strongify(self);
                             
                             NSError*error;
                             PhotoFatherModel*model = [[PhotoFatherModel alloc]initWithDictionary:self.morePhoto.request.output[@"data"] error:&error];
                             
                             if (error) {
                                 NSLog(@"%@", error.description);
                             }
                             
                             [self.mj_footer endRefreshing];
                             
                             if (model.count !=self.pic.count) {
                                 self.page++;
                                 [self.pic addObjectsFromArray:model.list];
                             }else{
                                 //这边设置共多少条图片
                               
                                 [self.mj_footer setState:MJRefreshStateNoMoreData];
                                 ((MJRefreshAutoNormalFooter*)self.mj_footer).stateLabel.text = [NSString stringWithFormat:@"共有%ld张图片",self.pic.count];
                             }
                             
                             [self initPhotos];
                             //方法一
                             [UIView performWithoutAnimation:^{
                                 [self reloadData];
                             }];
                             
                         }];
    [[RACObserve(self.morePhoto.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.morePhoto.request.failed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.morePhoto.request.output;
          NSError*error;
          [self.mj_header endRefreshing];
          [self.mj_footer endRefreshing];
          
          
          [self initPhotos];
          //方法一
          [UIView performWithoutAnimation:^{
              [self reloadData];
          }];
          
          
          
          
      }];


}

-(void)bindXib:(UICollectionView *)collectionView{

    [collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    [collectionView registerClass:[WithOutDataCollectionViewCell class] forCellWithReuseIdentifier:classNameFromClass(WithOutDataCollectionViewCell)];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicModel *model = self.pic[indexPath.row];
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    [cell.image setImageWithURL:[NSURL URLWithString:model.smallpic] placeholderImage:[UIImage imageNamed:@"默认图片105_80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
  
        return self.pic.count;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 10;

}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
           return CGSizeMake((kwidth-30-20)/3, 80);

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mj_header.state ==MJRefreshStateIdle||self.mj_header.state ==MJRefreshStateNoMoreData) {
        [self jump2photo:indexPath.row];
    }
    
    
}

//跳转图片
-(void)jump2photo:(NSInteger) count{
    // 图片游览器
    PhotoMoreViewController *pickerBrowser = [[PhotoMoreViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos;
    pickerBrowser.toolBarList = self.menu;
    pickerBrowser.carId = self.carId;
   
    PicModel *model = self.pic[count];
     pickerBrowser.typeId  =model.car_brand_type_id;
    pickerBrowser.carName = model.car_name;
    pickerBrowser.carType = self.carType;
    pickerBrowser.carPrice = model.price;
    pickerBrowser.labelCurrentNumber =  self.labelCurrentNumber;
    pickerBrowser.labelCurrentName = self.labelCurrentName;
    pickerBrowser.catgoryId = self.catgoryId;
    pickerBrowser.colorId = self.colorId;
    pickerBrowser.forestalllDict = self.forestalllDict;
    
    pickerBrowser.has_dealer = model.has_dealer;
    // 当前选中的值
    pickerBrowser.currentIndex = count;
    
    //跳转方式
    dispatch_async(dispatch_get_main_queue(), ^{
        // 展示控制器
        [pickerBrowser showPickerVc:[Tool currentViewController]];
    });

    
}

//初始化列表
-(void)initPhotos{
    [self.photos removeAllObjects];
    for (PicModel *model in self.pic) {
            
                ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                photo.photoURL = [NSURL URLWithString:model.bigpic];
        NSString *info = [NSString stringWithFormat:@"%@ %@",self.carType,model.car_name];
        photo.picName = info;
        photo.price = model.price;
                [self.photos addObject:photo];
        }
}



//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
   
        return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、
}


//首页加载更多
-(void)loadMore{
//    PhotoViewModel *morePhoto = [PhotoViewModel SceneModel];
//    
//    morePhoto.request.color = @"0";
//    morePhoto.request.page = self.page;
//    morePhoto.request.startRequest = YES;
 
   

    self.morePhoto.request.color = self.colorId;
    self.morePhoto.request.carId = self.carId;
    self.morePhoto.request.categoryId = self.catgoryId;
    self.morePhoto.request.typeId = self.typeId;
    self.morePhoto.request.limit = 21;
    self.morePhoto.request.page = self.page;
    self.morePhoto.request.needLoadingView = NO;
    self.morePhoto.request.startRequest = YES;
    
//    [[RACObserve(self.morePhoto, model)
//      filter:^BOOL(id value) {
//          //只有推荐的加载才是走这个方法
//          [self.mj_footer endRefreshing];
//          return self.morePhoto.model.isNotEmpty;
//      }]subscribeNext:^(id x) {
//          self.page++;
//          [self.pic addObjectsFromArray:self.morePhoto.model.list];
//          [self initPhotos];
//          //方法一
//          [UIView performWithoutAnimation:^{
//              [self reloadData];
//          }];
//          
//      }];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
