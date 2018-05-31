//
//  CompareKoubeiTableViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompareKoubeiView;
@interface CompareKoubeiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CompareKoubeiView *leftView;
@property (weak, nonatomic) IBOutlet CompareKoubeiView *rightView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
