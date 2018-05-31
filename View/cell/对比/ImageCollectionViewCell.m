//
//  ImageCollectionViewCell.m
//  mvp
//
//  Created by 严琪 on 2017/7/26.
//  Copyright © 2017年 严琪. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "CompareCar.h"
#import "PhotoViewController.h"

@interface ImageCollectionViewCell()
@property(nonatomic,strong)CompareCar *car;
@end

@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imageView addShadow];
    
    [self.image setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageclick)];
    [self.image addGestureRecognizer:tapGesturRecognizer1];
    
    
    self.deleteimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_close_new"]];
    self.deleteimage.userInteractionEnabled = YES;
    [self addSubview:self.deleteimage];
    [self.deleteimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageView.mas_right).offset(3);
        make.top.equalTo(self.imageView.mas_top).offset(-4);
    }];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimageclick)];
    [self.deleteimage addGestureRecognizer:tapGesturRecognizer];
    
    
    self.smallImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_picture_small"]];
    [self.image addSubview:self.smallImage];
    [self.smallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.image.mas_right).offset(-4);
        make.bottom.equalTo(self.image.mas_bottom).offset(-4);
        make.height.with.mas_equalTo(9);
    }];
    
    [self.topDeleteButton addTarget:self action:@selector(deleteimageclick) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setBackgroundColor:[UIColor greenColor]];
}
- (IBAction)buttonClick:(id)sender {
    PhotoViewController *controller = [[PhotoViewController alloc] init];
    controller.carId =  self.car.car_id;
    controller.typeId = @"";
    
    controller.carName = self.car.car_name;
    controller.carType = self.car.cx_name;
    controller.carPrice = @"";
    [[Tool currentNavigationController] pushViewController:controller animated:YES];
}


-(void)setCarInfo:(CompareCar *)car{
    self.car = car;
    self.titlelabel.text = car.cx_name;
    self.sonTitle.text = car.car_name;
    
    [self.image setImageWithURL:[NSURL URLWithString:car.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片105_80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(void)imageclick{
    PhotoViewController *controller = [[PhotoViewController alloc] init];
    controller.carId =  self.car.car_id;
    controller.typeId = @"";
    
    controller.carName = self.car.car_name;
    controller.carType = self.car.cx_name;
    controller.carPrice = @"";
    [[Tool currentNavigationController] pushViewController:controller animated:YES];

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
