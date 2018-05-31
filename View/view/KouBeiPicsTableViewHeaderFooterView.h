//
//  KouBeiPicsTableViewHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/4/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotoCollectionViewCell.h"
#import "KouBeiDetailPicModel.h"
#import "ZLPhotoPickerBrowserPhoto.h"

@interface KouBeiPicsTableViewHeaderFooterView : UITableViewHeaderFooterView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
-(void)setData:(NSArray<KouBeiDetailPicModel>*) pics;
@end
