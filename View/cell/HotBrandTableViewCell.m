//
//  HotBrandTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/23.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "HotBrandTableViewCell.h"


@implementation HotBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.separatorInset = UIEdgeInsetsMake(0, 600, 0, 0);
        [self configUI];
    }
    return self;
}
-(void)configUI{
    if (!self.view) {
        self.view = [[HotBrandView alloc]init];
        [self.contentView addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.right.equalTo(self.contentView);
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

