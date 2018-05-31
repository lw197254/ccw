//
//  PhotoMoreViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/3/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoMoreViewController.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhotoRect.h"

#import "AskForPriceNewViewController.h"

#import "MyOwnShareView.h"

static NSString *_cellIdentifier = @"collectionViewCell";

@interface PhotoMoreViewController ()<UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

// 控件
@property (weak,nonatomic) UILabel          *pageLabel;
@property (weak,nonatomic) UIPageControl    *pageControl;
@property (weak,nonatomic) UIButton         *deleleBtn;
@property (weak,nonatomic) UIButton         *backBtn;
@property (weak,nonatomic) UICollectionView *collectionView;

@property (weak,nonatomic) UIScrollView *userScrollView;

// 上一次屏幕旋转的位置
@property (assign,nonatomic) UIDeviceOrientation lastDeviceOrientation;
// 数据相关
// 单击时执行销毁的block
@property (nonatomic , copy) ZLPickerBrowserViewControllerTapDisMissBlock disMissBlock;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;
// 当前是否在旋转
@property (assign,nonatomic) BOOL isNowRotation;
// 是否是Push模式
@property (assign,nonatomic) BOOL isPush;


////自己添加的内容
///分享的图片
@property(strong,nonatomic)UIImageView *shareImageView;
///下载的图片
@property(strong,nonatomic)UIImageView *downImageView;
///请求询价
@property(weak,nonatomic) UIButton *askPriceBtn;
///carname
@property(strong,nonatomic)UILabel *carLabel;
///线
@property(strong,nonatomic)UILabel *lineLabel;

@property (strong,nonatomic) HTHorizontalSelectionList *selectionList;

@property (nonatomic , copy)NSString*currentCategoryId;
@property (nonatomic , strong)NSMutableDictionary* modelDict;
@property (nonatomic , strong)NSMutableDictionary* viewModelDict;
//当前页面的所有数据
//@property(nonatomic,strong)NSMutableDictionary* allPagesDict;
@property(nonatomic,strong) MyOwnShareView *shareView;
@end

@implementation PhotoMoreViewController

-(MyOwnShareView *)shareView{
    if(!_shareView){
        _shareView = [[MyOwnShareView alloc] init];
    }
    return _shareView;
}

#pragma mark - getter
#pragma mark photos
- (NSArray *)photos{
    if (!_photos) {
        _photos = [self getPhotos];
    }
    return _photos;
}

#pragma mark collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + ZLPickerColletionViewPadding, [UIScreen mainScreen].bounds.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-ZLPickerColletionViewPadding)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotationDirection:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.lastDeviceOrientation = [[UIDevice currentDevice] orientation];
        
        self.pageLabel.hidden = NO;
        
        self.shareImageView.hidden = NO;
        self.downImageView.hidden = NO;
        [self.view bringSubviewToFront:self.backBtn];
        self.backBtn.hidden = NO;
        //self.deleleBtn.hidden = !self.isEditing;
        
        [self setUpToolBar];
        
        if ([self.carPrice isEqualToString:@"暂无报价"]) {
            self.askPriceBtn.hidden = YES;
        }else{
            self.askPriceBtn.hidden = NO;
        }

        self.carLabel.hidden = NO;
//        self.lineLabel.hidden =NO;
    }
    return _collectionView;
}

#pragma lineLabel

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        [_lineLabel setBackgroundColor:BlackColorE3E3E3];
        
        self.lineLabel = _lineLabel;
        [self.view addSubview:_lineLabel];
        
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.pageControl.mas_bottom).offset(17);
            make.height.mas_equalTo(0.6);
        }];
        

    }
    return _lineLabel;
}


#pragma carname
-(UILabel *)carLabel{
    if (!_carLabel) {
        _carLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _carLabel.textColor = [UIColor whiteColor];
        _carLabel.font= FontOfSize(15);
        [self.view addSubview:_carLabel];
        self.carLabel = _carLabel;
        
        [self.carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.askPriceBtn.mas_top).offset(-20);
            make.height.mas_equalTo(30);
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
        }];
        
        NSString *info = [NSString stringWithFormat:@"%@ %@",self
                          .carType,self.carName];
        self.carLabel.text = info;
        self.carLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _carLabel;
}

#pragma make downImageView
-(UIImageView *)downImageView{
    if(!_downImageView){
        _downImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icdownload"]];
        [self.view addSubview:_downImageView];
        
        self.downImageView = _downImageView;
        UITapGestureRecognizer *Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadClick:)];
        [self.downImageView addGestureRecognizer:Gesture];
        [self.downImageView setUserInteractionEnabled: YES];
        
        [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareImageView.mas_left).offset(-15);
            make.top.equalTo(self.shareImageView.mas_top);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];

    }
    return _downImageView;
}

