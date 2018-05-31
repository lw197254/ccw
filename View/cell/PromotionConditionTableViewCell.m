//
//  PromotionConditionTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionConditionTableViewCell.h"

@interface PromotionConditionTableViewCell()

@property (nonatomic,strong)UIView *tagView;
@end

@implementation PromotionConditionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView:(NSArray *)titleArr{
    self.tagView= [[UIView alloc]initWithFrame:CGRectZero];
    //第一个 label的起点
    CGSize size = CGSizeMake(5, 38);
    //间距
    CGFloat padding = 5.0;
    CGFloat leftPadding = 10;
    CGFloat rightPadding = 10;
    CGFloat width = [UIScreen                                                                       mainScreen].bounds.size.width-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i] AndFontSize:14].width+14;
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 38.0;
            size.width = 5.0;
        }
        
        if (width - size.width < 100) {
            size.height += 38.0;
            size.width = 5.0;
        }
        //创建 label点击事件
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, 28);
        button.titleLabel.numberOfLines = 0;
        UIImage *image = [UIImage imageNamed:@"bnt_xundijia_n.png"];
//UIImage*newImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [button setBackgroundImage: [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2] forState:UIControlStateNormal];
        [button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
//        button.layer.cornerRadius = 3.0;
//        button.layer.masksToBounds = YES;
        button.titleLabel.font = FontOfSize(14);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [self.tagView addSubview:button];
        button.tag = i;
        //起点 增加
        size.width += keyWorldWidth+padding;
        
    }
    
    [self.contentView addSubview:self.tagView];
    
    
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
        make.left.equalTo(self.contentView).offset(leftPadding);
        make.right.equalTo(self.contentView.mas_right).offset(-rightPadding);
        make.top.equalTo(self.contentView.mas_top).offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
   
}
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 5;
    return size;
}

-(void)setData:(NSString *)info{
    if (info.length>0) {
        NSArray *array = [info componentsSeparatedByString:@","];
        [self.tagView removeFromSuperview];
        [self initView:array];
    }
}

@end
