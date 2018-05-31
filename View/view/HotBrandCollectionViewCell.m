//
//  HotBrandCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "HotBrandCollectionViewCell.h"

@implementation HotBrandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configUI];
    // Initialization code
}
-(void)configUI{
    if (!self.view) {
        self.view = [[HotBrandView alloc]init];
        [self.contentView addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}
@end
