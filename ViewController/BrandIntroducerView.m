//
//  BrandIntroducerView.m
//  chechengwang
//
//  Created by 严琪 on 2017/9/20.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "BrandIntroducerView.h"
#import "BrandIntroduceCollectionViewCell.h"
#import "CarFooderCollectionViewCell.h"
#import "CarHeaderCollectionViewCell.h"
#import "CarDeptViewController.h"

@implementation BrandIntroducerView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:frame                                                                    collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerNib:[UINib nibWithNibName:@"CarHeaderCollectionViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CarHeaderCollectionViewCell"];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"BrandIntroduceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BrandIntroduceCollectionViewCell"];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"CarFooderCollectionViewCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CarFooderCollectionViewCell"];
        
        [self addSubview:self.collectionView];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        @weakify(self);
        [RACObserve(self,seeothers)
         subscribeNext:^(NSString* x){
             @strongify(self);
             [self.collectionView reloadData];
         }];
        
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.seeothers.count>3){
        return 3;
    }
    return self.seeothers.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SeeOthers *other = self.seeothers[indexPath.row];
    
    BrandIntroduceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrandIntroduceCollectionViewCell" forIndexPath:indexPath];
    [cell.image setImageWithURL:[NSURL URLWithString:other.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片105_80.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    
//    if ([other.kb_average isNotEmpty]&&!([other.kb_average floatValue] ==0.00)){
//        NSString *kb = [NSString stringWithFormat:@"口碑:%@",other.kb_average];
//        cell.source.text = kb;
//    }else{
//        cell.source.text = @"口碑:暂无数据";
//    }
    
    [cell.source setHidden:YES];
    
    cell.carName.text = other.name;
    
    
    if ([other.zhidaoPrice isNotEmpty]) {
        cell.price.text = other.zhidaoPrice;
    }else{
        cell.price.text = @"暂无报价";
    }
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake((kwidth-15*2-10*2)/3,170);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        CarHeaderCollectionViewCell *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CarHeaderCollectionViewCell" forIndexPath:indexPath];
        headerView.title.text =@"热销车系";
        headerView.backgroundColor = [UIColor whiteColor];
        
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        CarFooderCollectionViewCell *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CarFooderCollectionViewCell" forIndexPath:indexPath];
        footerView.button.titleLabel.text =@"询底价";
        //        footerView.button.backgroundColor  =[UIColor clearColor];
        //        [footerView.button setBackgroundImage:[UIImage imageNamed:@"buttonBlueNormal"] forState:UIControlStateNormal];
        //        [footerView.button setBackgroundImage:[UIImage imageNamed:@"buttonBlueSelected"] forState:UIControlStateHighlighted];
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.button.hidden= YES;
        
        return footerView;
        
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0 ){
        if(self.seeothers.count>0){
            return  CGSizeMake(kwidth, 35);
        }
        return CGSizeZero;
    }else{
        return CGSizeZero;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if(section == 0 ){
        return  CGSizeMake(kwidth, 25);
    }else{
        return CGSizeZero;
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CarDeptViewController *vc = [[CarDeptViewController alloc]init];
    vc.picture  = ((SeeOthers *)self.seeothers[indexPath.row]).pic_url;
    vc.chexiid =  ((SeeOthers *)self.seeothers[indexPath.row]).id;
    [URLNavigation pushViewController:vc animated:YES];
}

@end
