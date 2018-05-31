//
//  TitleCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/23.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompareCar;

@interface TitleCompareCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *sonTitle;

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic)  UIImageView *deleteimage;

-(void)setCarInfo:(CompareCar *)car;
@end
