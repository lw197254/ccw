//
//  ViewLineCollectionCollectionReusableView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ViewLineCollectionCollectionReusableView.h"

@interface ViewLineCollectionCollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel *uilabel;


@end

@implementation ViewLineCollectionCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setViewColor:(UIColor *)color{
    [self.uilabel setHidden:YES];
    [self setBackgroundColor:color];
}
@end
