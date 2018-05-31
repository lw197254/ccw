//
//  TitleCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/23.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TitleCompareCollectionViewCell.h"
#import "CompareCar.h"

@implementation TitleCompareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self.imageView addShadow];
    
    self.deleteimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_close_new"]];
    self.deleteimage.userInteractionEnabled = YES;
    [self addSubview:self.deleteimage];
    [self.deleteimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageView.mas_right).offset(3);
        make.top.equalTo(self.imageView.mas_top).offset(-4);
    }];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimageclick)];
    [self.deleteimage addGestureRecognizer:tapGesturRecognizer];
}

-(void)setCarInfo:(CompareCar *)car{
    self.titlelabel.text = car.cx_name;
    self.sonTitle.text = car.car_name;
}

-(void)deleteimageclick{
    NSLog(@"点击到了deleteimage");
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.width);
    } completion:^(BOOL finished) {
        [self.deleteButton  sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        self.transform = CGAffineTransformIdentity;
    }];
}


@end
