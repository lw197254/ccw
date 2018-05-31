//
//  UpdateView.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/15.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UpdateView.h"

#define ITUNES_HOME_URL @"https://itunes.apple.com/us/app/id%@?ls=1&mt=8"
#define UM_SET_VALUE(Object,Str) (Object==nil || [Object length] == 0 ?Str:Object)

@interface UpdateView()
@property(strong,nonatomic)UIImageView *background;

@property (weak, nonatomic) IBOutlet UILabel *dissmisslabel;

@end


@implementation UpdateView

-(UIImageView *)background{
    if (!_background) {
        _background = [[UIImageView alloc]init];
    }
    return _background;
}

-(instancetype)init{
    if(self = [super init]){

        [self addSubview:self.background];
        [self sendSubviewToBack:self.background];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.background setBackgroundColor:[UIColor blackColor]];
        [self.background setAlpha:0.7];
        
        [[NSBundle mainBundle]loadNibNamed:@"UpdateView" owner:self options:nil];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self.updateImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_equalTo(38);
            make.right.equalTo(self).mas_equalTo(-38);
        }];
  
        
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletag:)];
        singleTapRecognizer.numberOfTapsRequired = 1; // 单击
        [self.dissmisslabel setUserInteractionEnabled:YES];
        [self.dissmisslabel addGestureRecognizer:singleTapRecognizer];//关键语句，给self.view添加一个手势监测；
        
     }
    return self;
}

-(void)handletag:(UITapGestureRecognizer*)recognizer {
    NSLog(@"取消view");
    [self removeFromSuperview];
}


- (IBAction)updateApp:(id)sender {
    NSLog(@"点击升级");
    NSString *defaultHomeUrl = [NSString stringWithFormat:ITUNES_HOME_URL, appleID];
    NSString *homeUrl;
    homeUrl = UM_SET_VALUE(homeUrl, defaultHomeUrl);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:homeUrl]];
}


@end
