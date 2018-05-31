//
//  RecommendTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *view;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
