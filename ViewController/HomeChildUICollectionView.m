

//
//  HomeChildUICollectionView.m
//  chechengwang
//
//  Created by 严琪 on 16/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "HomeChildUICollectionView.h"

#import "TitleWithImageCollectionViewCell.h"
#import "TitleWithThreeImageCollectionViewCell.h"
#import "NormalCollectionViewCell.h"

#import "PublicNormalCollectionViewCell.h"

#import "HorizontalScrollViewCell.h"
#import "TitleCollectionViewCell.h"
#import "ZiMeiTiWithThreeImageCollectionViewCell.h"

//#import "HotBrandCollectionViewCell.h"

#import "HomeGuideCollectionViewCell.h"
#import "HomeTagCollectionViewCell.h"

#import "BrandModel.h"

#import "HomeViewModel.h"
#import "HomeMoreViewModel.h"
#import "HomeSecondMoreViewModel.h"
#import "VideoViewModel.h"

#import "CollectionViewController.h"
#import "CarSeriesViewController.h"
#import "TabBarViewController.h"
#import "ViewLineCollectionCollectionReusableView.h"
#import "NewVideoCollectionViewController.h"

#import "ActiveViewController.h"
#import "Brand.h"


#import "DeliverModel.h"
#import "ReadRecordModel.h"

#import "VideoViewController.h"
#import "ArtInfoViewController.h"
#import "BrowseKouBeiArtModel.h"

#import "VideoBigCellCollectionViewCell.h"
#import "VideoModel.h"

//喜好
#import "TagsListModel.h"
#import "XiHaoUserViewModel.h"



typedef NS_ENUM(NSInteger,childinfotype){
    //title
    title = 0,
    //table
    table = 1,
    //bigimage
    bigimage  = 3,
    //threeimage
    threeimage  = 2,
    //多标题
    moreBrands = 4,
    //视频大图
    bigVideo = 5

};

@interface HomeChildUICollectionView()

@property(nonatomic,strong)HomeMoreViewModel *moremodel;

@property(nonatomic,strong)HomeMoreViewModel *newmoremodel;

@property(nonatomic,strong)HomeSecondMoreViewModel *secondmoremodel;

@property(nonatomic,strong)VideoViewModel *videoViewModel;
@property(nonatomic,strong)NSString *catid;
//数据 首页写缓存 接口也是不同的
@property(nonatomic,strong)HomeViewModel *fristmodel;
@property (nonatomic,assign) bool isFristModel;
//第二页，第二页不用写缓存
@property(nonatomic,strong)HomeSecondViewModel *model;

@property (nonatomic, strong)NSMutableArray<PicShowModel> *piclist;
@property (nonatomic, strong)BannerCollectionReusableView *headerView;
@property (nonatomic, strong)NewVideoCollectionViewController *videoHeaderView;

@property (nonatomic, strong) NSMutableArray<BannerModel> *bannerlist;
//中间的品牌
@property (nonatomic, strong) NSMutableArray<Brand> *brands;
//数据处理
@property (nonatomic, strong) NSMutableArray<BrandModel>  *brandlist;
//屏幕宽度
@property (nonatomic,assign) CGRect rx;

//判断是否是刷新
@property(nonatomic,assign)bool isheadfresh;

@property(nonatomic,assign)NSUInteger pageid;

@property(nonatomic,strong)DeliverModel *deliverModel;

//初始滑动距离
@property(nonatomic,assign)CGFloat defaultScrollViewY;


//视屏列表
@property (nonatomic,copy) NSMutableArray<VideoModel> *videoList;
@property (nonatomic,assign) bool isVideo;

@property (nonatomic,strong)TagsListModel *tagModel;

//用户下载
@property(nonatomic,strong)XiHaoUserViewModel *userViewModel;
@property(nonatomic,strong)HomeTagCollectionViewCell *tagsCell;

@end