#pragma make shareImageView
-(UIImageView *)shareImageView{
    if(!_shareImageView){
        _shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareWhite"]];
        [self.view addSubview:_shareImageView];
        
        self.shareImageView = _shareImageView;
        UITapGestureRecognizer *Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonClicked:)];
        [self.shareImageView addGestureRecognizer:Gesture];
        [self.shareImageView setUserInteractionEnabled: YES];
        
        [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(self.view.mas_top).offset(10+StatusHeight);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
        
    }
    return _shareImageView;
}

#pragma mark backBtn 返回键
-(UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.translatesAutoresizingMaskIntoConstraints = NO;
        backBtn.titleLabel.font = FontOfSize(15);
        [backBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
        self.backBtn = backBtn;
        [self.view addSubview:backBtn];
        
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.width.mas_equalTo(self.pageControl.mas_height);
            make.height.mas_equalTo(self.pageControl.mas_height);
            make.top.equalTo(self.view.mas_top).offset(10+StatusHeight);
        }];
        
    }
    return _backBtn;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn{
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleleBtn.titleLabel.font = FontOfSize(15);
        [deleleBtn setImage:[UIImage ml_imageFromBundleNamed:@"nav_delete_btn"] forState:UIControlStateNormal];
        
        // 设置阴影
        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
        deleleBtn.layer.shadowRadius = 3;
        deleleBtn.layer.shadowOpacity = 1.0;
        deleleBtn.hidden = YES;
        
//        [deleleBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleleBtn = deleleBtn];
        
        NSString *widthVfl = @"H:[deleleBtn(deleteBtnWH)]-margin-|";
        NSString *heightVfl = @"V:|-margin-[deleleBtn(deleteBtnWH)]";
        NSDictionary *metrics = @{@"deleteBtnWH":@(50),@"margin":@(10)};
        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _deleleBtn;
}

#pragma mark pageLabel
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = FontOfSize(18);
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(10+StatusHeight);
        }];
    }
    return _pageLabel;
}

#pragma mark pageControl
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
        
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(10+StatusHeight);
        }];
    }
    return _pageControl;
}

#pragma mark getPhotos
- (NSArray *)getPhotos{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_photos.count];
    
    for (ZLPhotoPickerBrowserPhoto *photo in _photos) {
        photo.toView = [[photo toView] copy];
        photo.picName = [[photo picName] copy];
        photo.price = [[photo price] copy];
        [photos addObject:photo];
    }
    return photos;
}

#pragma mark - Life cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isPush) {
        
    }else{
        if (self.currentPage >= 0) {
            self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width , self.collectionView.contentOffset.y);
        }
    }
}

