//
//  BrandIntroducerView.h
//  chechengwang
//
//  Created by 严琪 on 2017/9/20.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeOthers.h"

@interface BrandIntroducerView : UIView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray<SeeOthers> *seeothers;


@end
