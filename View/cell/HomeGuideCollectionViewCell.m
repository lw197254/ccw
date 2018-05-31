//
//  HomeGuideCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "HomeGuideCollectionViewCell.h"
#import "HomeCollectionViewCell.h"

#import "NewCarForSaleViewController.h"
#import "RankinglistControllerViewController.h"
#import "BuyCarGuideViewController.h"
#import "ReducePriceListViewController.h"
#import "DealerViewController.h"
#import "BuyCarCalculatorViewController.h"

#import "RegionClickViewModel.h"


#define icon @"icon"
#define title @"title"

#define maxcount 5
#define mincount 4

@interface HomeGuideCollectionViewCell()


@property(nonatomic,strong) NSArray *array;
@property(nonatomic,strong)RegionClickViewModel *viewModel;
@end
@implementation HomeGuideCollectionViewCell

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
    
    [self.collectionView registerNib:nibFromClass(HomeCollectionViewCell) forCellWithReuseIdentifier:classNameFromClass(HomeCollectionViewCell)];
    
    self.array =@[@{icon:@"车icon",title:@"购车百科"},
                    @{icon:@"计算器icon",title:@"购车计算器"},
                    @{icon:@"贷款icon",title:@"热销排行"},
                    @{icon:@"附近经销商", title:@"附近经销商"},
                   @{icon:@"优惠降价icon", title:@"优惠降价"},
                   @{icon:@"新车上市", title:@"新车上市"}
                  ];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kwidth/5, 100);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classNameFromClass(HomeCollectionViewCell) forIndexPath:indexPath];
    [cell.image setImage:[UIImage imageNamed:self.array[indexPath.row][icon]]];
    cell.name.text = self.array[indexPath.row][title];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = self.array[indexPath.row][title];
    
    if ([name isEqualToString:@"购车百科"]) {
        self.viewModel.request.regionId = guidecarclick;
        self.viewModel.request.startRequest = YES;
        BuyCarGuideViewController  *vc = [[BuyCarGuideViewController alloc]init];
        [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"购车计算器"]){
        self.viewModel.request.regionId = jisuancarclick;
        self.viewModel.request.startRequest = YES;
        BuyCarCalculatorViewController *vc = [[BuyCarCalculatorViewController alloc]init];
        [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"热销排行"]){
        self.viewModel.request.regionId = hotlist;
        self.viewModel.request.startRequest = YES;
        RankinglistControllerViewController*favourite = [[RankinglistControllerViewController alloc]init];
        [[Tool currentViewController].rt_navigationController pushViewController:favourite animated:YES];
    }else if ([name isEqualToString:@"附近经销商"]){
        self.viewModel.request.regionId = nearbydealer;
        self.viewModel.request.startRequest = YES;
        DealerViewController*favourite = [[DealerViewController alloc]init];
        [[Tool currentViewController].rt_navigationController pushViewController:favourite animated:YES];
    }else if ([name isEqualToString:@"优惠降价"]){
        self.viewModel.request.regionId = reducelist;
        self.viewModel.request.startRequest = YES;
        ReducePriceListViewController*vc = [[ReducePriceListViewController alloc]init];
        [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"新车上市"]){
        self.viewModel.request.regionId = newcar;
        self.viewModel.request.startRequest = YES;
        NewCarForSaleViewController*vc = [[NewCarForSaleViewController alloc]init];
        [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
    }
}

-(RegionClickViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [RegionClickViewModel SceneModel];
    }
    return _viewModel;
}


@end