- (void)showToView{
    _photos = [_photos copy];
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    UIView *mainBgView = [[UIView alloc] init];
    mainBgView.alpha = 0.0;
    mainBgView.backgroundColor = [UIColor blackColor];
    mainBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mainBgView.frame = [UIScreen mainScreen].bounds;
    [mainView addSubview:mainBgView];
    
    __block UIImageView *toImageView = nil;
    if (self.currentIndex < self.photos.count) {
        toImageView = (UIImageView *)[self.photos[self.currentIndex] toView];
    }
    
    if (![toImageView isKindOfClass:[UIImageView class]] && self.status != UIViewAnimationAnimationStatusFade) {
        self.status = UIViewAnimationAnimationStatusFade;
    }
    
    __block UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [mainBgView addSubview:imageView];
    mainView.clipsToBounds = YES;
    
    UIImage *thumbImage = nil;
    
    if (self.currentIndex <self.photos.count) {
       
        if ([self.photos[self.currentIndex] asset] == nil) {
            thumbImage = [self.photos[self.currentIndex] thumbImage];
        }else{
            thumbImage = [self.photos[self.currentIndex] photoImage];
        }
    }
   
   
    
    if (thumbImage == nil) {
        thumbImage = toImageView.image;
    }
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.image = thumbImage;
    }else{
        if (thumbImage == nil) {
            imageView.image = toImageView.image;
        }else{
            imageView.image = thumbImage;
        }
    }
    
    
    if (self.status == UIViewAnimationAnimationStatusFade){
        imageView.alpha = 0.0;
        imageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:imageView.image];
    }else if(self.status == UIViewAnimationAnimationStatusZoom){
        CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
        if (self.navigationHeight) {
            tempF.origin.y += self.navigationHeight;
        }
        //        if (self.userScrollView && self.userScrollView.contentOffset.y >= 0) {
        //            tempF.origin.y -= self.userScrollView.contentOffset.y + 64;
        //        }
        
        imageView.frame = tempF;
    }
    
    
    __block CGRect tempFrame = imageView.frame;
    __weak typeof(self)weakSelf = self;
    self.disMissBlock = ^(NSInteger page){
        mainView.hidden = NO;
        mainView.alpha = 1.0;
        CGRect originalFrame = CGRectZero;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        // 缩放动画
        if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
            UIImage *thumbImage = nil;
            
            if ([weakSelf.photos[page] asset] == nil) {
                thumbImage = [weakSelf.photos[page] thumbImage];
            }else{
                thumbImage = [weakSelf.photos[page] photoImage];
            }
            
            ZLPhotoPickerBrowserPhoto *photo = weakSelf.photos[page];
            if (thumbImage == nil) {
                imageView.image = [(UIImageView *)[photo toView] image];
                thumbImage = imageView.image;
            }else{
                imageView.image = thumbImage;
            }
            
            if (imageView.image == nil) {
                UICollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndex]];
                ZLPhotoPickerBrowserPhotoScrollView *scrollView = (ZLPhotoPickerBrowserPhotoScrollView *)[cell viewWithTag:101];
                if ([scrollView isKindOfClass:[ZLPhotoPickerBrowserPhotoScrollView class]] && scrollView != nil) {
                    imageView.image = scrollView.photoImageView.image;
                }
            }
            
            CGRect ivFrame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImage:thumbImage];
            if (!CGRectEqualToRect(ivFrame, CGRectZero)) {
                imageView.frame = ivFrame;
            }
            UIImageView *toImageView2 = (UIImageView *)[weakSelf.photos[page] toView];
            
            UIView *toView = [weakSelf getParsentView:toImageView2];
            originalFrame = [toImageView2.superview convertRect:toImageView2.frame toView:toView];
            
            if (CGRectIsEmpty(originalFrame)) {
                originalFrame = tempFrame;
            }
            
        }else{
            // 淡入淡出
            ZLPhotoPickerBrowserPhoto *photo = weakSelf.photos[page];
            if (photo.photoImage) {
                imageView.image = photo.photoImage;
            }else if (photo.thumbImage) {
                imageView.image = photo.thumbImage;
            }
            
            imageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:imageView];
            imageView.alpha = 1.0;
            [imageView superview].alpha = 1.0;
            weakSelf.view.hidden = YES;
        }
        
        if (weakSelf.navigationHeight) {
            originalFrame.origin.y += weakSelf.navigationHeight;
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                mainBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                
                imageView.alpha = 0.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                weakSelf.collectionView.hidden = YES;
                mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                mainBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                imageView.frame = originalFrame;
            }
        } completion:^(BOOL finished) {
            weakSelf.view.hidden = NO;
            imageView.alpha = 1.0;
            [mainView removeFromSuperview];
            [mainBgView removeFromSuperview];
            
            [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }];
    };
    
    [weakSelf reloadData];
    if (imageView.image == nil) {
        weakSelf.status = UIViewAnimationAnimationStatusFade;
        
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.35 animations:^{
            // 淡入淡出
            mainView.alpha = 0.0;
        } completion:^(BOOL finished) {
            mainView.alpha = 1.0;
            mainView.hidden = YES;
        }];
        
    }else{
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.35 animations:^{
            if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                // 淡入淡出
                mainBgView.alpha = 1.0;
                imageView.alpha = 1.0;
            }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                mainBgView.alpha = 1.0;
                imageView.alpha = 1.0;
                imageView.frame = [ZLPhotoRect setMaxMinZoomScalesForCurrentBoundWithImageView:imageView];
            }
        } completion:^(BOOL finished) {
            mainView.hidden = YES;
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backBtn.hidden = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.toolBarList = [self getToolBarList];
    self.view.backgroundColor = [UIColor blackColor];
    self.modelDict =[NSMutableDictionary dictionary];
    self.viewModelDict =[NSMutableDictionary dictionary];
//    self.allPagesDict = [NSMutableDictionary dictionary];
    
    //当实际的列表数据小于惦记的按钮数据的时候
    //我们切换的列表状态就系要根据点击名称来获取
    PicMenuModel *menu;
    if (self.toolBarList.count<=self.labelCurrentNumber) {
        // 切换当前的labelcurrentlabel
        int i =0;
        for (PicMenuModel *model in self.toolBarList) {
            if([self.labelCurrentName isEqualToString:model.category_name]){
                menu = model;
                self.labelCurrentNumber = i;
                [self.modelDict setObject:_photos forKey:menu.category_id];
                break;
            }
            i++;
        }
    }else{
        menu = self.toolBarList[self.labelCurrentNumber];
        [self.modelDict setObject:_photos forKey:menu.category_id];
    }
    //当前数据
//    [self.allPagesDict setObject:self.photos forKey:menu.category_id];
    
    [self setupData:menu];
//    [self setSelectionPageLabelPage:self.currentPage :self.labelCurrentNumber];
}



