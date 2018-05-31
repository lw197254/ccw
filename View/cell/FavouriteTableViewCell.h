//
//  FavourateTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2016/12/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteTableViewCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,assign)BOOL showSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
