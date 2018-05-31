//
//  PublicPraiseTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicPraiseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *sees;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oil;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *goodComment;
@property (copy, nonatomic) NSString *badCommentString;

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIView *imageTable;
@property (weak, nonatomic) IBOutlet UIButton *firstbutton;
@property (weak, nonatomic) IBOutlet UIButton *secondbutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTableHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilTypeLabel;

@end
