//
//  PublicPraiseTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PublicPraiseTableViewCell.h"
@interface PublicPraiseTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badMessageContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *badMessageContentView;

@property (weak, nonatomic) IBOutlet UILabel *badComment;

@end
@implementation PublicPraiseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstImage.clipsToBounds = YES;
    self.secondImage.clipsToBounds = YES;
    self.thirdImage.clipsToBounds = YES;
    
    [self.userHead.layer setCornerRadius:self.userHead.frame.size.width / 2];
    self.userHead.layer.masksToBounds = YES;
    
    // Initialization code
}
-(void)setBadCommentString:(NSString *)badCommentString{
    
    if (badCommentString.length >0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;// 字体的行间距
        self.badComment.numberOfLines = 3;
        paragraphStyle.headIndent = 0;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:self.badComment.font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.badComment.attributedText = [[NSAttributedString alloc] initWithString:badCommentString attributes:attributes];
        self.badMessageContentViewHeightConstraint.priority = 100;
        self.badMessageContentView.hidden = NO;
    }else{
        self.badComment.text = @"";
        self.badMessageContentViewHeightConstraint.priority = 900;
         self.badMessageContentView.hidden = YES;
    }
    self.badComment.lineBreakMode =NSLineBreakByTruncatingTail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
