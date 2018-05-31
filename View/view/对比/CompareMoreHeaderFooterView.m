//
//  CompareMoreHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/25.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareMoreHeaderFooterView.h"

@implementation CompareMoreHeaderFooterView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self configUI];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)configUI{
    [self.contentView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreButton setTitle:@"查看详细配置对比" forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"箭头向右蓝"] forState:UIControlStateNormal];
        [_moreButton exchangeImageAndTitle];
    }
    return _moreButton;
}



@end
