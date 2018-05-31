//
//  MoreStoreAndMapCollectionViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKMapView.h"
@interface MoreStoreAndMapCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *storeNumberButton;

-(void)hideMapViewAndShowStoreNumberButton;
-(void)hideStoreNumberButtonAndShowMapView;
-(void)showMapViewAndShowStoreNumberButton;

@end
