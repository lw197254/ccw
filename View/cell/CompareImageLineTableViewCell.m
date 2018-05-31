//
//  CompareImageLineTableViewCell.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareImageLineTableViewCell.h"
#define width  (kwidth-15*2)
@implementation CompareImageLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.leftImageView.image = [[UIImage imageNamed:@"rectangleBlue"] stretchableImageWithLeftCapWidth:5 topCapHeight:2];
     self.rightImageView.image = [[UIImage imageNamed:@"rectangleOrange"] stretchableImageWithLeftCapWidth:25 topCapHeight:2];
 
    self.leftImageView.transform = CGAffineTransformMakeTranslation(-width, 0);
    self.rightImageView.transform = CGAffineTransformMakeTranslation(width, 0);
    
    // Initialization code
}
-(void)configWithData:(BOOL)isFirst index:(NSInteger)index{
    
    float i = index*1.0/20 ;
    float j = 1-i;
//    [self.leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self).multipliedBy(i);
//    }];
//    [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self).multipliedBy(j);
//    }];
    if (isFirst) {
        
        [UIView animateWithDuration:0.75 animations:^{
          
             self.leftImageView.transform = CGAffineTransformMakeTranslation(-width*(0.5-i)/2, 0);
             self.rightImageView.transform = CGAffineTransformMakeTranslation(width*(0.5-j)/2, 0);
            
            
        }];
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithData:(BOOL)isFirst float:(float)index{
    
    float i = index;
    float j = 1-i;
    //    [self.leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(self).multipliedBy(i);
    //    }];
    //    [self.rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(self).multipliedBy(j);
    //    }];
    if (isFirst) {
        
        [UIView animateWithDuration:0.75 animations:^{
            
            self.leftImageView.transform = CGAffineTransformMakeTranslation(-width*(0.5-i)/2, 0);
            self.rightImageView.transform = CGAffineTransformMakeTranslation(width*(0.5-j)/2, 0);
            
            
        }];
    }else{
        self.leftImageView.transform = CGAffineTransformMakeTranslation(-width*(0.5-i)/2, 0);
        self.rightImageView.transform = CGAffineTransformMakeTranslation(width*(0.5-j)/2, 0);
    }
    
    
}

@end
