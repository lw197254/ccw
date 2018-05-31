//
//  NewVideoCollectionViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoLabelListModel.h"
#import "VideoLabelModel.h"


@interface NewVideoCollectionViewController : UICollectionReusableView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic,copy) VideoLabelListModel *datas;

@end
