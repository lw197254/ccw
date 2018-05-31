//
//  PublicPraiseHeaderView.m
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicPraiseHeaderView.h"


@interface  PublicPraiseHeaderView()

#define leftPadding 10
#define rightPadding 10
#define minWith 80

@end

@implementation PublicPraiseHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildOldHeader];
    }
    return self;
}

#pragma 旧头部

-(UIView *)oldView{
    if (!_oldView) {
        _oldView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_oldView];
        
        [_oldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(65);
        }];
    }
    return _oldView;
}

-(void)buildOldHeader{
    UIView *leftView = [[UIView alloc] init];
    UIView *rightView = [[UIView alloc] init];
    
    [self.oldView addSubview:leftView];
    [self.oldView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.oldView);
        make.width.mas_equalTo(kwidth/2);
    }];
    
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.oldView);
        make.width.mas_equalTo(kwidth/2);
    }];
    
    //左边
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    
    [leftView addSubview:firstView];
    
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(leftView);
        
        
    }];
    
    UIImageView *firstImage = [[UIImageView alloc] init];
    
    firstImage.image = [UIImage imageNamed:@"评分.png"];
    [firstView addSubview:firstImage];
    
    [firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.equalTo(firstView);
    }];
    
    
    //        self.bar = [[RatingBar alloc] init];
    //        [firstView addSubview:self.bar];
    //        self.bar.isIndicator = NO;
    //
    //        [self.bar setImageDeselected:@"ic_star" halfSelected:@"ic_star3" fullSelected:@"ic_star2" andDelegate:nil];
    //        [self.bar displayRating:5.0];
    //        [self.bar mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.width.mas_equalTo(30);
    //            make.height.mas_equalTo(10);
    //            make.left.equalTo(firstImage.mas_right).offset(5);
    //            make.top.equalTo(firstImage.mas_top);
    //        }];
    self.starLabel = [Tool createLabelWithTitle:@"" textColor:BlackColor333333 tag:0];
    self.starLabel.font = FontOfSize(17);
    [firstView addSubview:self.starLabel];
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(firstView);
        make.left.equalTo(firstImage.mas_right).offset(5);
        make.top.equalTo(firstImage);
    }];
    self.commentPeopleNumberLabel = [[UILabel alloc] init];
    [firstView addSubview:self.commentPeopleNumberLabel];
    [self.commentPeopleNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(firstImage.mas_bottom);
        make.left.equalTo(self.starLabel);
        make.right.equalTo(firstView);
    }];
    
    self.commentPeopleNumberLabel.textColor = BlackColor999999;
    self.commentPeopleNumberLabel.font= FontOfSize(12);
    self.commentPeopleNumberLabel.text =@"test";
    //右边
    
    UIView *secondView = [[UIView alloc] init];
    
    [rightView addSubview:secondView];
    
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(rightView);
        
    }];
    
    UIImageView *secondImage = [[UIImageView alloc] init];
    secondImage.image = [UIImage imageNamed:@"奖杯.png"];
    [secondView addSubview:secondImage];
    [secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.equalTo(secondView);
    }];
    
    self.rankLabel = [[UILabel alloc] init];
    [secondView addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondImage.mas_right).offset(5);
        make.top.equalTo(secondView.mas_top);
        make.right.equalTo(secondView);
    }];
    
    self.rankLabel.textColor = BlackColor333333;
    self.rankLabel.font= FontOfSize(17);
    self.rankLabel.text =@"排名";
    
    self.carTypeNumberLabel = [[UILabel alloc] init];
    [secondView addSubview:self.carTypeNumberLabel];
    [self.carTypeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(secondImage);
        make.left.equalTo(self.rankLabel);
        make.right.equalTo(secondView);
    }];
    
    self.carTypeNumberLabel.textColor = BlackColor999999;
    self.carTypeNumberLabel.font= FontOfSize(12);
    self.carTypeNumberLabel.text =@"车型个数";
}





-(void)reloadSelection{
 
    if (![self isNeedShowModel]) {
        self.paihangView.labelright.hidden = YES;
        self.paihangView.carName.hidden = YES;
        
        [self.paihangView.labelleft setBackgroundColor:BlueColor447FF5];
        self.paihangView.labelleftname.text = self.carname;
        
        self.paihangView.seriseModelKB  = self.seriseModelKB;
        self.paihangView.seriseKB = self.seriseKB;
    }else{
        self.paihangView.carName.text = self.carname;
        self.paihangView.seriseModelKB  = self.seriseModelKB;
        self.paihangView.seriseKB = self.seriseKB;
    }
    
  
    
    if ([self.seriseModelKB isNotEmpty] ||[self.seriseKB isNotEmpty]) {
         [self.paihangView.selectListView reloadData];
    }
}


#pragma 口碑头条



#pragma 全部口碑
-(UIView *)tagView{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagView];
    }
    return _tagView;
}

