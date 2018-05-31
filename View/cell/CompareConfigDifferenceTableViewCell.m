//
//  CompareConfigDifferenceTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareConfigDifferenceTableViewCell.h"
#import "LineView.h"
#define leftPadding 10
#define rightPadding 10
@implementation CompareConfigDifferenceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setBottomLine];
}


- (void)setTagView:(UIView*)tagView titleArray:(NSArray *)titleArr{
    
    
   
    //第一个 label的起点
    CGSize size = CGSizeMake(5, 38);
    //间距
    CGFloat padding = 5.0;
   
    CGFloat width = kwidth/2-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i] AndFontSize:14].width+14;
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 38.0;
            size.width = 5.0;
        }
        
        if (width - size.width < rightPadding) {
            size.height += 38.0;
            size.width = 5.0;
        }
        //创建 label点击事件
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, 28);
        [tagView addSubview:button];
        
        
        if (tagView == self.leftTagView) {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tagView).with.offset(size.width);
                make.top.equalTo(tagView).with.offset(size.height-38);
                make.size.mas_equalTo(CGSizeMake(keyWorldWidth, 28));
                if (i==titleArr.count-1) {
                    UIView*view =[[UIView alloc]init];
                    [tagView addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(tagView);
                        make.top.equalTo(button.mas_bottom);
                        make.bottom.equalTo(tagView);
                        make.height.mas_equalTo(1).priority(3);
                        
                    }];
                }
                
            }];
        }else{
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(tagView).with.offset(-size.width);
                make.top.equalTo(tagView).with.offset(size.height-38);
                make.size.mas_equalTo(CGSizeMake(keyWorldWidth, 28));
                if (i==titleArr.count-1) {
                    UIView*view =[[UIView alloc]init];
                    [tagView addSubview:view];
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(tagView);
                        make.top.equalTo(button.mas_bottom);
                        make.bottom.equalTo(tagView);
                        make.height.mas_equalTo(1).priority(3);
                        
                    }];
                }
                
            }];
        }
        
        
        
        button.titleLabel.numberOfLines = 0;
        
        if (tagView == self.leftTagView) {

            [button setBackgroundColor:[UIColor colorWithString:@"0xf3f7ff"]];
            [button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
        }else{

            [button setBackgroundColor:[UIColor colorWithString:@"0xfff5f1"]];
            [button setTitleColor:PinkColorFF500B forState:UIControlStateNormal];
        }
       
        
        //        button.layer.cornerRadius = 3.0;
        //        button.layer.masksToBounds = YES;
        button.titleLabel.font = FontOfSize(14);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        
        button.tag = i;
        //起点 增加
        size.width += keyWorldWidth+padding;
        
    }
    
   
    
    
//    [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(size.height).priorityHigh();
//       
//    }];
    
    
}
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 5;
    return size;
}


-(void)setData:(NSString *)info onView:(UIView*)view{
    if (info.length>0) {
        NSArray *array = [info componentsSeparatedByString:@","];
        for (UIView*v in view.subviews) {
            [v removeFromSuperview];
        }
        
        [self setTagView:view titleArray:array];
    }else{
        for (UIView*v in view.subviews) {
            [v removeFromSuperview];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIView*)leftTagView{
    if (!_leftTagView) {
        _leftTagView = [[UIView alloc]init];
        [self.contentView addSubview:_leftTagView];
        [_leftTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(leftPadding);
            make.right.equalTo(self.middleLineView.mas_left).offset(-rightPadding);
            make.top.equalTo(self.contentView.mas_top).offset(8);
           
            make.height.equalTo(self.rightTagView);
        }];
    }
    return _leftTagView;
}
-(UIView*)rightTagView{
    if (!_rightTagView) {
        _rightTagView = [[UIView alloc]init];
        [self.contentView addSubview:_rightTagView];
        [_rightTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.middleLineView.mas_right).offset(leftPadding);
            make.right.equalTo(self.contentView).offset(-rightPadding);
            make.top.equalTo(self.contentView.mas_top).offset(8);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
             make.height.mas_equalTo(0).priority(1);
        }];
    }
    return _rightTagView;
}
-(LineView*)middleLineView{
    if (!_middleLineView) {
        _middleLineView = [[LineView alloc]init];
        [self.contentView addSubview:_middleLineView];
        [_middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(lineHeight);
            make.top.equalTo(self.contentView).with.offset(8);
//            make.bottom.equalTo(self.contentView).with.offset(-8);
        }];
    }
    return _middleLineView;
}

-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreButton setTitle:@"点击查看全部" forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"ic_blue_down"] forState:UIControlStateNormal];
        [_moreButton setTitle:@"  点击收起" forState:UIControlStateSelected];
        [_moreButton setImage:[UIImage imageNamed:@"ic_blue_up"] forState:UIControlStateSelected];
        [_moreButton exchangeImageAndTitle];
        [self.contentView addSubview:_moreButton];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.leftTagView.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
    return _moreButton;
}

-(void)isneedShowButton:(bool) isshow{
    if (isshow) {
        [self.middleLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.moreButton.mas_top).with.offset(-8);
        }];
    }else{
        [self.middleLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).with.offset(-8);
        }];
    }
}
@end
