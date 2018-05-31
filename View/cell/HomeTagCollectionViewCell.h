//
//  HomeTagCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsListModel.h"

@interface HomeTagCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)setXiHaoDataByForm:(TagsListModel *)data;

@end
