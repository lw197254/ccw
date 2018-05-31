//
//  loadingView.m
//  Qumaipiao
//
//  Created by 刘伟 on 15/6/11.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import "LoadingView.h"
@interface LoadingView()
//@property(nonatomic,strong)UIView*contentView;

@property(nonatomic,weak) UIWindow*currentWindow;
@property(nonatomic,assign)NSInteger retainTimes;
@property(nonatomic,strong)UIImageView * gifImageView;
@end
@implementation LoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    
   
    
    
    
}
+(instancetype)shareInstance{
    static LoadingView *loadingView;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        loadingView = [[LoadingView alloc]init];
    });
    return loadingView;
}

-(instancetype)init{
    if (self = [super init]) {
        _retainTimes = 0;
        self.gifImageView = [[UIImageView alloc]init];
        //self.gifImageView.backgroundColor  = [UIColor orangeColor];
        
        NSArray*imageArray =  [Tool imagesWithGif:@"loading@2x"];
        self.gifImageView .animationImages = imageArray;
        self.gifImageView.animationDuration = 0.5;
        [self addSubview:self.gifImageView];
        
        [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 20));
           
        }];
        self.gifImageView.animationRepeatCount = 110;

          }
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
       return self;
}
//-(void)setTitle:(NSString *)title{
//    if (title!=_title) {
//        _title = title;
//    }
//    if (_title==nil||[_title isEqualToString:@""]) {
//        [_titleLabel removeFromSuperview];
//        _titleLabel=nil;
//        return;
//    }
//    //——title不是空的时候，就创建titleLabel来显示title，
//    if (_titleLabel==nil) {
//        _titleLabel = [Tool createLabelWhichTextFontIsTwelf];
//        _titleLabel.font = [UIFont systemFontOfSize:10];
//        [self.contentView addSubview:_titleLabel];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.centerX.equalTo(self.contentView);
//            make.size.mas_equalTo(CGSizeMake(60, 20));
//        }];
//    }
//        _titleLabel.text = _title;
//    
//    
//}


-(UIWindow*)currentWindow{
    if (_currentWindow == nil) {
        
        UIWindow * currentWindow = [UIApplication sharedApplication].keyWindow;
        if (!currentWindow) {
            currentWindow = [[UIApplication sharedApplication].windows firstObject];
        }
           _currentWindow = currentWindow;
    }
    return _currentWindow;
}
-(void)show{
    if (_isHalfClearColor==YES) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }else{
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    UIViewController*VC =[Tool currentViewController];
    if (self.superview==nil||![self.superview isEqual:VC.view]) {
//        [self.currentWindow addSubview:self];
   
        _retainTimes=0;
        [VC.view addSubview:self];
//        [VC.view addSubview:self];
       // [VC.view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {

            
            make.top.mas_equalTo(VC.view);
            make.left.right.bottom.equalTo(VC.view);
//            make.edges.equalTo(VC.view);
        }];
        self.gifImageView.animationRepeatCount = 999999;
        [self.gifImageView startAnimating];
    }
    _retainTimes++;
//    self.gifImageView.animationRepeatCount += 99999;
    
   
}
+(void)show{
    [[LoadingView shareInstance]show];
}
+(void)dismiss{
    [[LoadingView shareInstance]dismiss];
}
-(void)dismiss{
    _retainTimes--;
    if (_retainTimes<0) {
        _retainTimes=0;
    }
    if (_retainTimes==0) {
        _isHalfClearColor = NO;
        [self.gifImageView stopAnimating];
        [self removeFromSuperview];
    
    }
    

}

@end
