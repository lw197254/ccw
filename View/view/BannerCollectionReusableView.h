//
//  BannerCollectionReusableView.h
//  chechengwang
//
//  Created by 严琪 on 16/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollView.h"
@interface BannerCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet HorizontalScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
