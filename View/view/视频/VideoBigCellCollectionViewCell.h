//
//  VideoBigCellCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoBigCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *centerimage;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIView *topView;

-(void)setVideoModel:(VideoModel *)model;

@end
