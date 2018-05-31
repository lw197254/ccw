//
//  FindeTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindBaseModel.h"

@interface FindeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;

-(void)setCellData:(FindBaseModel *)data;
@end
