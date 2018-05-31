//
//  PhotoDetailViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//
//
// 思路是将图片页中已经获取的分页数据通过传参的方式传过来
// 目的是使得刚进页面的时候，图片数据不会长时间等待
// 其次，在点击过程中请求全部图片的url 通过reloaddata的方式，将其余数据加载到界面上
// 时间：17/3/2
//
//
//
//
//
//

#import "PhotoDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhotoRect.h"

#import "AskForPriceNewViewController.h"



static NSString *_cellIdentifier = @"collectionViewCell";

@interface PhotoDetailViewController ()<UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>

// 控件
@property (weak,nonatomic) UILabel          *pageLabel;
@property (weak,nonatomic) UIPageControl    *pageControl;
//@property (weak,nonatomic) UIButton         *deleleBtn;
@property (weak,nonatomic) UIButton         *backBtn;

@property(weak,nonatomic) UIButton *askPriceBtn;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) HTHorizontalSelectionList *selectionList;

@property(weak,nonatomic)UILabel *labelTitle;

@property(weak,nonatomic) UIImageView *downloadImage;
@property(weak,nonatomic) UIView *lineView;

@property (weak,nonatomic) UIScrollView *userScrollView;

// 上一次屏幕旋转的位置
@property (assign,nonatomic) UIDeviceOrientation lastDeviceOrientation;
@property (nonatomic , copy)NSString*currentCategoryId;
@property (nonatomic , strong)NSMutableDictionary* modelDict;
@property (nonatomic , strong)NSMutableDictionary* viewModelDict;

// 数据相关
// 单击时执行销毁的block
@property (nonatomic , copy) ZLPickerBrowserViewControllerTapDisMissBlock disMissBlock;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;
// 当前是否在旋转
@property (assign,nonatomic) BOOL isNowRotation;
// 是否是Push模式
@property (assign,nonatomic) BOOL isPush;

//当前页面的所有数据
@property(nonatomic,strong)NSMutableDictionary* allPagesDict;

@end

@implementation PhotoDetailViewController

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
        collectionView.backgroundColor = BlackColor1B1B1B;
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-ZLPickerColletionViewPadding)} views:@{@"_collectionView":_collectionView}]];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(260);
            make.centerY.equalTo(self.view);
        }];
        

        collectionView.pagingEnabled =YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotationDirection:) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.lastDeviceOrientation = [[UIDevice currentDevice] orientation];
        
        self.pageLabel.hidden = NO;
//        self.deleleBtn.hidden = !self.isEditing;
        self.downloadImage.hidden =NO;
        self.lineView.hidden = NO;
        self.backBtn.hidden = NO;
        self.labelTitle.hidden = NO;
        self.askPriceBtn.hidden = NO;
        
        [self setUpToolBar];
    }
    return _collectionView;
}

#pragma mark labelTitle
-(UILabel *)labelTitle{
    if(!_labelTitle){
        UILabel *labelTitle = [[UILabel alloc] init];
        labelTitle.font = FontOfSize(18);
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.userInteractionEnabled = NO;
        labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:labelTitle];
        
        self.labelTitle = labelTitle;
        self.labelTitle.text = self.carName;
        
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(15);
            make.left.equalTo(self.view).offset(15);
        }];

    }
    return _labelTitle;
}

