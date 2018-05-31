//
//  CarDeptTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/2/24.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarDeptTableViewHeaderFooterView.h"



#define leftPadding 10
#define rightPadding 10
#define minWith 80

@implementation CarDeptTableViewHeaderFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self buildUpView];
        [self buildTagView];
        [self buildDownView];
    }
    return self;
}

-(UIView *)upView{
    if (!_upView) {
        _upView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_upView];
        
        [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(75/2);
        }];
    }
    return _upView;
}

-(void)buildUpView{
    self.moreRightLabel = [[UILabel alloc] init];
    
    self.moreRightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头向右"]];
 
    self.moreRightLabel.textColor = BlackColor999999;
    self.moreRightLabel.font = FontOfSize(13);
    self.moreRightLabel.text = @"更多";
 
 
    [self.upView addSubview:self.moreRightLabel];
    [self.upView addSubview:self.moreRightImage];
    [self.moreRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView);
        make.right.equalTo(self.upView.mas_right).offset(-15);
    }];
    
    [self.moreRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView);
        make.right.equalTo(self.moreRightImage.mas_left).offset(5);
    }];


    self.moreLeftLabel = [[UILabel alloc] init];
    self.moreLeftLabel.text = @"车友点评";
    self.moreLeftLabel.font = FontOfSize(16);
    self.moreLeftLabel.textColor = BlackColor333333;
    [self.upView addSubview:self.moreLeftLabel];
    [self.moreLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView);
        make.left.equalTo(self.upView.mas_left).offset(15);
    }];
}
#pragma 中间界面

-(UIView *)tagView{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagView];
    }
    return _tagView;
}

-(void)buildTagView{
    [self updateView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.top.equalTo(self.upView.mas_bottom);
        make.bottom.equalTo(self.downView.mas_top);
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
    CGSize size = CGSizeMake(15, 38);
    //间距
    CGFloat padding =10.0;
    
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
            size.width = 15.0;
        }
        
        if (width - size.width < rightPadding) {
            size.height += 38.0;
            size.width = 15.0;
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
        
        [button setTitle:name forState:UIControlStateNormal];
        
        button.tag = i;
        //起点 增加
        size.width += keyWorldWidth+padding;
    }
    
    self.tagView.height = size.height;
}
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.width += 5;
    return size;
}



#pragma 在售停售的界面
-(UIView *)downView{
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_downView];
        
        [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(75/2);
        }];

    }
    return _downView;
}

-(void)buildDownView{
    self.image= [[UIImageView alloc] init];
    [self.downView addSubview:self.image];
    
    self.label = [[UILabel alloc] init];
    [self.downView addSubview:self.label];
    
    
    self.secondLabel = [[UILabel alloc] init];
    [self.downView addSubview:self.secondLabel];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.downView);
        make.left.equalTo(self.downView).offset(15);
        make.width.mas_equalTo(2);
    }];
    
    [self.image setBackgroundColor:BlueColor447FF5 ];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView);
        make.left.equalTo(self.image).offset(10);
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView);
        make.left.equalTo(self.label).offset(50);
    }];
    
    @weakify(self);
    [RACObserve(self,noimage)
     subscribeNext:^(NSString* x){
         @strongify(self);
         if(self.noimage){
             [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.centerY.equalTo(self.downView);
                 make.left.equalTo(self.downView).offset(15);
             }];
         }else{
             [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.centerY.equalTo(self.downView);
                 make.left.equalTo(self.image).offset(10);
             }];
         }
     }];
    
    [self setTopLine];
    
    
    //颜色按钮
    self.label1 = [[UILabel alloc]init];
    [self.label1 setBackgroundColor:BlueColor447FF5];
    
    [self.downView addSubview:self.label1];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.downView.mas_bottom);
        make.height.mas_equalTo(2);
        make.leading.trailing.equalTo(self.label);
    }];
    
    self.label2 = [[UILabel alloc]init];
    [self.label2 setBackgroundColor:BlueColor447FF5];
    
    [self.downView addSubview:self.label2];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.downView.mas_bottom);
        make.height.mas_equalTo(2);
        make.leading.trailing.equalTo(self.secondLabel);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