//加次点击进来的数据第一波数据进入时的数据
-(void)setupData:(PicMenuModel*)menu{
    
   
    
    @weakify(self);
    PhotoViewModel*model = [PhotoViewModel SceneModel];
    model.request.typeId = self.typeId;
    model.request.carId = self.carId;
    model.request.color = self.colorId;
    model.request.categoryId = menu.category_id;
    model.request.limit = [menu.num intValue];
    model.request.page = 1;
    model.request.startRequest =YES;
    [LoadingView shareInstance].isHalfClearColor = YES;
    
   
    [[LoadingView shareInstance]show];
    [[LoadingView shareInstance] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(64);
        make.left.right.bottom.equalTo(self.view);
        //            make.edges.equalTo(VC.view);
    }];

    
    
    [self.viewModelDict setObject:model forKey:menu.category_id];
    [[RACObserve(model.request, state)
      filter:^BOOL(id value) {
          
          return model.request.succeed||model.request.failed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          [[LoadingView shareInstance]dismiss];
          if (model.request.succeed) {
              NSError*error;
              PhotoFatherModel*dataModel = [[PhotoFatherModel alloc]initWithDictionary:model.request.output[@"data"] error:&error];
              
              if (error) {
                  NSLog(@"%@", error.description);
              }
              
              [self initPhotos:dataModel.list];
              
              [self addPhotosToDic:dataModel.list id:menu.category_id];
              //这边的1是默认数值
              [self.viewModelDict setObject:@"1" forKey:menu.category_id];
              
              [self setupReload];
              
             // [self.selectionList setSelectedButtonIndex:self.currentIndex];

          }
    }];
}





- (void)setupReload{
    if (self.isPush) {
        [self reloadData];
        __weak typeof(self)weakSelf = self;
        __block BOOL navigationisHidden = NO;
        self.disMissBlock = ^(NSInteger page){
//            if (navigationisHidden) {
//                [UIView animateWithDuration:.25 animations:^{
//                    weakSelf.navigationController.navigationBar.alpha = 1.0;
//                }];
//            }else{
//                [UIView animateWithDuration:.25 animations:^{
//                    weakSelf.navigationController.navigationBar.alpha = 0.0;
//                }];
//            }
//            navigationisHidden = !navigationisHidden;
        };
    }else{
        // 初始化动画
        if (self.photos.count){
            [self showToView];
        }
    }
}

#pragma mark get Controller.view
- (UIView *)getParsentView:(UIView *)view{
    if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
        self.userScrollView = (UIScrollView *)view;
    }
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

- (id)getParsentViewController:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return [view nextResponder];
    }
    return [self getParsentViewController:view.superview];
}


