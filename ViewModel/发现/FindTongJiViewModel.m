//
//  FindTongJiViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FindTongJiViewModel.h"

@implementation FindTongJiViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [FindTongJiRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}
@end
