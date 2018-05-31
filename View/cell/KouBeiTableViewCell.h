//
//  KouBeiTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KouBeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *views;
@property (weak, nonatomic) IBOutlet UILabel *time;


@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,assign)BOOL showSelectButton;
@end
