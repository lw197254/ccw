//
//  TagsViewTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TagsViewTableViewCell.h"

#define leftPadding 10
#define rightPadding 10
#define minWith 10
#define minheight 35

@implementation TagsViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.defaultClick = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma 功能
- (void)setTagView:(UIView*)tagView titleArray:(NSArray *)titleArr{
    
    //第一个 label的起点
    CGSize size = CGSizeMake(15, 10);
    //间距
    CGFloat padding =10.0;
    
    CGFloat width = kwidth-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        TagsModel *tag = self.tags[i];
        NSString *name = [NSString stringWithFormat:@"%@",tag.name];
        
        
        CGFloat keyWorldWidth = [self getSizeByString:name AndFontSize:15].width+40;
        
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        
        if (width - size.width < keyWorldWidth) {
            size.height += minheight+10;
            size.width = 15.0;
        }
        
        if (width - size.width < rightPadding) {
            size.height += minheight+10;
            size.width = 15.0;
        }
        
        if (keyWorldWidth<minWith) {
            keyWorldWidth = minWith;
        }
        
        //创建 label点击事件
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, minheight);
        [tagView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagView).with.offset(size.width);
            make.top.equalTo(tagView).with.offset(size.height);
            make.size.mas_equalTo(CGSizeMake(keyWorldWidth, minheight));
            if (i==titleArr.count-1) {
                UIView*view =[[UIView alloc]init];
                [tagView addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(tagView);
                    make.top.equalTo(button.mas_bottom).offset(10);
                    make.bottom.equalTo(tagView);
                    make.height.mas_equalTo(1).priority(3);
                    
                }];
            }
            
        }];
        
        button.titleLabel.numberOfLines = 0;
        button.highlighted = NO;
        
        [button setBackgroundImage:[UIImage imageWithColor:self.color size:button.size] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:button.size] forState:UIControlStateNormal];
        
        [button setTitleColor:self.color forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        button.titleLabel.font = FontOfSize(15);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [button setTitle:name forState:UIControlStateNormal];
        
        button.tag = i;
        //起点 增加
        size.width += keyWorldWidth+padding;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //保证所有touch事件button的highlighted属性为NO,即可去除高亮效果
        [button addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    
        
        
        button.layer.cornerRadius = 17.5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = self.color.CGColor;
        button.layer.masksToBounds = YES;
        
        button.selected = self.defaultClick;
    }
    
    self.height = size.height;
}
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 5;
    return size;
}

-(void)buttonClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [XiHaoClickObject addname:button.titleLabel.text];
    }else{
        [XiHaoClickObject deletename:button.titleLabel.text];
    }
 
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}
@end