#pragma mark - reloadData
- (void)reloadData{
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndex;
    }else{
        --self.currentPage;
    }
    
    if (self.currentPage >= self.photos.count) {
        self.currentPage = self.photos.count - 1;
    }
    
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    
    // 添加自定义View
    if ([self.delegate respondsToSelector:@selector(photoBrowserShowToolBarViewWithphotoBrowser:)]) {
        UIView *toolBarView = [self.delegate photoBrowserShowToolBarViewWithphotoBrowser:self];
        toolBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat width = self.view.zl_width;
        CGFloat x = self.view.zl_x;
        if (toolBarView.zl_width) {
            width = toolBarView.zl_width;
        }
        if (toolBarView.zl_x) {
            x = toolBarView.zl_x;
        }
        toolBarView.frame = CGRectMake(x, self.view.zl_height - 44, width, 44);
        [self.view addSubview:toolBarView];
    }
    
    [self setPageLabelPage:self.currentPage];
    if (self.currentPage >= 0) {
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width , self.collectionView.contentOffset.y);
    }
    
     [self.selectionList setSelectedButtonIndex:self.labelCurrentNumber];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (collectionView.isDragging) {
        cell.hidden = NO;
    }
    if (self.photos.count) {
        //        cell.backgroundColor = [UIColor clearColor];
        
        ZLPhotoPickerBrowserPhoto *photo = self.photos[indexPath.item];
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        CGRect tempF = [UIScreen mainScreen].bounds;
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = tempF;
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:scrollBoxView];
        
        ZLPhotoPickerBrowserPhotoScrollView *scrollView =  [[ZLPhotoPickerBrowserPhotoScrollView alloc] init];
        scrollView.hideblock = ^(bool ishide){
            [self isHideView:ishide];
        };
        //scrollView.sheet = self.sheet;
        // 为了监听单击photoView事件
        scrollView.frame = tempF;
        scrollView.tag = 101;
        if (self.isPush) {
            scrollView.zl_y -= 32;
        }
        scrollView.photoScrollViewDelegate = self;
        scrollView.photo = photo;
        __weak typeof(scrollBoxView)weakScrollBoxView = scrollBoxView;
        __weak typeof(self)weakSelf = self;
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndex:)]) {
            [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            scrollView.callback = ^(id obj){
                [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndex:indexPath.row];
            };
        }
        
        [scrollBoxView addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return cell;
}

- (NSUInteger)getRealPhotosCount{
    return self.photos.count;
}

-(void)setPageLabelPage:(NSInteger)page{
    PicMenuModel *menu =  self.toolBarList[self.labelCurrentNumber];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %@",page + 1,menu.num];
    if (self.isPush) {
        self.title = self.pageLabel.text;
    }
}

- (void)setPageControlPage:(long)page {
    self.pageControl.numberOfPages = self.photos.count;
    self.pageControl.currentPage = page;
    if (self.pageControl.numberOfPages > 1) {
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
    
}

#pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x+(scrollView.frame.size.width)/2) / (scrollView.frame.size.width));
    if (currentPage == self.photos.count - 2) {
        currentPage = roundf(((scrollView.contentOffset.x)+(scrollView.frame.size.width)/2) / (scrollView.frame.size.width));
    }
    
    
    if (self.currentPage != currentPage) {
        self.currentPage = currentPage;
        [self setPageLabelPage:currentPage];
        if (self.photos.count >currentPage) {
            ZLPhotoPickerBrowserPhoto *model = self.photos[currentPage];
            self.carLabel.text = model.picName;
            
            if ([model.price isEqualToString:@"暂无报价"]) {
                self.askPriceBtn.hidden = YES;
            }else{
                self.askPriceBtn.hidden = NO;
                NSString *price;
                NSRange symbol=[self.carPrice rangeOfString:@"万"];
                if (symbol.location != NSNotFound) {
                    price = [NSString stringWithFormat:@"%@ 询底价",self
                             .carPrice];
                }else{
                    price = [NSString stringWithFormat:@"%@万 询底价",self
                             .carPrice];
                }
                
                [self.askPriceBtn setTitle:price forState:UIControlStateNormal];
            }
            
        }
       

        
        if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
            [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
        }

    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 }

#pragma mark - 展示控制器
///这个是present的方法
- (void)showPickerVc:(UIViewController *)vc{
    // 当没有数据的情况下
    if (self.photos.count == 0 || self.photos.count <= self.currentIndex) {
        NSLog(@"ZLPhotoLib提示: 您没有传photos数组");
        return;
    }
    
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        if (([vc isKindOfClass:[UITableViewController class]] || [vc isKindOfClass:[UICollectionView class]]) && weakVc.rt_navigationController != nil && self.navigationHeight == 0) {
            self.navigationHeight = CGRectGetMaxY(weakVc.navigationController.navigationBar.frame);
        }
        CustomNavigationController*nav = self.rt_navigationController;
    
        if (!nav) {
            nav = [[CustomNavigationController alloc]initWithRootViewController:self];
        }
    
        [weakVc presentViewController:nav animated:NO completion:nil];
    }
}

///这个是push的方法
- (void)showPushPickerVc:(UIViewController *)vc{
    self.isPush = YES;
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        if (([vc isKindOfClass:[UITableViewController class]] || [vc isKindOfClass:[UICollectionView class]]) && weakVc.rt_navigationController != nil && self.navigationHeight == 0) {
            self.navigationHeight = CGRectGetMaxY(weakVc.navigationController.navigationBar.frame);
        }
        [weakVc.rt_navigationController pushViewController:self animated:YES];
    }
}

