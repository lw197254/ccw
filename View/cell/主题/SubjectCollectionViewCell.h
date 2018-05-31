//
//  SubjectCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectChexiModel.h"

@interface SubjectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UIImageView *rightAngleImage;
@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *paiming;
@property (weak, nonatomic) IBOutlet UIButton *askPriceButton;


-(void)setSubjectModel:(SubjectChexiModel *)model;
@end
