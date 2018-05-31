//
//  RegionClikcViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "RegionClickViewModel.h"

@implementation RegionClickViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [RegionClickRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}

@end
