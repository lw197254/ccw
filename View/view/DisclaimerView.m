//
//  DisclaimerView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "DisclaimerView.h"
#import "WebViewController.h"

@implementation DisclaimerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle]loadNibNamed:@"DisclaimerView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self setTopLineShow:YES];
        [self setTopLineWithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesturRecognizer];
        
    }
    return self;
}


-(void)tapAction:(id)tap
{
    WebViewController *controller = [[WebViewController alloc] init];
    controller.urlString = @"http://m.checheng.com/article/personInfo?app=1";
    controller.titleString = @"个人信息保护声明";
    [URLNavigation pushViewController:controller animated:YES];
}

@end
