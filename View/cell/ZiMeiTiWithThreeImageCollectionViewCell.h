//
//  ZiMeiTiWithThreeImageCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/4/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiMeiTiWithThreeImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imageleft;
@property (weak, nonatomic) IBOutlet UIImageView *imagemiddle;
@property (weak, nonatomic) IBOutlet UIImageView *imageright;
@property (weak, nonatomic) IBOutlet UILabel *views;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
