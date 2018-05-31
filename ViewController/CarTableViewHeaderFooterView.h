//
//  CarTableViewHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeeOthers.h"

@interface CarTableViewHeaderFooterView : UITableViewHeaderFooterView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray<SeeOthers> *seeothers;
@end
