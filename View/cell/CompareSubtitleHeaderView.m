//
//  CompareSubtitleHeaderView.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/23.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareSubtitleHeaderView.h"

@implementation CompareSubtitleHeaderView

-(instancetype)initWithByType:(NSString *)titleType ReuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithReuseIdentifier:reuseIdentifier]) {
       
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        if ([titleType isEqualToString:@"bottom"]) {
            [self configUIBottom];
        }else{
            [self configUICenter];
        }
    }
    return self;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self  = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self configUICenter];
    }
    return self;
}

-(void)configUICenter{
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

-(void)configUIBottom{
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}
-(UILabel*)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [Tool createLabelWithTitle:@"" textColor:BlackColor333333 tag:0];
        _subTitleLabel.font  = FontOfSize(14);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
    
}

@end
