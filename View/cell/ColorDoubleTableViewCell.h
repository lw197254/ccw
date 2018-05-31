//
//  ColorDoubleTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/2/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorDoubleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageDouble;

@end
