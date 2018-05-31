//
//  KouBeiCarTypeTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/1/18.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KouBeiCarTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *factory;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *cardept;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,assign)BOOL showSelectButton;

@end