@implementation HomeChildUICollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout catId:(NSString*)catId isFirstModel:(BOOL)isFirstModel isVideoModel:(BOOL)isVideoModel{
   
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
       
        self.deliverModel = [[DeliverModel alloc] init];
        self.defaultScrollViewY = 0;
        self.delegate = self;
        self.dataSource =self;
        
        self.pageid =1;
        
        [self bindXib:self];
        
        self.piclist = [[NSMutableArray<PicShowModel> alloc] init];
        self.bannerlist = [[NSMutableArray<BannerModel> alloc]init];
        self.isFristModel = isFirstModel;
          @weakify(self);
        if (isFirstModel) {
            
              [[[RACSignal combineLatest:@[RACObserve([UserModel shareInstance], uid),RACObserve([UserSelectedTool shareInstance], isChangeTags)]]
              filter:^BOOL(id value) {
                  return [UserSelectedTool shareInstance].isChangeTags || [UserModel shareInstance].uid;
              }]subscribeNext:^(id x) {
                  
                  self.pageid = 0;
                  
                  NSArray *arry = [[XiHaoClickObject getnames]  componentsSeparatedByString:@","];
                  
                  __block NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
                  __block NSMutableArray *ids = [NSMutableArray arrayWithCapacity:1];
                  [self.tagModel.data enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      [arry enumerateObjectsUsingBlock:^(NSString *nsobj, NSUInteger idx, BOOL * stop) {
                          if ([nsobj isEqualToString:obj.name]) {
                              [temp addObject:obj];
                              [ids addObject:obj.id];
                              [obj save];
                              *stop = YES;
                          }
                      }];
                  }];
                  
                  [self.tagModel.userdata removeAllObjects];
                  [self.tagModel.userdata addObjectsFromArray:temp];
                  [self.tagsCell setXiHaoDataByForm:self.tagModel];
                  
                  //自动刷新数据
                  if (x && [UserModel shareInstance].uid) {

                      self.fristmodel.request.uid = [UserModel shareInstance].uid;
                      self.fristmodel.request.tags = nil;
                      [self reloadData];
                  }else{

                      [self reloadData];
                      self.fristmodel.request.tags = [self pictureArrayToJSON:temp];

                  }
              }];
            
//            [RACObserve([UserModel shareInstance], uid) subscribeNext:^(id x) {
//                if ([[UserModel shareInstance].uid isNotEmpty]) {
//                    self.userViewModel.request.uid = [UserModel shareInstance].uid;
//                    self.userViewModel.request.startRequest = YES;
//                    
//                    self.fristmodel.request.uid = [UserModel shareInstance].uid;
//                    self.fristmodel.request.startRequest = YES;
//                }else{
//                    self.fristmodel.tagrequest.startRequest = YES;
//                }
//            }];
            
            if ([[UserModel shareInstance].uid isNotEmpty]) {
                self.userViewModel.request.uid = [UserModel shareInstance].uid;
                self.userViewModel.request.startRequest = YES;
                
                self.fristmodel.tagrequest.startRequest = YES;

            }else{
                 self.fristmodel.tagrequest.startRequest = YES;
            }
           
            //下拉更新
            self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                self.isheadfresh = true;
                [self loadPullMore];
             
            }];
            
        }else if(isVideoModel){
            self.isVideo = isVideoModel;
            self.videoViewModel.listRequest.startRequest = YES
            ;
            
            //下拉更新
            self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                self.isheadfresh = true;
                self.videoViewModel.listRequest.page = 1;
                self.videoViewModel.listRequest.startRequest = YES
                ;
                [self.mj_header endRefreshing];
            }];
        }
        else{
            self.model = [HomeSecondViewModel SceneModel];
            self.catid = catId;
            self.model.request.cateid = catId;
            self.model.request.startRequest =YES;
            [[RACObserve(self.model, data)
              filter:^BOOL(id value) {
                  @strongify(self);
                  return self.model.data.isNotEmpty;
              }]subscribeNext:^(id x) {
                  @strongify(self);
                  [self.bannerlist removeAllObjects];
                  self.piclist = [self.deliverModel deliverPicModel:self.model.data.list];
//                  [self.bannerlist addObjectsFromArray: self.model.data.picShow];
                
                  //上拉加载
                  if (self.mj_footer==nil) {
                      self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                           @strongify(self);
                          self.isheadfresh = false;
                          [self loadOtherMore];
                          [self.mj_footer endRefreshing];
                      }];
                       ((MJRefreshAutoNormalFooter*) self.mj_footer).triggerAutomaticallyRefreshPercent = -20;
                  }
                 
                  [self reloadData];
              }];
            
            //下拉更新
            self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                
                @strongify(self);
                self.isheadfresh = true;
                self.model.request.startRequest =YES;
                [self.mj_header endRefreshing];
            }];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        
       
        
//        self.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
       
       
    }
    return self;
}

