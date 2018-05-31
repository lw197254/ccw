//
//  LineView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "LineView.h"

@implementation LineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self  = [super init]) {
       self.backgroundColor = BlackColorE3E3E3;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        self.backgroundColor = BlackColorE3E3E3;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = BlackColorE3E3E3;
   
}
@end
