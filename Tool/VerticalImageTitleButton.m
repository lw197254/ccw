//
//  UIButton+ImagaAndTitle.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VerticalImageTitleButton.h"

@interface VerticalImageTitleButton()


@end

@implementation VerticalImageTitleButton

-(void)layoutSubviews{
    [super layoutSubviews];
//    CGFloat height = self.bounds.size.height;
//    CGSize titlesize = [self.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    CGSize imagesize = [self.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    self.titleEdgeInsets = UIEdgeInsetsMake((height-titlesize.height)/2, -imagesize.width/2, -(height-titlesize.height)/2, imagesize.width/2);
//    self.imageEdgeInsets = UIEdgeInsetsMake(-(height-imagesize.height)/2, (imagesize.width+titlesize.width)/2-imagesize.width/2, (height-imagesize.height)/2, -titlesize.width/2);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat height =  ((NSInteger)self.titleLabel.font.pointSize)/5 +((((NSInteger)self.titleLabel.font.pointSize)%5)>2?0.5:0) +self.titleLabel.font.pointSize;
    CGFloat titleHeight = 30;
    CGFloat imageWidth = MIN(contentRect.size.height - titleHeight, contentRect.size.width);
    return CGRectMake(contentRect.size.width/2 - imageWidth/2, 0, imageWidth, imageWidth);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
     CGFloat titleHeight = 30;
    return CGRectMake(0, contentRect.size.height-titleHeight, contentRect.size.width, titleHeight);
}
@end
