//
//  KouBeiPicsTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/4/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "KouBeiPicsTableViewHeaderFooterView.h"
#import "ZLPhotoPickerBrowserViewController.h"

@interface KouBeiPicsTableViewHeaderFooterView()

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray<KouBeiDetailPicModel> *pics;

///存放图片的数组
@property(nonatomic,strong)NSMutableArray *photos;

@end


@implementation KouBeiPicsTableViewHeaderFooterView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        [self bindXib:self.collectionView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

-(void)bindXib:(UICollectionView *)collectionView{
    
    [collectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self jump2photo:indexPath.row];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KouBeiDetailPicModel *model = self.pics[indexPath.row];
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    [cell.image setImageWithURL:[NSURL URLWithString:model.original_small_img] placeholderImage:[UIImage imageNamed:@"默认图片105_80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return self.pics.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.pics.count>0) {
        return 1;
    }
    return 0;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kwidth-30-20)/3, 80);
    
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}

//初始化列表
-(void)initPhotos{
    if(self.pics.count>0){
        self.photos = [[NSMutableArray alloc]init];
        for (KouBeiDetailPicModel *model in self.pics) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:model.bigPic];
            [self.photos addObject:photo];
        }
    }
}

//跳转图片
-(void)jump2photo:(NSInteger) count{
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    //    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos;
    // 当前选中的值
    pickerBrowser.currentIndex = count;
    // 展示控制器
    // 加入这个方法，可以使得条转方法变快
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       //跳转界面
                       [pickerBrowser showPickerVc:[Tool currentViewController]];
                   });
}


-(void)setData:(NSArray<KouBeiDetailPicModel> *)pics{
    self.pics = pics;
    [self initPhotos];
    [self.collectionView reloadData];
}

@end