#pragma mark deleleBtn
//- (UIButton *)deleleBtn{
//    if (!_deleleBtn) {
//        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
//        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [deleleBtn setImage:[UIImage ml_imageFromBundleNamed:@"nav_delete_btn"] forState:UIControlStateNormal];
//        
//        // 设置阴影
//        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
//        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
//        deleleBtn.layer.shadowRadius = 3;
//        deleleBtn.layer.shadowOpacity = 1.0;
//        deleleBtn.hidden = YES;
//        
//        [deleleBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_deleleBtn = deleleBtn];
//        
//        NSString *widthVfl = @"H:[deleleBtn(deleteBtnWH)]-margin-|";
//        NSString *heightVfl = @"V:|-margin-[deleleBtn(deleteBtnWH)]";
//        NSDictionary *metrics = @{@"deleteBtnWH":@(50),@"margin":@(10)};
//        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
//        
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
//        
//    }
//    return _deleleBtn;
//}

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
            make.top.equalTo(self.view).offset(30);
        }];
        
    }
    return _pageLabel;
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
            make.top.equalTo(self.view).offset(30);
        }];
        
    }
    return _backBtn;
}
#pragma 寻低价
-(UIButton *)askPriceBtn{
    if (!_askPriceBtn) {
        UIButton *askPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        askPrice.translatesAutoresizingMaskIntoConstraints = NO;
        askPrice.titleLabel.font = FontOfSize(15);
        [askPrice setTitle:@"询底价" forState:UIControlStateNormal];
        [askPrice setTitle:@"询底价" forState:UIControlStateSelected];
        askPrice.titleLabel.textColor =[UIColor whiteColor];
        self.askPriceBtn = askPrice;
        [self.view addSubview:askPrice];
        
        [askPrice addTarget:self action:@selector(askPricefunction) forControlEvents:UIControlEventTouchUpInside];
        [self.askPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.top.equalTo(self.view.mas_top).offset(30);
        }];
        
    }
    return _askPriceBtn;
}
#pragma mark 下载
-(UIImageView*)downloadImage{
    if (!_downloadImage) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self.view addSubview:image];
        
        self.downloadImage = image;
        UITapGestureRecognizer *Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [self.downloadImage addGestureRecognizer:Gesture];
        [self.downloadImage setUserInteractionEnabled: YES];
        
        [self.downloadImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
        
        self.downloadImage.image = [UIImage imageNamed:@"ic_download"];
        
    }
    return _downloadImage;
}
#pragma mark 设置一下线
-(UIView *)lineView{
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        [self.view addSubview:view];
        self.lineView = view;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.view).offset(-50);
        }];
        view.backgroundColor= [UIColor whiteColor];
        view.alpha=0.1;
        
        UIView *secondView = [[UIView alloc] init];
        [self.view addSubview:secondView];
        [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.height.mas_equalTo(1);
            make.top.equalTo(self.pageControl.mas_bottom).offset(40);
        }];
        secondView.backgroundColor= [UIColor whiteColor];
        secondView.alpha=0.1;
    }
    return _lineView;
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
    self.selectionList.selectionIndicatorColor = [UIColor whiteColor];
    self.selectionList.dataSource = self;
    self.selectionList.backgroundColor=[UIColor blackColor];
    self.selectionList.maxShowCount = 5;
    
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.mas_top).offset(-20);
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
    [self setSelectionPageLabelPage:0 :index];
}


//初始化列表
-(void)initPhotos:(NSArray<PicModel> *)pic{
    //更换原始数据
    NSMutableArray *temp_photo = [[NSMutableArray alloc]init];
    //如果枚举对象是空 就会崩
    if (![pic isKindOfClass:[NSNull class]]) {
    for (PicModel *model in pic) {
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        if([model.bigpic isNotEmpty])
        photo.photoURL = [NSURL URLWithString:model.bigpic];
        else
             photo.photoURL = [NSURL URLWithString:model.bigpic_source];
        [temp_photo addObject:photo];
    }
    
    self.photos = temp_photo;
    //重新置换列表
    [self getPhotos];
    }
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
        }];
    }
    return _pageControl;
}