//全部口碑的添加
-(void)buildUpView{
    if (!self.moreLeftLabel) {
        self.moreLeftLabel = [[UILabel alloc] init];
        self.moreLeftLabel.textColor = BlackColor333333;
        self.moreLeftLabel.font = FontOfSize(16);
        [self.upView addSubview:self.moreLeftLabel];
        [self.moreLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.upView.mas_top).offset(15);
            make.left.equalTo(self.upView.mas_left).offset(15);
        }];
    }
    
    if (!self.moreLeftCountLabel) {
        self.moreLeftCountLabel = [[UILabel alloc] init];
        self.moreLeftCountLabel.textColor = BlackColor999999;
        self.moreLeftCountLabel.font = FontOfSize(16);
        [self.upView addSubview:self.moreLeftCountLabel];
        [self.moreLeftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.moreLeftLabel);
            make.left.equalTo(self.moreLeftLabel.mas_right);
        }];
    }
    
    self.moreLeftLabel.text = @"全部口碑";
    self.moreLeftCountLabel.text = [NSString stringWithFormat:@"(%@条)",self.count];
}

//多行条数
-(void)buildTagView{
    [self updateView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self.upView.mas_bottom).offset(15);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

-(void)updateView{
    NSArray *arry = self.tags;
    if (arry.count>0) {
        [self setTagView:self.tagView titleArray:arry];
    }
}

- (void)setTagView:(UIView*)tagView titleArray:(NSArray *)titleArr{
    
    //第一个 label的起点
    CGSize size = CGSizeMake(10, 38);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat width = kwidth-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        RegTag *tag = self.tags[i];
        NSString *name = [NSString stringWithFormat:@"%@(%@)",tag.name,tag.num];
        
        CGFloat keyWorldWidth = [self getSizeByString:name AndFontSize:14].width+14;
        
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        
        if (width - size.width < keyWorldWidth) {
            size.height += 38.0;
            size.width = padding;
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
        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, 28);
        [tagView addSubview:button];
        
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
        
        button.titleLabel.numberOfLines = 0;
        
        
        
        if ([tag.sentiment_type isEqualToString:@"3"]) {
            [button setBackgroundColor:[UIColor colorWithString:@"0xf3f7ff"]];
            [button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
            
            button.titleLabel.font = FontOfSize(14);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            [button setBackgroundColor:[UIColor colorWithString:@"0xf8f8f8"]];
            [button setTitleColor:BlackColor888888 forState:UIControlStateNormal];
            
            button.titleLabel.font = FontOfSize(14);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        
        //        button.layer.cornerRadius = 3.0;
        //        button.layer.masksToBounds = YES;
        button.titleLabel.font = FontOfSize(14);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:name forState:UIControlStateNormal];
        
        button.tag = i;
        //起点 增加
        size.width += keyWorldWidth+padding;
    }
    
    self.tagView.height = size.height+10;
}
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 5;
    return size;
}

//全部口碑
-(UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_upView];
        
        if([self isNeedShowPaiHang]){
            [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.paihangView.mas_bottom);
                make.height.mas_equalTo(75/2);
            }];
        }else{
            [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.oldView.mas_bottom);
                make.height.mas_equalTo(75/2);
            }];
        }
    }
    return _upView;
}

//柱状数据列表
-(KouBeiPaiHangView *)paihangView{
    if (!_paihangView) {
        _paihangView = [[KouBeiPaiHangView alloc] initWithFrame:CGRectZero];
        [self addSubview:_paihangView];
        
        [_paihangView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.oldView);
            make.top.equalTo(self.oldView.mas_bottom);
            make.height.mas_equalTo(200);
        }];
        
        
    }
    return _paihangView;
}

#pragma 判断是否需要加载排行
//no 就是不需要显示
-(bool)isNeedShowPaiHang{
    
    if (![self.seriseKB isNotEmpty]) {
         return NO;
    }
    
    if (([self.seriseKB.kb_ck.score intValue] == 0)&&
        ([self.seriseKB.kb_dl.score intValue] == 0)&&
        ([self.seriseKB.kb_kj.score intValue] == 0)&&
        ([self.seriseKB.kb_wg.score intValue] == 0)&&
        ([self.seriseKB.kb_ssx.score intValue] == 0)&&
        ([self.seriseKB.kb_xjb.score intValue] == 0)) {
        return NO;
    }else{
        return YES;
    }
   
}

-(bool)isNeedShowModel{
    
    if (![self.seriseModelKB isNotEmpty]) {
        return NO;
    }
    
    if ( [self.seriseModelKB.kb_ck.score isEqualToString:@"0"]&&[self.seriseModelKB.kb_dl.score isEqualToString:@"0"]&&[self.seriseModelKB.kb_kj.score isEqualToString:@"0"]&&[self.seriseModelKB.kb_wg.score isEqualToString:@"0"]&&[self.seriseModelKB.kb_ssx.score isEqualToString:@"0"]&&[self.seriseModelKB.kb_xjb.score isEqualToString:@"0"]) {
        return NO;
    }else{
        return YES;
    }
    
}


@end
