//
//  PopUpView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "PopUpView.h"

@implementation PopUpView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    }
    return self;
}


-(void)setBackViewClick{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPopUpView:)];
    [self.backView addGestureRecognizer:tapRecognizer];

}

-(void)dismissPopUpView{
    [UIView animateWithDuration:0.25 animations:^{
        self.targetView.height = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)builderView{
    if (self.deleagate&&self.targetView) {
        [self addSubview:self.targetView];
        [self.deleagate buildTargetView:self.targetView];
    }else{
        NSLog(@"没有设置targetview");
        return;
    }
    
    
    if (self.deleagate) {
   
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.top.equalTo(self.targetView.mas_bottom);
        }];
        [self setBackViewClick];
    }else{
        NSLog(@"没有设置backView");
        return;
    }
}

-(void)hiddenPopUpView:(UITapGestureRecognizer*)tap{
    if (self.block) {
        self.block();
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.targetView.height = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    

}

-(void)showPopUpView{
    self.hidden = NO;
    self.targetView.height = 0.1;
    [UIView animateWithDuration:0.25 animations:^{
        self.targetView.height = self.targetViewHeight;
    }completion:^(BOOL finished) {
        
    }];
}

@end
