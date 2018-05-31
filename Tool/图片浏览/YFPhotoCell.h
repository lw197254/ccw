//
//  PhotoCell.h
//  
//
//  Created by Mr.Yan on 15/11/24.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFPhoto.h"
#import "YFPhotoScrollView.h"

@interface YFPhotoCell : UICollectionViewCell

@property (nonatomic,strong)YFPhotoScrollView *photoView;

@property(nonatomic,strong)YFPhoto *photo;
@end
