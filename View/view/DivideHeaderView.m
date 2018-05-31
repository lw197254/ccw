//
//  DivideHeaderView.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "DivideHeaderView.h"
#import "FindCarHeaderWithButton.h"

@implementation DivideHeaderView



-(void)reloadData{
    
    NSInteger i = [self.dataDelegate numOfViews];
    
    float each_with = kwidth/i;
    
    for (int m = 0; m<i; m++) {
        UIView *view = [self.delegate buildViewbuildViewForItemWithIndex:m];
        view.frame = CGRectMake(0+each_with*m, 0, each_with, 90);
        view.tag = m;
        [self addSubview:view];
    }
}

@end
