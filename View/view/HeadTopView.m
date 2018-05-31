//
//  HeadTopView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "HeadTopView.h"

@implementation HeadTopView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        ///车城网
//        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toplogo"]];
//        [self addSubview:logo];
//        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(15);
//            make.centerY.equalTo(self);
//        }];
//        [logo setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        [logo setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//        UIImageView *imageArrow =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_定位"]];
//        [self addSubview:imageArrow];
//        
//        [imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.right.equalTo(self.mas_right).offset(-15);
//            make.height.width.mas_equalTo(12);
//        }];
//        
//        self.cityLabel = [[UILabel alloc] init];
//        self.cityLabel.font = [UIFont systemFontOfSize:14];
//        self.cityLabel.textColor = [UIColor whiteColor];
//        
//        [self addSubview:self.cityLabel];
//        [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(imageArrow.mas_left).offset(-4);
//            make.centerY.equalTo(imageArrow);
//        }];
        
        
//        self.cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.cityButton setImage:[UIImage imageNamed:@"ic_定位"] forState:UIControlStateNormal];
//        [self.cityButton setImage:[UIImage imageNamed:@"ic_定位"] forState:UIControlStateSelected];
//        [self.cityButton setImage:[UIImage imageNamed:@"ic_定位"] forState:
//         UIControlStateFocused];
//        
//        
//        self.cityButton.titleLabel.font = FontOfSize(14);
//        
//        [self.cityButton setTitle:@"未知" forState:UIControlStateSelected];
//        [self.cityButton setTitle:@"未知" forState:UIControlStateNormal];
//        
//        [self.cityButton exchangeImageAndTitle];
//        
//        [self addSubview:self.cityButton];
//        
//        [self.cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.right.equalTo(self.mas_right).offset(-15);
//        }];
//        [self.cityButton setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        [self.cityButton setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        self.infoView = [[UIView alloc] init];
        [self.infoView setBackgroundColor:[UIColor whiteColor]];
        
        [self.infoView.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [self.infoView.layer setCornerRadius:4];
        [self.infoView.layer setBorderWidth:1];//设置边界的宽度
        [self.infoView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        [self addSubview:self.infoView];
        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(29);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
      
//        [search mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.infoView);
//
//        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.font = FontOfSize(13);
        infoLabel.textColor = BlackColorBBBBBB;
        infoLabel.text = @"输入搜索内容";
        [self.infoView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            
        }];
//        [infoLabel setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        [infoLabel setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//
        
//
        UIImageView *search = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索"]];
        [self.infoView addSubview:search];
        [search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(infoLabel.mas_left).offset(-10);
            make.centerY.equalTo(infoLabel);
        }];
        
//        [search setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        [search setContentHuggingPriority: UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

        
    }
    return self;
}


@end
