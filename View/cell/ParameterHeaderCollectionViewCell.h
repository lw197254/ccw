//
//  HeaderCollectionViewCell.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BSNumbersCollectionCell.h"

@interface ParameterHeaderCollectionViewCell : BSNumbersCollectionCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
