//
//  DeliverData.m
//  chechengwang
//
//  Created by 严琪 on 2017/4/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DeliverData.h"

static NSString *ISFIND= @"1";
static NSString *NOTFIND= @"0";

static NSString *p =@"p";
static NSString *s =@"strong";
 

@implementation DeliverData


-(void)setinfo:(NSMutableArray<InfoContentModel> *)infos matches:(NSMutableArray<MatchModel> *)matcharray{
    
    
    for (InfoContentModel *model in infos) {
        if ([model.type isEqualToString:p]||[model.type isEqualToString:s]){
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4;// 字体的行间距
            paragraphStyle.headIndent = 0;
            paragraphStyle.alignment = NSTextAlignmentJustified;
            
            NSDictionary *attributes = @{NSForegroundColorAttributeName:BlackColor333333,
                                         
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:model.value attributes:attributes];
            
            [self buildOwn:model.value mutilinfo:attStr matcharray:matcharray];
            
            model.valueString = attStr;
            
        }
    }
   //    self.textview.attributedText =attStr;
}

-(void)buildOwn:(NSString *)info mutilinfo:(NSMutableAttributedString *)attStr matcharray:(NSMutableArray<MatchModel> *)matcharray{
    
    if (matcharray.count == 0) {
        return;
    }
    NSArray*array = [NSArray arrayWithArray: matcharray];
    for (MatchModel *m in array) {
        
        if ([m.isfind isEqualToString:ISFIND]) {
            continue;
        }
        
        NSRange range = [info rangeOfString:m.str];
        
        if (range.location == NSNotFound) {
            continue;
        }else{
            NSString *caridUrl = [NSString stringWithFormat:@"click://%@",m.id];
            [attStr addAttribute:NSLinkAttributeName value:caridUrl range:range];
            m.isfind = ISFIND;
        }
    }
}


///多次循环的方法
-(void)build:(NSInteger) location info:(NSString *)info m:(NSString *)m mutilinfo:(NSMutableAttributedString *)attStr{
    
    NSInteger declocation = location+m.length;
    if (declocation < info.length) {
        NSRange range = NSMakeRange(declocation, info.length-declocation);
        NSRange rang = [info rangeOfString:m options:NSCaseInsensitiveSearch range:range];
        if (rang.location == NSNotFound) {
            return ;
        }else{
            [attStr addAttribute:NSLinkAttributeName value:@"click://" range:rang];
            [self build:rang.location info:info m:m mutilinfo:attStr];
        }
    }
}

@end
