//
//  CarTypeHeaderCollectionViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTHorizontalSelectionList.h"
@interface CarTypeHeaderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *horizontalListView;
@property (strong, nonatomic) UITapGestureRecognizer *headerImageViewTapGesture;
///加入pk
@property (weak, nonatomic) IBOutlet UIButton *pkButton;
//询价
@property (weak, nonatomic) IBOutlet UIButton *askForPriceButton;
//贷款价格
@property (weak, nonatomic) IBOutlet UIButton *daiKuanButton;
@property (weak, nonatomic) IBOutlet UILabel *daiKuanPriceLabel;
//全款价格
@property (weak, nonatomic) IBOutlet UILabel *quanKuanPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *quanKuanButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightConstraint;

@property (strong, nonatomic) UIImageView *smallImage;

@end
