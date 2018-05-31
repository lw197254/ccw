//
//  ActiveViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ActiveViewModel.h"

@implementation ActiveViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [ActiveCommitCityRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
   }

@end
