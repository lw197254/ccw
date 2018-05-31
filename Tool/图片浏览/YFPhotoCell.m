//
//  PhotoCell.m
//  
//
//  Created by Mr.Yan on 15/11/24.
//  Copyright (c) 2015年 JayWon. All rights reserved.
//

#import "YFPhotoCell.h"

@implementation YFPhotoCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _photoView = [[YFPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - kPhotoImageEdgeSize, CGRectGetHeight(self.frame))];
        [self.contentView addSubview:_photoView];
    }
    return self;
}

- (void)setPhoto:(YFPhoto *)photo{
    _photo = photo;
    _photoView.photo = _photo;
}
@end
