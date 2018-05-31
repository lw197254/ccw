//
//  CompareDelearTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareDelearTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@property (strong,nonatomic)NSString *leftid;
@property (strong,nonatomic)NSString *rightid;
@end