#pragma mark getPhotos
- (NSArray *)getPhotos{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_photos.count];
    
    for (ZLPhotoPickerBrowserPhoto *photo in _photos) {
        photo.toView = [[photo toView] copy];
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
    
    if ([self.photos[self.currentIndex] asset] == nil) {
        thumbImage = [self.photos[self.currentIndex] thumbImage];
    }else{
        thumbImage = [self.photos[self.currentIndex] photoImage];
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
    
    self.navigationController.navigationBar.hidden = YES;
    self.toolBarList = [self getToolBarList];
    [self setTitle:@"图片"];
    self.view.backgroundColor = [UIColor blackColor];
    self.modelDict =[NSMutableDictionary dictionary];
    self.viewModelDict =[NSMutableDictionary dictionary];
    self.allPagesDict = [NSMutableDictionary dictionary];
    
    //当实际的列表数据小于惦记的按钮数据的时候
    //我们切换的列表状态就系要根据点击名称来获取
    PicMenuModel *menu;
    if (self.toolBarList.count<self.labelCurrentNumber) {
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
    [self.allPagesDict setObject:self.photos forKey:menu.category_id];
    
    [self setupfirstData:menu];
}

//初始化进入时的数据
-(void)setupfirstData:(PicMenuModel*)menu{
    
    @weakify(self);
    PhotoViewModel*model = [PhotoViewModel SceneModel];
    model.request.typeId = self.typeId;
    model.request.carId = self.carId;
    model.request.color = self.colorId;
    model.request.categoryId = menu.category_id;
    model.request.limit = [menu.num intValue];
    model.request.page = 1;
    model.request.startRequest =YES;
    [self.viewModelDict setObject:model forKey:menu.category_id];
    [[RACObserve(model.request, state)
      filter:^BOOL(id value) {
          
          return model.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          NSError*error;
          PhotoFatherModel*dataModel = [[PhotoFatherModel alloc]initWithDictionary:model.request.output[@"data"] error:&error];
          
          if (error) {
              NSLog(@"%@", error.description);
          }
          
          //这边的1是默认数值
          [self.viewModelDict setObject:@"1" forKey:menu.category_id];
          [self initPhotos:dataModel.list];
          [self.modelDict setObject:self.photos forKey:menu.category_id ];
      }];
}
//加载数据
-(void)setupPhoto{
     NSArray<ZLPhotoPickerBrowserPhoto *> *model= [self.modelDict objectForKey:self
                                                   .catgoryId];
    
    NSArray<NSObject *> *temp = [self.allPagesDict objectForKey:self.catgoryId];
    
    
    if(temp.count == model.count){
   
    }else{
        [self.allPagesDict setObject:model forKey:self.catgoryId];
        self.photos = model;
        //重新置换列表
        [self getPhotos];
        [self.collectionView reloadData];
    }
    
}


//请求数据
-(void)callPhotoList:(PicMenuModel *)menu{
    //请求所有数据
    //存在这个key
    if ([self.viewModelDict objectForKey:menu.category_id]) {
        self.catgoryId = menu.category_id;
        NSArray<ZLPhotoPickerBrowserPhoto *> *model= [self.modelDict objectForKey:menu.category_id];
        if (model.count == 0) {
            
        }else{

            
            self.photos = model;
            //重新置换列表
            [self getPhotos];
            [self reloadData];
        }

    }else{
        //先从上面页面上拿数据
        NSArray<PicModel> *pic = [self.forestalllDict objectForKey:menu.category_id];
        [self initPhotos:pic];
        [self reloadData];
        
        [self.allPagesDict setObject:[self getPhotos] forKey:menu.category_id];
        
        [self setupfirstData:menu];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupReload];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
    [self.selectionList setSelectedButtonIndex:self.labelCurrentNumber];
    //[self selectionList:self.selectionList didSelectButtonWithIndex:self.labelCurrentNumber];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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
    
    [self setPageLabelPage:self.currentIndex];
    if (self.currentPage >= 0) {
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.zl_width , self.collectionView.contentOffset.y);
        [self.userScrollView setContentOffset:self.collectionView.frame.origin animated:NO];
    }
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
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:scrollBoxView];
        
        
        ZLPhotoPickerBrowserPhotoScrollView *scrollView =  [[ZLPhotoPickerBrowserPhotoScrollView alloc] init];
        scrollView.sheet = self.sheet;
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

//设置总图片数字
-(void)setPageLabelPage:(NSInteger)page{
    PicMenuModel *model= self.toolBarList[self.labelCurrentNumber];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %@",page + 1,model.num];
    if (self.isPush) {
        self.title = self.pageLabel.text;
    }
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x+scrollView.frame.size.width/2) / (scrollView.frame.size.width));
    if (currentPage == self.photos.count - 2) {
        currentPage = roundf((scrollView.contentOffset.x+scrollView.frame.size.width/2) / (scrollView.frame.size.width));
    }
    
//    self.currentPage = currentPage;
     self.currentPage =  self.currentPage;
    [self setPageLabelPage:currentPage];
    
//    if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
//        [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
//    }
    
    NSArray<PicModel> *array = [self.allPagesDict objectForKey:self.catgoryId];
 
    if(currentPage==(array.count-1)&&[self.viewModelDict objectForKey:self.catgoryId])
    {
        self.currentIndex = array.count-1;
        [self setupPhoto];
    }
}

#pragma mark - 展示控制器
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
        [weakVc presentViewController:self animated:NO completion:nil];
    }
}

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

///保存图片
-(void)event:(UITapGestureRecognizer *)gesture{
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


//返回功能
-(void)back{
//    if (self.disMissBlock) {
//        if (self.photos.count == 1) {
//            self.currentPage = 0;
//        }
//        self.disMissBlock(self.currentPage);
//    }else{

        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.rt_navigationController popViewControllerAnimated:YES];
    //    }
}

//寻找低价
//1是有经销商 0是无经销商
-(void)askPricefunction{
    if ([self.has_dealer isEqualToString:@"0"]) {
        [DialogUtil showDlgAlert:@"没有可用经销商"];
    }else{
        AskForPriceNewViewController *vc = [[AskForPriceNewViewController alloc] init];
        if([self.typeId isNotEmpty]){
            vc.carSerieasId = self.typeId;
        }else{
            vc.carSerieasId = self.typeId;
            vc.carTypeId = self.carId;
        }
     ZLPhotoPickerBrowserPhoto*model =   self.photos[self.currentPage];
        vc.imageUrl = model.photoURL.absoluteString;
        [URLNavigation  pushViewController:vc animated:YES];
    }
}

#pragma mark - <PickerPhotoScrollViewDelegate>
- (void)pickerPhotoScrollViewDidSingleClick:(ZLPhotoPickerBrowserPhotoScrollView *)photoScrollView{
    //    if (self.disMissBlock) {
    //
    //        if (self.photos.count == 1) {
    //            self.currentPage = 0;
    //        }
    //        self.disMissBlock(self.currentPage);
    //    }else{
    //        [[NSNotificationCenter defaultCenter] removeObserver:self];
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }
}

- (void)showHeadPortrait:(UIImageView *)toImageView{
    
}

- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl{
    
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