-(void)bindXib:(UICollectionView *)collectionView{
    //banner
    [collectionView registerNib:[UINib nibWithNibName:@"BannerCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BannerCollectionReusableView"];
    
    //一根顶边的线
    [collectionView registerNib:[UINib nibWithNibName:@"ViewLineCollectionCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ViewLineCollectionCollectionReusableView"];
    
    //normaltable
    [collectionView registerNib:[UINib nibWithNibName:@"NormalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NormalCollectionViewCell"];
    
    //new normaltable
    [collectionView registerNib:nibFromClass(PublicNormalCollectionViewCell) forCellWithReuseIdentifier:@"PublicNormalCollectionViewCell"];
    
    //bigimage
    [collectionView registerNib:[UINib nibWithNibName:@"TitleWithImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TitleWithImageCollectionViewCell"];
    //threeimage
    [collectionView registerNib:[UINib nibWithNibName:@"TitleWithThreeImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TitleWithThreeImageCollectionViewCell"];
    
    [collectionView registerNib:nibFromClass(ZiMeiTiWithThreeImageCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(ZiMeiTiWithThreeImageCollectionViewCell)];
    
    //title
    [collectionView registerNib:[UINib nibWithNibName:@"TitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TitleCollectionViewCell"];
    
    //中部信息
    [collectionView registerNib:[UINib nibWithNibName:@"HotBrandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotBrandCollectionViewCell"];
    
    //video大图片
    [collectionView registerNib:nibFromClass(VideoBigCellCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(VideoBigCellCollectionViewCell)];
    
    //video的头部
    [collectionView registerNib:nibFromClass(NewVideoCollectionViewController) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classNameFromClass(NewVideoCollectionViewController)];
    
    //新中间的文字
    [collectionView registerNib:nibFromClass(HomeGuideCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(HomeGuideCollectionViewCell)];
    
    [collectionView registerNib:nibFromClass(HomeTagCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(HomeTagCollectionViewCell)];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.isVideo) {
        return 1;
    }else{
//        if (self.brands.count>0) {
//            return 2;
//        }else{
//            return 1;
//        }
        if (self.isFristModel) {
        if ( self.tagModel.userdata.count>0) {
            return 3;
        }
        return 2;
        }else{
            return 1;
        }
    }
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (self.brands.count>0) {
//        if (section == 0) {
//            return 2;
//        }else{
//            return self.piclist.count;
//        }
//    }else{
//        if (self.isVideo) {
//            return self.videoList.count;
//        }else{
//
//            if (self.piclist.count>0) {
//                return  self.piclist.count;
//            }
//        }
//        return 0;
//    }
 
       if (self.isVideo) {
            return self.videoList.count;
        }else{
            if (self.isFristModel) {
                
                if ( self.tagModel.userdata.count>0) {
                    //这个 第一个是大banner图 第二个是品牌图
                    if (section == 0)
                        return 1;
                    if (section == 1)
                        return 1;
                    return self.piclist.count;
                }else{
                    if (section == 0)
                        return 1;
                    return self.piclist.count;
                }
                
            }else{
                return self.piclist.count;
            }
        }
}

///切换当前的对象
//-(void)exChangeBrands{
//    if (!self.brandlist) {
//        self.brandlist = [[NSMutableArray<BrandModel>  alloc]init];
//    }else{
//        [self.brandlist removeAllObjects];
//    }
//
//    for (int i =0; i<self.brands.count; i++) {
//        Brand *temp_brand = self.brands[i];
//        BrandModel *model = [[BrandModel alloc] init];
//        model.name = temp_brand.name;
//        model.url = temp_brand.pic_url;
//        model.id = temp_brand.id;
//        [self.brandlist addObject:model];
//    }
//}

///获取到对应的参数
//-(NSMutableArray<BrandModel> *)getBrandsInfo:(NSInteger) count{
//    NSMutableArray<BrandModel> * array = [[NSMutableArray<BrandModel>  alloc]init];
//    if (count == 0) {
//
//        NSInteger num = (1+count) * 5;
//        for (NSInteger j = count * 5; j<num; j++) {
//            [array addObject:self.brandlist[j]];
//        }
//    }else{
//
//        NSInteger num = (1+count) * 5;
//        for ( NSInteger j = count * 5; j<num-1; j++) {
//            [array addObject:self.brandlist[j]];
//        }
//        ///组成最后一个更多的控件
//        BrandModel *model = [[BrandModel alloc] init];
//        model.name =@"更多";
//        model.url = @"iconlocal";
//        model.id = @"";
//        [array addObject:model];
//    }
//
//    return array;
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.brands.count>0) {
//        switch (indexPath.section) {
//            case 0:
//            {
//                HotBrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotBrandCollectionViewCell" forIndexPath:indexPath];
//                if (indexPath.row==0) {
//                    [cell.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.left.right.equalTo(cell.contentView);
//                        make.top.equalTo(cell.contentView).with.offset(15);
//                    }];
//                }else{
//                    [cell.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.left.right.equalTo(cell.contentView);
//                        make.bottom.equalTo(cell.contentView).with.offset(-15);
//                    }];
//                }
//                @weakify(self);
//                [cell.view setCellWithArray:[self getBrandsInfo:indexPath.row] itemClickBlock:^(HotBrandItem *item, NSInteger index) {
//                    @strongify(self);
//                    CarSeriesViewController*vc = [[CarSeriesViewController alloc]init];
//                    index = indexPath.row*5+index;
//                    if(index == 9){
//                        //跳转到第二个tab
//                    TabBarViewController* tabBarController=[UIApplication sharedApplication].keyWindow.rootViewController;
//                        [tabBarController setSelectedIndex:1];
//                        return ;
//                    }
//                    BrandModel*model = self.brandlist[index];
//                    vc.brandModel = model;
//                    [URLNavigation pushViewController:vc animated:YES];
//                }];
//
//                return cell;
//            }
//                break;
//            case 1:{
//                PicShowModel *pic = self.piclist[indexPath.row];
//                UICollectionViewCell *cellView =  [self buildCollectionView:pic collectionView:collectionView cellForItemAtIndexPath:indexPath];
//                if ((indexPath.row==0&&indexPath.section==0)||(self.brands.count >0&&indexPath.section==1&&indexPath.row==0)) {
//                    [cellView setTopLineShow:NO];
//                }else{
//                    [cellView setTopLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//                }
//
//
//                return cellView;
//            }
//                break;
//            default:
//                break;
//        }
        
//    }else{
        if (self.isVideo) {
            VideoModel *video = self.videoList[indexPath.row];
            VideoBigCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(VideoBigCellCollectionViewCell) forIndexPath:indexPath];
            [cell setVideoModel:video];
            return cell;
            
        }else{
            //这边先随意设置一下
            if (self.isFristModel) {
                
                if (self.tagModel.userdata.count>0) {
                    switch (indexPath.section) {
                        case 0:
                        {
                            HomeGuideCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:classNameFromClass(HomeGuideCollectionViewCell) forIndexPath:indexPath];
                            [cell.collectionView reloadData];
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            self.tagsCell = [collectionView  dequeueReusableCellWithReuseIdentifier:classNameFromClass(HomeTagCollectionViewCell) forIndexPath:indexPath];
                            [self.tagsCell setXiHaoDataByForm:self.tagModel];
                            [self.tagsCell.collectionView reloadData];
                            return self.tagsCell;
                        }
                            break;
                        case 2:
                        {
                            PicShowModel *pic = self.piclist[indexPath.row];
                            UICollectionViewCell *cellView =  [self buildCollectionView:pic collectionView:collectionView cellForItemAtIndexPath:indexPath];
                            
                            if ((indexPath.row==0&&indexPath.section==0)||(self.brands.count >0&&indexPath.section==1&&indexPath.row==0)) {
                                [cellView setTopLineShow:NO];
                            }else{
                                [cellView setTopLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
                            }
                            return cellView;
                        }
                            break;
                        default:
                            break;
                    }
                }else{
                    switch (indexPath.section) {
                        case 0:
                        {
                            HomeGuideCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:classNameFromClass(HomeGuideCollectionViewCell) forIndexPath:indexPath];
                            [cell.collectionView reloadData];
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            PicShowModel *pic = self.piclist[indexPath.row];
                            UICollectionViewCell *cellView =  [self buildCollectionView:pic collectionView:collectionView cellForItemAtIndexPath:indexPath];
                            
                            if ((indexPath.row==0&&indexPath.section==0)||(self.brands.count >0&&indexPath.section==1&&indexPath.row==0)) {
                                [cellView setTopLineShow:NO];
                            }else{
                                [cellView setTopLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
                            }
                            return cellView;
                        }
                            break;
                        default:
                            break;
                    }
                }
                
            }else{
                PicShowModel *pic = self.piclist[indexPath.row];
                UICollectionViewCell *cellView =  [self buildCollectionView:pic collectionView:collectionView cellForItemAtIndexPath:indexPath];
                
                if ((indexPath.row==0&&indexPath.section==0)||(self.brands.count >0&&indexPath.section==1&&indexPath.row==0)) {
                    [cellView setTopLineShow:NO];
                }else{
                    [cellView setTopLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
                }
                return cellView;
            }
        }
//    }
    return nil;
}

//旧界面的cell 组成
-(UICollectionViewCell *)buildCollectionView:(PicShowModel *)pic collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = pic.showType;
    switch ([type intValue]) {
        case table:
        {
//            if ([pic.artType isEqualToString:zimeiti]||[self.fristmodel isNotEmpty])
            if ([pic.artType isEqualToString:zimeiti]) {
                PublicNormalCollectionViewCell *normalCollectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublicNormalCollectionViewCell" forIndexPath:indexPath];
                
                [normalCollectioncell setData:pic];
                return normalCollectioncell;
            }else{
                NormalCollectionViewCell *normalCollectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCollectionViewCell" forIndexPath:indexPath];
                [normalCollectioncell setData:pic];
                return normalCollectioncell;
            }
            break;}
        case bigimage:{
            TitleWithImageCollectionViewCell *bigimagecell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleWithImageCollectionViewCell" forIndexPath:indexPath];
            
            [bigimagecell.bigimage setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            bigimagecell.views.text = @"11";
            bigimagecell.time.text = @"11-12";
 
            return bigimagecell;
            
            break;
        }
        case threeimage:
        {
            NSArray *browse = [BrowseKouBeiArtModel findByColumn:@"id" value:pic.id];
            if ([browse count]) {
                pic.isRead = isread;
            }
//             if ([pic.artType isEqualToString:zimeiti] || [self.fristmodel isNotEmpty])
            if ([pic.artType isEqualToString:zimeiti]) {
                ZiMeiTiWithThreeImageCollectionViewCell *threeimagecell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZiMeiTiWithThreeImageCollectionViewCell" forIndexPath:indexPath];
                
                if(pic.imglist.count == 3){
                    [threeimagecell.imageleft setImageWithURL:[NSURL URLWithString:pic.imglist[0]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    [threeimagecell.imagemiddle setImageWithURL:[NSURL URLWithString:pic.imglist[1]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    [threeimagecell.imageright setImageWithURL:[NSURL URLWithString:pic.imglist[2]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    threeimagecell.imageleft.hidden = NO;
                    threeimagecell.imagemiddle.hidden =NO ;
                    threeimagecell.imageright.hidden =NO ;
                    
                }else if(pic.imglist.count == 2){
                    [threeimagecell.imageleft setImageWithURL:[NSURL URLWithString:pic.imglist[0]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    [threeimagecell.imagemiddle setImageWithURL:[NSURL URLWithString:pic.imglist[1]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
                    threeimagecell.imageleft.hidden = NO;
                    threeimagecell.imagemiddle.hidden =NO ;
                    threeimagecell.imageright.hidden =YES ;
                }else{
                    NSURL*url;
                    if(pic.imglist.count>=1){
                        url =[NSURL URLWithString:[pic.imglist firstObject]];
                    }
                    [threeimagecell.imageleft setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    threeimagecell.imageleft.hidden = NO;
                    threeimagecell.imagemiddle.hidden =YES ;
                    threeimagecell.imageright.hidden =YES ;
                    
                }
                
                
                
                if ([pic.isRead isEqualToString:isread]) {
                    threeimagecell.title.textColor = BlackColor999999;
                }else{
                    threeimagecell.title.textColor = BlackColor333333;
                }
                
                threeimagecell.title.text = pic.title;
                threeimagecell.views.text = pic.authorName;
                threeimagecell.time.text = [NSString stringWithFormat:@"%@人阅读",pic.click];
                
                return threeimagecell;
            }else{
            
            TitleWithThreeImageCollectionViewCell *threeimagecell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleWithThreeImageCollectionViewCell" forIndexPath:indexPath];
            
            if(pic.imglist.count == 3){
                [threeimagecell.imageleft setImageWithURL:[NSURL URLWithString:pic.imglist[0]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                [threeimagecell.imagemiddle setImageWithURL:[NSURL URLWithString:pic.imglist[1]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                [threeimagecell.imageright setImageWithURL:[NSURL URLWithString:pic.imglist[2]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                threeimagecell.imageleft.hidden = NO;
                threeimagecell.imagemiddle.hidden =NO ;
                threeimagecell.imageright.hidden =NO ;
                
            }else if(pic.imglist.count == 2){
                [threeimagecell.imageleft setImageWithURL:[NSURL URLWithString:pic.imglist[0]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                [threeimagecell.imagemiddle setImageWithURL:[NSURL URLWithString:pic.imglist[1]] placeholderImage:[UIImage imageNamed:@"默认图片80_60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                threeimagecell.imageleft.hidden = NO;
                threeimagecell.imagemiddle.hidden =NO ;
                threeimagecell.imageright.hidden =YES ;
            }else{
                [threeimagecell.imageleft setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"logo.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                threeimagecell.imageleft.hidden = NO;
                threeimagecell.imagemiddle.hidden =YES ;
                threeimagecell.imageright.hidden =YES ;
                
            }
            
        if ([pic.isRead isEqualToString:isread]) {
                    threeimagecell.title.textColor = BlackColor999999;
                }else{
                    threeimagecell.title.textColor = BlackColor333333;
                }
            
//            threeimagecell.title.text = pic.title;
//            threeimagecell.views.text = pic.click;
//            threeimagecell.time.text =pic.inputtime;
                
                threeimagecell.title.text = pic.title;
                threeimagecell.views.text = pic.authorName;
                threeimagecell.time.text =[pic.click stringByAppendingString:@"人阅读"];

            return threeimagecell;
            }
            break;}
        case title:{
            TitleCollectionViewCell *titlecell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleCollectionViewCell" forIndexPath:indexPath];
            titlecell.title.text = @"个性推荐";
            return titlecell;
            break;
        }
        
        default:
            return nil;
            break;
    }

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isVideo) {
        return  CGSizeMake(kwidth,295);
    }else{
        if (self.isFristModel) {
                
                if (self.tagModel.userdata.count>0) {
                    //这个 第一个是大banner图 第二个是品牌图
                    if (indexPath.section == 0) {
                        return  CGSizeMake(kwidth,100);
                    }else if (indexPath.section == 1){
                        return CGSizeMake(kwidth,67);
                    }else {
                        return [self sizeCollectionViewRow:indexPath];
                    }
                }else{
                    if (indexPath.section == 0) {
                        return  CGSizeMake(kwidth,100);
                    }
                        return [self sizeCollectionViewRow:indexPath];
                }
        }else{
            return [self sizeCollectionViewRow:indexPath];
        }
    }
}


///本人重构方法
-(CGSize)sizeforCollectioViewRow:(NSIndexPath *)indexPath{
    PicShowModel *pic = self.piclist[indexPath.row];
    NSString *type = pic.showType;
    switch ([type intValue]) {
        case title:
            return  CGSizeMake(kwidth,45);
            break;
        case table:
            return  CGSizeMake(kwidth,100);
            break;
        case bigimage:
            return  CGSizeMake(kwidth,271);
            break;
        case threeimage:
            return  CGSizeMake(kwidth,(kwidth-50)/3+50);
            break;
        default:
            break;
    }
    return  CGSizeMake(kwidth,90);
}

-(CGSize)sizeCollectionViewRow:(NSIndexPath *)indexPath{
    
    if (self.isFristModel) {
        if (indexPath.section == 0) {
            return  CGSizeMake(kwidth,90);
        }else{
           return [self sizeforCollectioViewRow:indexPath];
        }
        
    }else{
        return [self sizeforCollectioViewRow:indexPath];
    }
    return  CGSizeMake(kwidth,90);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (self.isVideo) {
        if (self.videoViewModel.labelinfo.info.count>0) {
            return CGSizeMake(kwidth, 100);
        }
    }
    
    if (self.isFristModel) {
        if(section == 0){
            if (self.bannerlist.count>0 ) {
                return  CGSizeMake(kwidth, kwidth*1.0/2);
            }
            return CGSizeZero;
        }else{
            if (self.brands.count>0) {
                return CGSizeMake(kwidth, lineHeight);
            }
            return CGSizeZero;
        }
    }
    return CGSizeZero;
 
}

//头部试图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        if (self.isVideo) {
            if (self.videoViewModel.labelinfo.info.count>0) {
                self.videoHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NewVideoCollectionViewController" forIndexPath:indexPath];
                self.videoHeaderView.datas = self.videoViewModel.labelinfo;
                [self.videoHeaderView.collectionView reloadData];
                return self.videoHeaderView;
            }
        }
        
        if (self.isFristModel && self.bannerlist.count>0 &&indexPath.section == 0) {
            if(self.headerView==nil){

                self.headerView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BannerCollectionReusableView" forIndexPath:indexPath];
                self.headerView.topScrollView.isShowPageControl = YES;
                self.headerView.topScrollView.isCircleScrolled= YES;
           
                self.headerView.topScrollView.delegate = self;
                self.headerView.topScrollView.dataSource = self;
                self.headerView.topScrollView.size =  CGSizeMake(kwidth, kwidth*1.0/2);
                [self.headerView.topScrollView registerClass:[HorizontalScrollViewCell class] forCellWithReuseIdentifier:@"HorizontalScrollViewCell"];
                }
                self.headerView.topScrollView.autoScroll = YES;
                [self.headerView.topScrollView reloadData];
                return self.headerView;
            
        }else{
            if (self.brands.count>0) {
                ViewLineCollectionCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ViewLineCollectionCollectionReusableView" forIndexPath:indexPath];
                [view setViewColor:BlackColorE3E3E3];
                return view;
            }
        }
    }
    return nil;
}
//banner的数字
//banner 里面只有一个图片去除小圆点
-(NSInteger)HorizontalScrollViewnumberOfItems:(HorizontalScrollView *)horizontalScrollView{
    if (horizontalScrollView == self.headerView.topScrollView) {
        return  self.bannerlist.count;
    }
    return 0;
}


-(UICollectionViewCell*)HorizontalScrollView:(HorizontalScrollView *)horizontalScrollView cellForItemAtIndexPath:(NSIndexPath*)indexPath forRealIndex:(NSInteger)index{
    if (horizontalScrollView == self.headerView.topScrollView) {
        
        HorizontalScrollViewCell*cell =(HorizontalScrollViewCell*) [horizontalScrollView dequeueReusableCellWithReuseIdentifier:@"HorizontalScrollViewCell" forIndexPath:indexPath];
         CGRect rc = [horizontalScrollView convertRect:horizontalScrollView.frame toView:[UIApplication sharedApplication].keyWindow];
        NSLog(@"%f_____%f",rc.origin.x,rc.origin.y);
        BannerModel *bannermodel = self.bannerlist[index];
        [cell.imageView setImageWithURL:[NSURL URLWithString:bannermodel.thumb] placeholderImage:[UIImage imageNamed:@"默认图片330_165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    
//        cell.title.text = bannermodel.title;
        
        if (horizontalScrollView == self.headerView.topScrollView) {
            
            [cell.title mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.imageView.mas_left).offset(15);
                make.bottom.equalTo(cell.imageView.mas_bottom).offset(-10);
            }];
        }
        
        
        
        return cell;
    }
    return nil;
}

-(void)HorizontalScrollView:(nullable HorizontalScrollView *)horizontalScrollView didSelectItemAtIndexPath:(NSInteger )index{
     BannerModel *banner = self.bannerlist[index];
    
//    if ([pic.artType isEqualToString:zimeiti]) {
//        SubjectDetailViewController *controller = [[SubjectDetailViewController alloc] init];
//        controller.aid = pic.id;
//        controller.listInfo = pic;
//        [URLNavigation pushViewController:controller animated:YES];
//    }else{
   
      


     if (banner.type ==BannerModelJumpTypeUrlWithCity){
        ActiveViewController*vc = [[ActiveViewController alloc]init];
        vc.urlString = banner.adurl;
         vc.titleString = banner.title;
         vc.cityShow = YES;
         [URLNavigation pushViewController:vc animated:YES];
     }else if (banner.type ==BannerModelJumpTypeUrlWithOutCity){
         ActiveViewController*vc = [[ActiveViewController alloc]init];
         vc.urlString = banner.adurl;
         vc.cityShow = NO;
          vc.titleString = banner.title;

         [URLNavigation pushViewController:vc animated:YES];
     }else{
         ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
         controller.aid = banner.id;
         controller.artType = wenzhang;
         [URLNavigation pushViewController:controller animated:YES];
     }

}

 

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.isVideo) {
        VideoViewController *controller = [[VideoViewController alloc] init];
        controller.baseModel = self.videoList[indexPath.row];
        
        [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
        
        return ;
    }
    
    PicShowModel *pic = self.piclist[indexPath.row];
    ArtInfoViewController *controller = [[ArtInfoViewController alloc] init];
    
    controller.artType = pic.artType;
    controller.aid = pic.id;
  
    [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
    
    if ([pic.isRead isEqualToString:notread]) {
        pic.isRead = isread;
        NSArray<NSIndexPath *> *indexPaths = [[NSArray alloc] initWithObjects:indexPath,nil];        
        [self reloadItemsAtIndexPaths:indexPaths];
    }



}
//首页加载更多 下拉刷新也是加载更多
-(void)loadPullMore{
    self.pageid++;
    if (!self.newmoremodel) {
        NSLog(@"打开过的次数 loadPullMore");
        self.newmoremodel = [HomeMoreViewModel SceneModel];
        @weakify(self);
        [[RACObserve(self.newmoremodel, data)
          filter:^BOOL(id value) {
              @strongify(self);
              return self.newmoremodel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
              @strongify(self);
              if (self.isheadfresh) {
                  //头部刷新
                  if(self.newmoremodel.data.list.count ==0){
                      [self.mj_footer setState:MJRefreshStateNoMoreData];
                      
                  }else{
                      [self.piclist removeAllObjects];
                      [self.piclist addObjectsFromArray:[self.deliverModel deliverPicModel:self.newmoremodel.data.list]];
                      
                      //只有推荐的加载才是走这个方法
                      //方法一
                      //                  [UIView performWithoutAnimation:^{
                      //去除bannerlist的数据，就可以直接把banner拿掉
//                      [self.bannerlist removeAllObjects];
//                      self.headerView.topScrollView.autoScroll = NO;
                      if(self.block && self.pageid >1){
                          self.block(self.newmoremodel.data.list.count);
                      }
                      [self.headerView.topScrollView reloadData];
                      [self reloadData];
                      //                 }];
                      
                         [self.mj_header endRefreshing];
                  }
              }else{
              
                    if(self.newmoremodel.data.list.count ==0){
                    [self.mj_footer setState:MJRefreshStateNoMoreData];
                  
                    }else{
                  
                    [self.piclist addObjectsFromArray: [self.deliverModel deliverPicModel:self.newmoremodel.data.list]];
                    [self reloadData];
                                    //只有推荐的加载才是走这个方法
                                    //方法一
                                }
                   [self.mj_footer endRefreshing];
              }
              
  
              
              
          }];
        [[RACObserve(self.newmoremodel.request, state)
          filter:^BOOL(id value) {
              @strongify(self);
              return self.newmoremodel.request.failed;
          }]subscribeNext:^(id x) {
              @strongify(self);
              self.pageid--;
              //只有推荐的加载才是走这个方法
              [self.mj_header endRefreshing];
              [self.mj_footer endRefreshing];
              //方法一
          }];
        
    }
    self.newmoremodel.request.tags = self.fristmodel.request.tags;
    self.newmoremodel.request.keywords = self.fristmodel.request.keywords;
    self.newmoremodel.request.uid = self.fristmodel.request.uid;
    self.newmoremodel.request.page = self.pageid;
    self.newmoremodel.request.startRequest = YES;
    
}


//首页加载更多
//-(void)loadMore{
//    self.pageid++;
//     @weakify(self);
//    if (!self.moremodel) {
//        self.moremodel = [HomeMoreViewModel SceneModel];
//
//        [[RACObserve(self.moremodel, data)
//          filter:^BOOL(id value) {
//              @strongify(self);
//              return self.moremodel.data.isNotEmpty;
//          }]subscribeNext:^(id x) {
//              @strongify(self);
//              [self.mj_footer endRefreshing];
//              if(self.moremodel.data.list.count ==0){
//                  [self.mj_footer setState:MJRefreshStateNoMoreData];
//
//              }else{
//
//                [self.piclist addObjectsFromArray: [self.deliverModel deliverPicModel:self.moremodel.data.list]];
//                  [self reloadData];
//                  //只有推荐的加载才是走这个方法
//                  //方法一
//
//
//              }
//
//
//          }];
//        [[RACObserve(self.moremodel.request, state)
//          filter:^BOOL(id value) {
//              @strongify(self);
//              return self.moremodel.request.failed;
//          }]subscribeNext:^(id x) {
//              @strongify(self);
//              self.pageid--;
//              //只有推荐的加载才是走这个方法
//              [self.mj_footer endRefreshing];
//              //方法一
//
//
//          }];
//
//    }
//    self.moremodel.request.tags = self.fristmodel.request.tags;
//    self.moremodel.request.keywords = self.fristmodel.request.keywords;
//    self.moremodel.request.uid = self.fristmodel.request.uid;
//    self.moremodel.request.page = self.pageid;
//    self.moremodel.request.startRequest = YES;
//
//}
//除了推荐其余都是走这个列表
-(void)loadOtherMore{
    self.pageid++;
     @weakify(self);
    if (!self.secondmoremodel) {
       
        self.secondmoremodel  = [HomeSecondMoreViewModel SceneModel];
        [[RACObserve(self.secondmoremodel, self.data)
          filter:^BOOL(id value) {
              @strongify(self);
              return self.secondmoremodel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
               @strongify(self);
              [self.mj_footer endRefreshing];
              if(self.secondmoremodel.data.list.count ==0){
                  [self.mj_footer setState:MJRefreshStateNoMoreData];
                  
                  
              }else{
                  
                  
                  [self.piclist addObjectsFromArray: [self.deliverModel deliverPicModel:self.secondmoremodel.data.list]];
                  //只有推荐的加载才是走这个方法
                  //方法一
                  [self reloadData];
                  
              }

            
              
              
          }];
        [[RACObserve(self.secondmoremodel.request, state)
          filter:^BOOL(id value) {
              @strongify(self);
              return self.secondmoremodel.request.failed;
          }]subscribeNext:^(id x) {
              @strongify(self);
              self.pageid--;
              //只有推荐的加载才是走这个方法
              [self.mj_footer endRefreshing];
              //方法一
              
              
          }];


    }
  
    self.secondmoremodel.request.cateid = self.catid;
    self.secondmoremodel.request.page = self.pageid;
    self.secondmoremodel.request.startRequest = YES;
    
  }


////设置上线
//-(void)setTopline:(UIView *)cell{
//    if(cell.tag != 1){
//        UIView *view = [[UIView alloc] init];
//        [cell addSubview:view];
//        cell.tag = 1;
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.right.equalTo(cell);
//                make.left.equalTo(cell.mas_left).offset(15);
//                make.height.mas_equalTo(1);
//            }];
//        view.backgroundColor= seperateLineColor;
//        
//    }
//}
-(void)setSearchBarShow:(BOOL)searchBarShow{
    if (_searchBarShow!=searchBarShow) {
        _searchBarShow = searchBarShow;
        if (searchBarShow&&self.contentOffset.y <=1) {
            self.contentOffset = CGPointMake(0, -44);
            
        }else if (searchBarShow==NO&&self.contentOffset.y<44){
            self.contentOffset = CGPointMake(0, 1);
        }
    }
   
}


-(void)viewWillAppear{
    self.headerView.topScrollView.autoScroll = YES;
}
-(void)viewWilldisAppear{
    self.headerView.topScrollView.autoScroll = NO;
    [self.mj_header endRefreshing];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //只有首页需要展示隐藏
//     if (!self.fristmodel) {
//         return ;
//     }
    
    
    static float lastContentOffSetY = 0;
    static BOOL lastScrollToTop = NO ;
    
    if (!self.scorllViewdelegate||![self.scorllViewdelegate respondsToSelector:@selector(searchBarShow:)]) {
        return;
    }
    
    if (scrollView.contentOffset.y<=0) {
        
        [self.scorllViewdelegate searchBarShow:YES];
        return;
    }

    ///向上滚动
    BOOL scrollToTop;
    
    
    
    if (lastContentOffSetY-scrollView.contentOffset.y > 0) {
        scrollToTop = NO;
    }else{
        scrollToTop = YES;
    }
    lastContentOffSetY = scrollView.contentOffset.y;
    if (lastScrollToTop!=scrollToTop) {
        lastScrollToTop = scrollToTop;
        self.defaultScrollViewY = scrollView.contentOffset.y;
    }
    if (self.defaultScrollViewY - scrollView.contentOffset.y >44||self.defaultScrollViewY - scrollView.contentOffset.y < -44) {
        ///隐藏
        if (scrollToTop) {
           
            [self.scorllViewdelegate searchBarShow:NO];
        }
        
        ///显示
        if (scrollToTop==NO) {
            if (self.mj_footer.state==MJRefreshStateIdle) {
               
                [self.scorllViewdelegate searchBarShow:YES];
            }
           
        }
        
    }
}

-(void)dealloc{
    
}

#pragma 懒加载

//首页请求
-(HomeViewModel *)fristmodel{
    if (!_fristmodel) {
        _fristmodel = [HomeViewModel SceneModel];
        
        //首页数据
        @weakify(self);
        [[RACObserve(_fristmodel, data)
          filter:^BOOL(id value) {
              return _fristmodel.data.isNotEmpty;
          }]subscribeNext:^(id x) {
              self.piclist = [self.deliverModel deliverPicModel:_fristmodel.data.list];
              //                    if (!self.brands) {
              //                      self.brands = [NSMutableArray<Brand> array];
              //                  }else{
              //                      [self.brands removeAllObjects];
              //                  }
              //                  [self.brands addObjectsFromArray: self.fristmodel.data.brand];
              //                  if(self.brands.count>0){
              //                      [self exChangeBrands];
              //                  }
              [self.bannerlist removeAllObjects];
              
              [self.bannerlist addObjectsFromArray: _fristmodel.data.picShow];
              //上拉加载
              NSLog(@"%@",self.mj_footer);
              if (self.mj_footer==nil) {
                  self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                      @strongify(self);
                      self.isheadfresh = false;
                      [self loadPullMore];
//                      [self loadMore];
                  }];
//                  ((MJRefreshAutoNormalFooter*) self.mj_footer).triggerAutomaticallyRefreshPercent = -20;
              }
              
              [self reloadData];
          }];
        
        //喜好请求
        [[RACObserve(_fristmodel,tagdata)filter:^BOOL(id value) {
            return _fristmodel.tagdata.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                self.tagModel = _fristmodel.tagdata;
                NSArray *arry = [[XiHaoClickObject getnames]  componentsSeparatedByString:@","];;
                __block NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
                __block NSMutableArray *ids = [NSMutableArray arrayWithCapacity:1];
                [self.tagModel.data enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arry enumerateObjectsUsingBlock:^(NSString *nsobj, NSUInteger idx, BOOL * stop) {
                        if ([nsobj isEqualToString:obj.name]) {
                            [temp addObject:obj];
                            [ids addObject:obj.id];
                            [obj save];
                            *stop = YES;
                        }
                    }];
                }];
                
                [self.tagModel.userdata addObjectsFromArray:temp];
                self.fristmodel.request.tags = [self pictureArrayToJSON:temp];
                self.fristmodel.request.startRequest = YES;
            }
        }];
    }
    return _fristmodel;
}

#pragma mOdelNarry to json
- (NSString *)pictureArrayToJSON:(NSArray *)picArr {
    
    if (picArr && picArr.count > 0) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        
        for (TagsModel *model in picArr) {
            NSData *jsonData = [self getJSON:model options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [arr addObject:jsonText];
        }
        return  [self objArrayToJSON:arr];
    }
    
    return nil;
}
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

-(NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

-(id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
-(NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}
#pragma 懒加载

-(NSMutableArray<VideoModel> *)videoList{
    if (!_videoList) {
        _videoList = [NSMutableArray arrayWithCapacity:1];
    }
    return _videoList;
}

-(VideoViewModel *)videoViewModel
{
    if (!_videoViewModel) {
        _videoViewModel = [VideoViewModel SceneModel];
        _videoViewModel.listRequest.page = 1;
        [[RACObserve(_videoViewModel,info)
          filter:^BOOL(id value) {
              return _videoViewModel.info.isNotEmpty;
          }]subscribeNext:^(id x) {
              [self.mj_header endRefreshing];
              if (_videoViewModel.listRequest.page == 1) {
                  _videoViewModel.labelRequest.startRequest = YES;
                  [self.videoList removeAllObjects];
                  [self.videoList addObjectsFromArray:_videoViewModel.info.list];
                 
                  
                  if (_videoViewModel.info.list.count ==10) {
                      self.mj_footer.state = MJRefreshStateIdle;
                      if (self.mj_footer==nil) {
                          self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                              [self.mj_footer beginRefreshing];
                              _videoViewModel.listRequest.page++;
                              _videoViewModel.listRequest.startRequest = YES;
                          }
                                            ];
                      }
                  }else{
                      //无数据活着是显示数据为空
                  }
              }else{
                  [self.mj_footer endRefreshing];

                  if (_videoViewModel.info.list.count<10) {
                      self.mj_footer.state = MJRefreshStateNoMoreData;
                      ((MJRefreshAutoNormalFooter*)self.mj_footer).stateLabel.text = @"";
                  }else{
                      [self.videoList addObjectsFromArray:_videoViewModel.info.list];
                  }
         
              }
              [self reloadData];
          }];
        
        
        [[RACObserve(_videoViewModel, labelinfo)filter:^BOOL(id value) {
            return _videoViewModel.labelinfo.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                [self reloadData];
            }
        }];
        
        _videoViewModel.labelRequest.startRequest = YES;
        
    }
    return _videoViewModel;
}

-(XiHaoUserViewModel *)userViewModel{
    if (!_userViewModel) {
        _userViewModel = [XiHaoUserViewModel SceneModel];
        
        [[RACObserve(_userViewModel, data)filter:^BOOL(id value) {
            return _userViewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                [self.tagModel.userdata removeAllObjects];
                [self.tagModel.userdata  addObjectsFromArray:_userViewModel.data.searchtags];
                [self.tagModel.userdata  addObjectsFromArray:_userViewModel.data.checkedtags];
                
                self.fristmodel.request.uid = [UserModel shareInstance].uid;
                self.fristmodel.request.startRequest = YES;
                
            }
        }];
        
    }
    return _userViewModel;
}

-(TagsListModel *)tagModel{
    if (!_tagModel) {
        _tagModel = [[TagsListModel alloc] init];
    }
    return _tagModel;
}

-(void)reloadCurrentData{
    if ([[UserModel shareInstance].uid isNotEmpty]) {
        self.userViewModel.request.uid = [UserModel shareInstance].uid;
        self.userViewModel.request.startRequest = YES;
        
        self.fristmodel.request.uid = [UserModel shareInstance].uid;
        self.fristmodel.request.startRequest = YES;
    }else{
        self.fristmodel.tagrequest.startRequest = YES;
    }
}

@end
