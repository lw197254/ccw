//
//  CompareKoubeiView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
#import "NewCompareCarModel.h"
@interface CompareKoubeiView : UIView
@property(nonatomic,strong)IBOutlet UIView*view;
@property (weak, nonatomic) IBOutlet UILabel *koubeiLabel;
@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UIButton *moreKoubeiButton;
@property (weak, nonatomic) IBOutlet UILabel *koubeiDetailLabel;


@property (strong, nonatomic) NewCompareCarModel *car;
@end