#pragma mark - 删除照片
- (void)delete{
    // 准备删除
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willRemovePhotoAtIndex:)]) {
        if(![self.delegate photoBrowser:self willRemovePhotoAtIndex:self.currentPage]){
            return ;
        }
    }
    
    UIAlertView *removeAlert = [[UIAlertView alloc]
                                initWithTitle:@"确定要删除此图片？"
                                message:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:@"确定", nil];
    [removeAlert show];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger page = self.currentPage;
        NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
        if ([self.delegate respondsToSelector:@selector(photoBrowser:removePhotoAtIndex:)]) {
            [self.delegate photoBrowser:self removePhotoAtIndex:page];
        }
        
        if (self.photos.count > self.currentPage) {
            [photos removeObjectAtIndex:self.currentPage];
            self.photos = photos;
        }
        
        if (page >= self.photos.count) {
            self.currentPage--;
        }
        
        self.status = UIViewAnimationAnimationStatusFade;
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
        
        if (cell) {
            if([[[cell.contentView subviews] lastObject] isKindOfClass:[UIView class]]){
                
                [UIView animateWithDuration:0.35 animations:^{
                    [[[cell.contentView subviews] lastObject] setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [self reloadData];
                }];
            }
        }
        
        if (self.photos.count < 1)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            if (self.isPush) {
                [self.rt_navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
    }
}

#pragma mark - Rotation
- (void)changeRotationDirection:(NSNotification *)noti{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.collectionView collectionViewLayout];
    [layout invalidateLayout];
    
    UIDevice *obj = (UIDevice *)noti.object;
    if ([obj isKindOfClass:[UIDevice class]] && (UIDeviceOrientation)[obj orientation] == self.lastDeviceOrientation) {
        self.lastDeviceOrientation = (UIDeviceOrientation)[obj orientation];
        return ;
    }
    
    if (CGSizeEqualToSize(CGSizeMake([UIScreen mainScreen].bounds.size.width + ZLPickerColletionViewPadding, [UIScreen mainScreen].bounds.size.height), [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout itemSize])) {
        return ;
    }
    
    self.lastDeviceOrientation = (UIDeviceOrientation)[obj orientation];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.zl_size.width + ZLPickerColletionViewPadding, self.view.zl_height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.alpha = 0.0;
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    
    self.isNowRotation = YES;
    
    self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width, self.collectionView.contentOffset.y);
    
    UICollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0]];
    for (UICollectionViewCell *cell in [self.collectionView subviews]) {
        if ([cell isKindOfClass:[UICollectionViewCell class]]) {
            cell.hidden = ![cell isEqual:currentCell];
            ZLPhotoPickerBrowserPhotoScrollView *scrollView = (ZLPhotoPickerBrowserPhotoScrollView *)[cell.contentView viewWithTag:101];
            [scrollView setMaxMinZoomScalesForCurrentBounds];
        }
    }
    
    [UIView animateWithDuration:.5 animations:^{
        self.collectionView.alpha = 1.0;
    }];
}

#pragma mark - <PickerPhotoScrollViewDelegate>
- (void)pickerPhotoScrollViewDidSingleClick:(ZLPhotoPickerBrowserPhotoScrollView *)photoScrollView{
    if (self.disMissBlock) {
        
        if (self.photos.count == 1) {
            self.currentPage = 0;
        }
        self.disMissBlock(self.currentPage);
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showHeadPortrait:(UIImageView *)toImageView{
    
}

- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl{
    
}

#pragma 自己的方法
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.selectionList setSelectedButtonIndex:self.labelCurrentNumber];
    //[self selectionList:self.selectionList didSelectButtonWithIndex:self.labelCurrentNumber];
}

- (void)viewWillDisappear:(BOOL)animated{
    //[super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


///保存图片
-(void)downloadClick:(UITapGestureRecognizer *)gesture{
    if (!self.sheet) {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
    }
    [self.sheet showInView:self.view];
}

///保存图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(long)buttonIndex{
    ZLPhotoPickerBrowserPhoto *photo = self.photos[_currentPage];
    if (buttonIndex == 0){
        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
            
            [assetsLibrary writeImageToSavedPhotosAlbum:[photo.photoImage CGImage] orientation:(ALAssetOrientation)photo.photoImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error) {
                    NSLog(@"Save image fail：%@",error);
                }else{
                    [self showMessageWithText:@"保存成功"];
                }
            }];
        }else{
            if (photo.photoImage) {
                [self showMessageWithText:@"没有用户权限,保存失败"];
            }
        }
    }
}

-(void)showMessageWithText:(NSString *)text{
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.font = FontOfSize(15);
    alertLabel.text = text;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.bounds = CGRectMake(0, 0, 100, 80);
    alertLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    alertLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0];
    alertLabel.layer.cornerRadius = 10.0f;
    //    [[UIApplication sharedApplication].keyWindow addSubview:alertLabel];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:alertLabel];
    
    [UIView animateWithDuration:3 animations:^{
        alertLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [alertLabel removeFromSuperview];
    }];
}

