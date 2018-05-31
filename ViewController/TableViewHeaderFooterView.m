//
//  TableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "TableViewHeaderFooterView.h"

@implementation TableViewHeaderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.image= [[UIImageView alloc] init];
        [self addSubview:self.image];
        
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        
        self.secondLabel = [[UILabel alloc] init];
        [self addSubview:self.secondLabel];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(0);
            make.width.mas_equalTo(5);
        }];
        
        [self.image setBackgroundColor:BlueColor447FF5];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self.image).offset(10);
        }];
        
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.label).offset(50);
        }];
        
        
//        [RACObserve(self,noimage)
//         subscribeNext:^(NSString* x){
//             if(self.noimage){
//             [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
//                 make.centerY.equalTo(self);
//                 make.left.equalTo(self).offset(15);
//             }];
//             }
//         }];
        
        
        //[self setline:self];
        
    }
    return self;
}

////设置一下线
//-(void)setline:(UIView *)cell{
//    if(cell.tag != 1){
//        UIView *view = [[UIView alloc] init];
//        [cell addSubview:view];
//        cell.tag = 1;
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.left.equalTo(cell);
//            make.height.mas_equalTo(0.6);
//        }];
//        view.backgroundColor= seperateLineColor;
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
