//
//  RelateCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "RelateCarTableViewCell.h"

@interface RelateCarTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadToSuperView;
@property (weak, nonatomic) IBOutlet UIView *content;
@end
@implementation RelateCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.content.transform = CGAffineTransformMakeTranslation(-32, 0);
    // Initialization code
}

-(void)setShowSelectButton:(BOOL)showSelectButton{
    if (_showSelectButton!=showSelectButton) {
        _showSelectButton = showSelectButton;
        if (showSelectButton) {
            //            self.selectButton.hidden = NO;
            //            self.imageViewLeadToSuperView.priority = 700;
            [UIView animateWithDuration:0.25 animations:^{
                self.content.transform = CGAffineTransformIdentity;
                
            }];
        }else{
            //            self.selectButton.hidden = YES;
            //            self.imageViewLeadToSuperView.priority = 900;
            [UIView animateWithDuration:0.25 animations:^{
                self.content.transform = CGAffineTransformMakeTranslation(-32, 0);
            }];
            
        }
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectButton.selected = selected;
    
    // Configure the view for the selected state
}

@end
