//
//  ColorTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/2/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ColorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;

@end
