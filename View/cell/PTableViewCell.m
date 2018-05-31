//
//  PTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PTableViewCell.h"
#import "InfoDetailFont.h"
#import "PYSearchViewController.h"
#import "CustomNavigationController.h"
#import "CarDeptViewController.h"


@interface PTableViewCell()

@property(nonatomic,strong)NSMutableArray<MatchModel> *matchmodels;



@end

@implementation PTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.content.hidden = YES;
    
//    self.textview.editable = NO;//必须禁止输入，否则点击将弹出输入键盘
//    self.textview.scrollEnabled = NO;
//    self.textview.selectable = YES;
    self.textview.textColor = BlackColor474747;
    self.textview.delegate = self;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMatch:(NSMutableArray<MatchModel> *)matches{
    self.matchmodels = matches;
}

-(void)setinfo:(InfoContentModel *)info{
    ///当前界面的字体大小
    
    double pointSize = [InfoDetailFont shareInstance].fontSize;
    if (pointSize!=0) {
        self.textview.font = FontOfSize(pointSize);
    }else{
        self.textview.font = FontOfSize(18);
    }

    if (info.valueString.isNotEmpty) {
        NSMutableAttributedString*attrbute = [[NSMutableAttributedString alloc]initWithAttributedString:info.valueString];
       
        [attrbute addAttribute:NSFontAttributeName value:self.textview.font range:NSMakeRange(0, info.valueString.length)];
        
        self.textview.linkAttributes = @{nsStringWithCfString(kCTForegroundColorAttributeName) : BlueColor447FF5,
                                         nsStringWithCfString(kCTUnderlineStyleAttributeName) : [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        
        // 点击时候的样式
        self.textview.activeLinkAttributes = @{nsStringWithCfString(kCTForegroundColorAttributeName) : BlueColor447FF5,
                                            nsStringWithCfString(kCTUnderlineStyleAttributeName)  : [NSNumber numberWithInt:kCTUnderlineStyleNone]};
       self.textview.text = attrbute;
    }else{
        self.textview.text = info.value;
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
//        NSString *carid;
    
        if ([[url scheme] isEqualToString:@"click"]) {
            
            NSString *urlString = [url absoluteString];
            NSScanner *scanner = [NSScanner scannerWithString:urlString];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
            int number;
            [scanner scanInt:&number];

            NSString *carid = [NSString stringWithFormat:@"%d",number];
//
//            for (MatchModel *model in self.matchmodels) {
//                if ([model.str isEqualToString:]) {
//                    carid = model.id;
//                }
//            }


            CarDeptViewController *vc = [[CarDeptViewController alloc] init];
            vc.chexiid = carid;

            [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];


        }
    NSLog(@"点击");
  
}


/**
 *  将CFString转换为NSString
 *
 *  @param cfString
 *
 *  @return 转换后的CFString
 */
static inline NSString*  nsStringWithCfString(CFStringRef cfString) {
    return (__bridge NSString *)cfString;
}


//-(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
//     NSLog(@"点击了方法");
//    return YES;
//}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
//    NSString *carid;
//
//    if ([[URL scheme] isEqualToString:@"click"]) {
//        NSString *keyword = [textView.text substringWithRange:characterRange];
//
//
//        for (MatchModel *model in self.matchmodels) {
//            if ([model.str isEqualToString:keyword]) {
//                carid = model.id;
//            }
//        }
//
//
//        CarDeptViewController *vc = [[CarDeptViewController alloc] init];
//        vc.chexiid = carid;
//
//        [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
//
//        return NO;
//    }
//
//
//    return YES;
//}
//
//
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
//
//    NSString *carid;
//
//    if ([[URL scheme] isEqualToString:@"click"]) {
//        NSString *keyword = [textView.text substringWithRange:characterRange];
//
//
//        for (MatchModel *model in self.matchmodels) {
//            if ([model.str isEqualToString:keyword]) {
//                carid = model.id;
//            }
//        }
//
//
//        CarDeptViewController *vc = [[CarDeptViewController alloc] init];
//        vc.chexiid = carid;
//
//        [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
//        return NO;
//    }
//
//
//    return YES;
//}
//
//
//-(NSMutableArray<MatchModel> *)matchmodels{
//    if (!_matchmodels) {
//        _matchmodels = [NSMutableArray arrayWithCapacity:4];
//    }
//    return _matchmodels;
//}
//


@end
