//
//  CustomNavigationBar.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/9.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CustomNavigationBar.h"
#define minSize CGSizeMake(30, 30)
@interface CustomNavigationBar()
@property(nonatomic,copy)CustomNavigationBarItemClickedBlock rightItemClickedBlock;
@property(nonatomic,copy)CustomNavigationBarItemClickedBlock leftItemClickedBlock;
@property(nonatomic,strong)UILabel*titleLabel;
@end
@implementation CustomNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize backButton = _backButton;
@synthesize titleContentView = _titleContentView;
//-(void)setBackButton:(UIButton *)backButton{
//    if (_backButton!=backButton) {
//        _backButton = backButton;
//        [self addSubview:backButton];
//        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.left.equalTo(self).with.offset(self.leftSpace);
//        }];
//    }
//}
-(void)showNavigationTitle:(NSString *)title{
    
}
-(void)showRightBarItems:(NSArray<__kindof UIView*>*)rightBarItems rightItemClickedBlock:(CustomNavigationBarItemClickedBlock)rightItemClickedBlock{
    self.rightBarItems = rightBarItems;
    if (self.rightItemClickedBlock != rightItemClickedBlock) {
        self.rightItemClickedBlock = rightItemClickedBlock;
    }
    
}
-(void)showLeftBarItems:(NSArray<__kindof UIView*>*)leftBarItems leftItemClickedBlock:(CustomNavigationBarItemClickedBlock)leftItemClickedBlock{
    self.leftBarItems = leftBarItems;
    if (self.leftItemClickedBlock != leftItemClickedBlock) {
        self.leftItemClickedBlock = leftItemClickedBlock;
    }
}
-(void)setLeftBarItems:(NSArray<__kindof UIView *> *)leftBarItems{
    if (_leftBarItems!=leftBarItems) {
        if (_leftBarItems.count > 0) {
            [_leftBarItems enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            
        }
        _leftBarItems = leftBarItems;
        
        [_leftBarItems enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSubview:obj];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_greaterThanOrEqualTo(minSize);
                make.centerY.equalTo(self);
                if (idx==0) {
                    make.left.equalTo(self).with.offset(self.leftSpace);
                }else{
                    UIView*leftItem = _leftBarItems[idx-1];
                    make.left.equalTo(leftItem.mas_right).with.offset(self.separeteSpace);
                }
                if (idx==_leftBarItems.count-1) {
                    make.right.equalTo(self).with.offset(self.rightSpace);
                }
                
                
            }];
        }];
    }
}
-(void)setRightBarItems:(NSArray<__kindof UIView *> *)rightBarItems{
    
}
-(UIButton*)backButton{
    if (!_backButton) {
        _backButton = [Tool createButtonWithImage:[UIImage imageNamed:@"ic_back"] target:self action:@selector(backButtonClicked:) tag:0];
        [_backButton setImage:[UIImage imageNamed:@"ic_backSelected"]  forState:UIControlStateHighlighted];
                [self addSubview:_backButton];
                [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.left.equalTo(self).with.offset(self.leftSpace);
                    make.size.mas_greaterThanOrEqualTo(minSize);
                }];
    }
    return _backButton;
}
-(UIView*)titleContentView{
    if (!_titleContentView) {
        _titleContentView = [[UIView alloc]init];
        _titleContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleContentView];
        [_titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
            make.width.lessThanOrEqualTo(self).multipliedBy(0.5);
            
        }];
    }
    return _titleContentView;
}



-(void)backButtonClicked:(UIButton*)button{
    
}
@end
