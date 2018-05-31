//
//  DealerCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerCollectionViewCell.h"

@interface DealerCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation DealerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setData:(NSString *)value{
    self.label.text = value;
    self.label.layer.borderColor = [[UIColor grayColor]CGColor];
    self.label.layer.borderWidth = 0.5f;
    self.label.layer.masksToBounds = YES;
}

@end
