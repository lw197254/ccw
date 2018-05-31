//
//  VideoTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/5.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigimage;
@property (weak, nonatomic) IBOutlet UIImageView *centerimage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *des;

@end
