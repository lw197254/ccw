//
//  CheXiSCTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/2/24.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheXiSCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property(nonatomic,assign)BOOL showSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *factory;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
