//
//  HomeChildUICollectionView.h
//  chechengwang
//
//  Created by 严琪 on 16/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewModel.h"
#import "HomeMoreViewModel.h"
#import "HomeSecondViewModel.h"
#import "HorizontalScrollView.h"

#import "BannerCollectionReusableView.h"


typedef void(^getNums)(NSInteger num);
@protocol HomeChildUICollectionViewDelegate


-(void)searchBarShow:(BOOL)show;

@end


@interface HomeChildUICollectionView : UICollectionView<HorizontalScrollViewDataSource,HorizontalScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,copy)getNums block;


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout catId:(NSString*)catId isFirstModel:(BOOL)isFirstModel isVideoModel:(BOOL)isVideoModel;

@property(nonatomic,weak) id scorllViewdelegate;
@property(nonatomic,assign) BOOL searchBarShow;
-(void)viewWillAppear;
-(void)viewWilldisAppear;

-(void)reloadCurrentData;
@end
