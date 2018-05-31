//
//  HomeGuideCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGuideCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
