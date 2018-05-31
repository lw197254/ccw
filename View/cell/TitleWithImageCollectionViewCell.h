//
//  TitleWithImageCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 16/12/26.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleWithImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *bigimage;
@property (weak, nonatomic) IBOutlet UILabel *views;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