#pragma 寻低价
-(UIButton *)askPriceBtn{
    if (!_askPriceBtn) {
        UIButton *askPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        askPrice.translatesAutoresizingMaskIntoConstraints = NO;
        askPrice.titleLabel.font = FontOfSize(15);
        
        
        NSString *price;
        NSRange symbol=[self.carPrice rangeOfString:@"万"];
        if (symbol.location != NSNotFound) {
            price = [NSString stringWithFormat:@"%@ 询底价",self
                               .carPrice];
        }else{
            price = [NSString stringWithFormat:@"%@万 询底价",self
                               .carPrice];
        }
        

        [askPrice setTitle:price forState:UIControlStateNormal];
        
        [askPrice setTitleColor:BlackColorB2B2B2  forState:UIControlStateNormal];
        [askPrice setTitle:price forState:UIControlStateSelected];
        [askPrice setTitleColor:BlackColorB2B2B2 forState:UIControlStateSelected];
        
        [askPrice setBackgroundColor:[UIColor blackColor]];
        askPrice.alpha = 0.6;
        
        [askPrice.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [askPrice.layer setCornerRadius:2];
        [askPrice.layer setBorderWidth:1];//设置边界的宽度
        [askPrice.layer setBorderColor:BlackColor555555.CGColor];
        
        
        // 设置内容距离边框
        CGFloat contentPadding = 10;
        askPrice.contentEdgeInsets =UIEdgeInsetsMake(contentPadding, contentPadding, contentPadding, contentPadding);

        
        self.askPriceBtn = askPrice;
        [self.view addSubview:askPrice];
        
        [askPrice addTarget:self action:@selector(askPricefunction) forControlEvents:UIControlEventTouchUpInside];
        [self.askPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            make.bottom.equalTo(self.selectionList.mas_top).offset(-40);
            make.centerX.equalTo(self.view);
        }];
        
        
    }
    return _askPriceBtn;
}


#pragma mark barlist
-(NSArray *)getToolBarList{
    NSMutableArray *barList = [NSMutableArray arrayWithCapacity:_toolBarList.count];
    [barList addObjectsFromArray:_toolBarList];
    return barList;
}


#pragma mark 导航按钮
-(void)setUpToolBar{
    
    self.selectionList = [[HTHorizontalSelectionList alloc]init];
    [self.selectionList setSelectionIndicatorStyle:HTHorizontalSelectionIndicatorStyleNone];
    [self.selectionList setBottomTrimColor:[UIColor blackColor]];
    [self.view addSubview:self.selectionList];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.selectionList.delegate = self;
    
    [self.selectionList setTitleColor:BlackColor999999 forState:UIControlStateNormal];
    self.selectionList.selectionIndicatorColor = BlueColor447FF5;
    self.selectionList.dataSource = self;
    self.selectionList.backgroundColor=BlackColor131313;
    self.selectionList.maxShowCount = 5;
    
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-SafeAreaBottom);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(40);
    }];
    
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    PicMenuModel *model =self.toolBarList[index];
    return model.category_name;
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.toolBarList.count;
}

//选中之后切换界面
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    //回到初始页面
    self.labelCurrentNumber = index;
    self.currentIndex = 0;
    PicMenuModel *menu = self.toolBarList[index];
    [self callPhotoList:menu];
//    [self setSelectionPageLabelPage:0 :index];
}

//设置总图片数字
-(void)setSelectionPageLabelPage:(NSInteger)page :(NSInteger) count{
    PicMenuModel *model= self.toolBarList[count];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %@",page + 1,model.num];
    if (self.isPush) {
        self.title = self.pageLabel.text;
    }
    
    self.collectionView.contentOffset = CGPointMake(0* self.collectionView.zl_width , self.collectionView.contentOffset.y);
    [self.userScrollView setContentOffset:self.collectionView.frame.origin animated:NO];
}

//请求数据
-(void)callPhotoList:(PicMenuModel *)menu{
    //请求所有数据
    //存在这个key
    if ([self.viewModelDict objectForKey:menu.category_id]) {
        self.catgoryId = menu.category_id;
        NSArray<ZLPhotoPickerBrowserPhoto *> *model= [self.modelDict objectForKey:menu.category_id];
        //数据从服务器没有拿到返回时
        if (model.count == 0) {
//            NSArray<PicModel> *pic = [self.forestalllDict objectForKey:menu.category_id];
//            [self initPhotos:pic];
//            [self reloadData];
        }else{
            self.photos = model;
            //重新置换列表
            [self getPhotos];
            [self reloadData];
            [self setSelectionPageLabelPage:0 :self.labelCurrentNumber];
        }
        
    }else{
        //先从上面页面上拿数据
//        NSArray<PicModel> *pic = [self.forestalllDict objectForKey:menu.category_id];
//        [self initPhotos:pic];
//        [self reloadData];
        
//        [self.allPagesDict setObject:[self getPhotos] forKey:menu.category_id];
        [self setupfirstData:menu];
    }
}



