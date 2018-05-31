//
//  FastLoginCodeViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/2.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FastLoginCodeViewModel.h"

@implementation FastLoginCodeViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [FastLoginCodeRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}

@end
