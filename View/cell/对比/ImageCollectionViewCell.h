//
//  ImageCollectionViewCell.h
//  mvp
//
//  Created by 严琪 on 2017/7/26.
//  Copyright © 2017年 严琪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompareCar;

@interface ImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *sonTitle;

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic)  UIImageView *deleteimage;

@property (strong, nonatomic)  UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIButton *topDeleteButton;

-(void)setCarInfo:(CompareCar *)car;
@end