//初始化进入时的数据
-(void)setupfirstData:(PicMenuModel*)menu{
    
    PicMenuModel *currentModel = self.toolBarList[self.labelCurrentNumber];
    
    @weakify(self);
    PhotoViewModel*model = [PhotoViewModel SceneModel];
    model.request.typeId = self.typeId;
    model.request.carId = self.carId;
    model.request.color = self.colorId;
    model.request.categoryId = menu.category_id;
    model.request.limit = [menu.num intValue];
    model.request.page = 1;
    model.request.startRequest =YES;
    
    [LoadingView shareInstance].isHalfClearColor = YES;
    
    
    [[LoadingView shareInstance]show];
    [[LoadingView shareInstance] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(64);
        make.left.right.bottom.equalTo(self.view);
        //            make.edges.equalTo(VC.view);
    }];

    
    [self.viewModelDict setObject:model forKey:menu.category_id];
    [[RACObserve(model.request, state)
      filter:^BOOL(id value) {
          
          return model.request.succeed;
      }]subscribeNext:^(id x) {
          [[LoadingView shareInstance]dismiss];
          @strongify(self);
          
          NSError*error;
          PhotoFatherModel*dataModel = [[PhotoFatherModel alloc]initWithDictionary:model.request.output[@"data"] error:&error];
          
          if (error) {
              NSLog(@"%@", error.description);
          }
          

          if([currentModel.category_id isEqualToString:menu.category_id]){
              [self initPhotos:dataModel.list];
          }
          
          [self addPhotosToDic:dataModel.list id:menu.category_id];
          //这边的1是默认数值
          [self.viewModelDict setObject:@"1" forKey:menu.category_id];
          [self reloadData];
          [self setSelectionPageLabelPage:0 :self.labelCurrentNumber];
          
      }];
}

//初始化列表
-(void)initPhotos:(NSArray<PicModel> *)pic{
    //更换原始数据
    NSMutableArray *temp_photo = [[NSMutableArray alloc]init];
    //如果枚举对象是空 就会崩
    if (![pic isKindOfClass:[NSNull class]]) {
        for (PicModel *model in pic) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            NSString *info = [NSString stringWithFormat:@"%@ %@",self.carType,model.car_name];
            photo.picName = info;
            photo.price = model.price;
            if([model.highpic isNotEmpty])
                photo.photoURL = [NSURL URLWithString:model.highpic];
            else
                photo.photoURL = [NSURL URLWithString:model.bigpic_source];
            [temp_photo addObject:photo];
        }
        
        self.photos = temp_photo;
        //重新置换列表
        [self getPhotos];
    }
}

///添加数据到字典里面
-(void)addPhotosToDic:(NSArray<PicModel> *)pic id:(NSString *)id{
    //更换原始数据
    NSMutableArray *temp_photo = [[NSMutableArray alloc]init];
    //如果枚举对象是空 就会崩
    if (![pic isKindOfClass:[NSNull class]]) {
        for (PicModel *model in pic) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            NSString *info = [NSString stringWithFormat:@"%@ %@",self.carType,model.car_name];
            photo.picName =  info;
            if([model.bigpic isNotEmpty])
                photo.photoURL = [NSURL URLWithString:model.bigpic];
            else
                photo.photoURL = [NSURL URLWithString:model.bigpic_source];
            [temp_photo addObject:photo];
        }
        //重新置换列表
        [self.modelDict setObject:temp_photo forKey:id ];
    }
}





//返回功能
-(void)back{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.rt_navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//寻找低价
//1是有经销商 0是无经销商
-(void)askPricefunction{
//    if ([self.has_dealer isEqualToString:@"0"]) {
//        [DialogUtil showDlgAlert:@"没有可用经销商"];
//    }else{
    
        [ClueIdObject setClueId:xunjia_10];
        
        AskForPriceNewViewController *vc = [[AskForPriceNewViewController alloc] init];
        if([self.typeId isNotEmpty]){
            vc.carSerieasId = self.typeId;
        }else{
            vc.carSerieasId = self.typeId;
            vc.carTypeId = self.carId;
        }
        if(self.currentPage >= self.photos.count){
            self.currentPage = 0;
        }
        ZLPhotoPickerBrowserPhoto*model =  self.photos[self.currentPage];
        vc.imageUrl = model.photoURL.absoluteString;
        [URLNavigation  pushViewController:vc animated:YES];
//    }
}

///设置是否显示
-(void)isHideView:(bool) ishide{
    
        self.askPriceBtn.hidden = ishide;
    
        self.backBtn.hidden = ishide;
        self.downImageView.hidden = ishide;
        self.shareImageView.hidden = ishide;
        self.pageLabel.hidden = ishide;
        
        self.pageControl.hidden = ishide;
        self.carLabel.hidden = ishide;
        self.selectionList.hidden = ishide;
//        self.lineLabel.hidden =ishide;
}


///分享
-(void)shareButtonClicked:(UIButton*)button{
    NSString *title = @"车城网分享";
    title = [title stringByAppendingString:self.carName];
    ZLPhotoPickerBrowserPhoto *model = self.photos[self.currentPage];
    NSString *picture = [model.photoURL absoluteString];

    
    self.shareView.title = title;
    self.shareView.content = @"";
    self.shareView.share_url = @"";
    self.shareView.pic_url = picture;
    
    [self.shareView setMyownshareType:SharePic];
    [self.shareView initPopView];
    
}



@end
