//
//  VideoHearView.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoHearView.h"

@implementation VideoHearView

//-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        [[NSBundle mainBundle]loadNibNamed:@"VideoHearView" owner:self options:nil];
//        [self addSubview:self.view];
//        
//        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//        
//    }
//    return self;
//}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle]loadNibNamed:@"VideoHearView" owner:self options:nil];
        [self addSubview:self.view];

        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

    }
    return self;
}


@end
