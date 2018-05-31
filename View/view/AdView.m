//
//  AdView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "AdView.h"
#import "AdModel.h"
#import "WebViewController.h"
#import "Timer.h"
@interface AdView()
@property(nonatomic,strong)UIButton*skipButton;
@property(nonatomic,strong)UIImageView*adImageView;
@property(nonatomic,copy)CompletionBlock block;
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)AdModel * model;
@end

@implementation AdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.adImageView = [[UIImageView alloc]init];
      
       
         self.skipButton = [Tool createButtonWithImage:nil target:self action:@selector(skipButtonClicked:) tag:0];
        [self.skipButton setTitle:@" 点击跳过 " forState:UIControlStateNormal];
        [self.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.skipButton.titleLabel.font = FontOfSize(11);
        self.skipButton.layer.cornerRadius = 3;
        self.skipButton.layer.masksToBounds = YES;
        [self.skipButton setBackgroundColor:BlackColor7B7B7B];
        self.skipButton.hidden = YES;
        UIImageView*logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"screen"]];
        [self addSubview:logo];
        
        [self addSubview:self.adImageView];
        [self addSubview:self.skipButton];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.equalTo(self);
            make.height.mas_equalTo(120);
        }];
        [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(logo.mas_top);
        }];
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-15);
            make.top.equalTo(self).with.offset(35);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
    }
    return self;
}
+(void)showAdViewOnWindow:(UIWindow*)window complateBlock:(CompletionBlock)finish{
    
    
    //    lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    AdView*view = [[AdView alloc]init];
   
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(window);
        make.bottom.equalTo(window.mas_bottom).offset(-SafeAreaBottom);
    }];
    view.block = finish;
    NSDictionary*dict =  [[NSUserDefaults standardUserDefaults]objectForKey:launchScreenImage];
    
    AdModel*model = [[AdModel alloc]initWithDictionary:dict error:nil];
    view.model = model;
    if (model.isNotEmpty) {
        NSDate*date = [NSDate date];
        NSDate*beginDate = [NSDate dateWithString:model.begintime format: @"yyyy-MM-dd HH:mm:ss"];
        NSDate*endDate = [NSDate dateWithString:model.endtime format: @"yyyy-MM-dd HH:mm:ss"];
        if ([date timeIntervalSinceDate:beginDate]>=0&&[endDate timeIntervalSinceDate:date]>=0) {
            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:view action:@selector(tap:)];
            
            [view addGestureRecognizer:tap];
            
            view.skipButton.hidden = NO;
              [view.skipButton setTitle:[NSString stringWithFormat:@"点击跳过 %.0f",model.delay-1] forState:UIControlStateNormal];
            NSLog(@"_____%.0f",model.delay);
            [Timer timerWithTimeInerval:model.delay repeatBlock:^(NSString *time) {
                NSLog(@"AAAA%@",time);
                [view.skipButton setTitle:[NSString stringWithFormat:@"点击跳过 %ld",[time integerValue]-1] forState:UIControlStateNormal];
            } finishedRepeat:^(NSString *title) {
               
                [view skipButtonClicked:nil];
            }];

            [view.adImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage: [UIImage imageWithColor:[UIColor whiteColor]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                

//                [UIView animateWithDuration:model.delay delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                    view.alpha = 1;
//                    //        imageV.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.25 animations:^{
//                        view.alpha = 0.0f;
//                        if (view.block) {
//                            view.block();
//                        }
//                        [view removeFromSuperview];
//                    }];
                

                    
                    
//                }];
                
            }];
            
        }else{
            view.adImageView.image = [UIImage imageWithColor:[UIColor whiteColor]] ;
            view.timer =  [NSTimer scheduledTimerWithTimeInterval:2 target:view selector:@selector(skipButtonClicked:) userInfo:nil repeats:NO];//
        }
        
    }else{
        view.adImageView.image = [UIImage imageWithColor:[UIColor whiteColor]] ;
          view.timer =  [NSTimer scheduledTimerWithTimeInterval:2 target:view selector:@selector(skipButtonClicked:) userInfo:nil repeats:NO];//        [UIView animateWithDuration:1.5f delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//          view.alpha = 1;
//            //        imageV.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.25 animations:^{
//                view.alpha = 0.0f;
//                if (view.block) {
//                    view.block();
//                }
//                [view removeFromSuperview];
//            }];
//
//            
//        }];
        
    }

}

-(void)skipButtonClicked:(UIButton*)button{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0f;
        
    }completion:^(BOOL finished) {
        if (self.block) {
            self.block();
        }
        [self removeFromSuperview];
    }];
}
-(void)tap:(UIGestureRecognizer*)gesture{
   
    if (self.model.isNotEmpty) {
        WebViewController*web = [[WebViewController alloc]init];
        web.urlString = self.model.url;
        UINavigationController*nav = [Tool currentNavigationController ];
        [nav pushViewController:web animated:YES];
        
    }
    [self skipButtonClicked:self.skipButton];
    
}

@end
