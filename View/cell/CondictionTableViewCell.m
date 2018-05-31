//
//  CondictionTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CondictionTableViewCell.h"

#define leftPadding 10
#define rightPadding 10
#define minWith 80


@implementation CondictionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateView{
    NSArray *arry = self.arraylist;
    [self setTagView:self.tagView titleArray:arry];
}

- (void)setTagView:(UIView*)tagView titleArray:(NSArray *)titleArr{
    
    //第一个 label的起点
    CGSize size = CGSizeMake(14, 53);
    //间距
    CGFloat padding = 14.0;
    
    CGFloat width = tagView.width-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i][@"value"] AndFontSize:14].width+14;
        
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 38.0;
            size.width =padding;
        }
        
        if (width - size.width < rightPadding) {
            size.height += 38.0;
            size.width = padding;
        }
        
        if (keyWorldWidth<minWith) {
            keyWorldWidth = minWith;
        }
        
        //创建 label点击事件
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, 34);
        [tagView addSubview:button];
            
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tagView).with.offset(size.width);
                make.top.equalTo(tagView).with.offset(size.height-38);
                make.size.mas_equalTo(CGSizeMake(keyWorldWidth, 34));
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
        
        button.titleLabel.numberOfLines = 0;
        
 
        button.layer.borderWidth =0.5;
        button.layer.borderColor = [UIColor colorWithString:@"0xe9e9e9"].CGColor;
       [button setBackgroundColor:[UIColor whiteColor]];
       [button setTitleColor:BlackColor555555 forState:UIControlStateNormal];
        
        
        //        button.layer.cornerRadius = 3.0;
        //        button.layer.masksToBounds = YES;
        button.titleLabel.font = FontOfSize(13);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:titleArr[i][@"value"] forState:UIControlStateNormal];
        
        button.tag = i;
        //起点 增加
        size.width += keyWorldWidth+padding;
        
    }    
}
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 5;
    return size;
}

@end
