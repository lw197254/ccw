//
//  CondictionTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CondictionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIView *tagView;


@property (copy, nonatomic) NSArray *arraylist;

-(void)updateView;

@end
