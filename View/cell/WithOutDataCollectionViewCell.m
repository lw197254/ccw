//
//  WithOutDataCollectionViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "WithOutDataCollectionViewCell.h"

@implementation WithOutDataCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.withOutDataView = [[WithDataView alloc]init];
        self.withOutDataView.imageView.image = [UIImage imageNamed:@"暂无经销商"];
        self.withOutDataView.titleLabel.text = @"暂无图片";
        [self addSubview:self.withOutDataView];
        [self.withOutDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
    }
    return self;
}
@end
