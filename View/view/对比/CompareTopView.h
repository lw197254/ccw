//
//  CompareTopView.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModuleCollectionView.h"
@class NewCompareCarListModel;
@class NewCompareCarModel;

@protocol CompareTopViewDelegate

-(void)setSwipeWay:(bool) swpie;
-(void)setUpNewCarsArrayWithLeftCar:(NewCompareCarModel *)leftcar RightCar:(NewCompareCarModel *)rightCar;
-(void)rebuildArray:(NSMutableArray *) newarray withDelateNumber:(NSInteger) count;

@end

@interface CompareTopView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,RTDragCellcollectionViewDataSource,RTDragCellcollectionViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet ModuleCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@property (assign, nonatomic) id<CompareTopViewDelegate> swDelegate;

@property (assign, nonatomic) NewCompareCarListModel *cars;


@property (nonatomic,strong)UIView *parentView;


//上下滑动切换头部界面的方法
-(void)reloadCollectionWithType:(NSString *) type;
-(void)reloadCollection;

@end
