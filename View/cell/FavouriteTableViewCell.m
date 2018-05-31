//
//  FavourateTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FavouriteTableViewCell.h"
@interface FavouriteTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadToSuperView;

@end

@implementation FavouriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setShowSelectButton:(BOOL)showSelectButton{
    if (_showSelectButton!=showSelectButton) {
        _showSelectButton = showSelectButton;
        if (showSelectButton) {
            self.selectButton.hidden = NO;
            self.imageViewLeadToSuperView.priority = 750;
            [UIView animateWithDuration:0.25 animations:^{
                 [self layoutIfNeeded];
            }];
        }else{
             self.selectButton.hidden = YES;
            self.imageViewLeadToSuperView.priority = 900;
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
                
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
