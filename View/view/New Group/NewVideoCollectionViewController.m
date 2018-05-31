//
//  NewVideoCollectionViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NewVideoCollectionViewController.h"
#import "NewVideoCollectionViewCell.h"
#import "VideoViewListViewController.h"

@implementation NewVideoCollectionViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView setCollectionViewLayout:layout];
    
    [self.collectionView registerNib:nibFromClass(NewVideoCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(NewVideoCollectionViewCell)];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.datas.info.count>0) {
        return 1;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.info.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kwidth/3, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(NewVideoCollectionViewCell) forIndexPath:indexPath];
    
    VideoLabelModel *model = self.datas.info[indexPath.row];
    
    [cell.imageview setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"默认图片330_165"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.title.text = model.label_name;
    cell.des.text = model.describe;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewListViewController *controller = [[VideoViewListViewController alloc] init];
    
    VideoLabelModel *model = self.datas.info[indexPath.row];
    controller.catid = model.id;
    controller.titlename = model.label_name;
    [[Tool currentViewController].rt_navigationController pushViewController:controller animated:YES];
}

@end
