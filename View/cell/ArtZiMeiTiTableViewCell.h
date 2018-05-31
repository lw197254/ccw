//
//  ArtZiMeiTiTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/4/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtZiMeiTiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,assign)BOOL showSelectButton;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *views;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
