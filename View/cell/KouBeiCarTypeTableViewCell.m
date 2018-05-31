//
//  KouBeiCarTypeTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/1/18.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "KouBeiCarTypeTableViewCell.h"


@interface KouBeiCarTypeTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *content;
@end
@implementation KouBeiCarTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.content.transform = CGAffineTransformMakeTranslation(-32, 0);
    // Initialization code
    [self setBottomLine];
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
