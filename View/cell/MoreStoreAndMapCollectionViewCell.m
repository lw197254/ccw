//
//  MoreStoreAndMapCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "MoreStoreAndMapCollectionViewCell.h"
@interface MoreStoreAndMapCollectionViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeNumberButtonHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewBottomConstraints;
@end
@implementation MoreStoreAndMapCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)hideMapViewAndShowStoreNumberButton{
    [self hideMapView];
    [self showStoreNumberButton];
     self.mapViewBottomConstraints.constant = 10;
    [self layoutIfNeeded];
    
}
-(void)hideStoreNumberButtonAndShowMapView{
    
    [self showMapView];
    [self hideStoreNumberButton];
    [self layoutIfNeeded];
    
}
-(void)showMapViewAndShowStoreNumberButton{
   
    [self showMapView];
     [self showStoreNumberButton];
    [self layoutIfNeeded];
}

-(void)hideMapView{
//    self.mapViewHeightConstraints.constant = 0;
    self.mapView.hidden = YES;
    self.mapViewBottomConstraints.constant = 0;

}
-(void)hideStoreNumberButton{
    self.storeNumberButtonHeightConstraints.constant = 0;
    self.storeNumberButton.hidden = YES;
    

}
-(void)showMapView{
    self.mapViewHeightConstraints.constant = 180;
    self.mapView.hidden = NO;
    self.mapViewBottomConstraints.constant = 10;

}
-(void)showStoreNumberButton{
    self.storeNumberButtonHeightConstraints.constant = 44;
    self.mapViewBottomConstraints.constant = 10;
    self.storeNumberButton.hidden = NO;

}
@end
