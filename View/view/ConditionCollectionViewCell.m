//
//  ConditionCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/23.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ConditionCollectionViewCell.h"
#import "ConditionModel.h"


#define leftPadding 10
#define rightPadding 10
#define minWith 72

@interface ConditionCollectionViewCell()

@property(nonatomic,strong) NSMutableArray *titleArray;

@property(nonatomic,assign) NSInteger cellTag;

@end
@implementation ConditionCollectionViewCell


-(void)rebuildArray:(NSArray *)titleArr title:(NSString *)title tag:(NSInteger) tag{
    self.titleArray  = [[NSMutableArray alloc]initWithCapacity: (1+titleArr.count)];
    [self.titleArray addObject:title];
     for (int i = 0; i < titleArr.count; i ++) {
         [self.titleArray addObject:titleArr[i][@"value"]];
     }
    
    self.cellTag = tag;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setTagViewtitleArray:self.titleArray];
}

-(void)rebuildArray:(NSArray *)titleArr title:(NSString *)title{
    self.titleArray  = [[NSMutableArray alloc]initWithCapacity: (1+titleArr.count)];
    [self.titleArray addObject:title];
    for (int i = 0; i < titleArr.count; i ++) {
        [self.titleArray addObject:titleArr[i][@"value"]];
    }
    [self setTagViewtitleArrayReturnHeight:self.titleArray];
}

-(void)setTagViewtitleArrayReturnHeight:(NSArray *)titleArr{
    //第一个 label的起点
    CGSize size = CGSizeMake(14, 38+10);
    //间距
    CGFloat padding = 14.0;
    
    CGFloat width = kwidth-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i] AndFontSize:14].width+14;
        
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 38.0+10;
            size.width =padding+50+padding;
        }
        
        if (width - size.width < rightPadding) {
            size.height += 38.0;
            size.width = padding;
        }
        
        if (i==0) {
            keyWorldWidth = 50;
        }else{
            if (keyWorldWidth<minWith) {
                keyWorldWidth = minWith;
            }
            
        }
        size.width += keyWorldWidth+padding;
    }
    
    self.cellheight = size.height;
}


-(void)setTagViewtitleArray:(NSArray *)titleArr{
    //第一个 label的起点
    CGSize size = CGSizeMake(14, 38+10);
    //间距
    CGFloat padding = 14.0;
    
    CGFloat width = kwidth-(leftPadding+rightPadding);
    
    for (int i = 0; i < titleArr.count; i ++) {
        
        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i] AndFontSize:14].width+14;
        
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 38.0+10;
            size.width =padding+50+padding;
        }
        
        if (width - size.width < rightPadding) {
            size.height += 38.0;
            size.width = padding;
        }
        
        if (i==0) {
            keyWorldWidth = 50;
        }else{
            if (keyWorldWidth<minWith) {
                keyWorldWidth = minWith;
            }
        
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, 34);
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(size.width);
            make.top.equalTo(self).with.offset(size.height-38);
            make.size.mas_equalTo(CGSizeMake(keyWorldWidth, 34));
//            if (i==titleArr.count-1) {
//                UIView*view =[[UIView alloc]init];
//                [self addSubview:view];
//                [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(self);
//                    make.top.equalTo(button.mas_bottom);
//                    make.bottom.equalTo(self);
//                    make.height.mas_equalTo(1).priority(3);
//
//                }];
//            }
            
        }];
        
        button.titleLabel.numberOfLines = 0;
        
        if (i==0) {
            [button setBackgroundColor:[UIColor colorWithString:@"0xf8f8f8"]];
            [button setTitleColor:BlackColor888888 forState:UIControlStateNormal];
            button.titleLabel.font = FontOfSize(13);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
        }else{
        
        button.layer.borderWidth =0.5;
        button.layer.borderColor = [UIColor colorWithString:@"0xe9e9e9"].CGColor;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:BlackColor555555 forState:UIControlStateNormal];
        
        //        button.layer.cornerRadius = 3.0;
        //        button.layer.masksToBounds = YES;
        button.titleLabel.font = FontOfSize(13);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
            
        [button setTitleColor:BlueColor447FF5 forState:UIControlStateSelected];
 
            
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.selectedArray enumerateObjectsUsingBlock:^(ConditionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.value isEqualToString:titleArr[i]]) {
                [button setSelected:YES];
                *stop = YES;
            }
        }];
        
        button.tag = self.cellTag;
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

-(void)buttonClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        button.layer.borderWidth =0.5;
        button.layer.borderColor = BlueColor447FF5.CGColor;
        
        if (self.block) {
            self.block(button.titleLabel.text,button.selected,button.tag);
        }
        
    }else{
        button.layer.borderWidth =0.5;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        if (self.block) {
            self.block(button.titleLabel.text,button.selected,button.tag);
        }
    }
}

@end
