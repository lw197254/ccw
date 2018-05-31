//
//  XiHaoUserCheckTagsViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "XiHaoUserCheckTagsViewModel.h"

@implementation XiHaoUserCheckTagsViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [XiHaoUserCheckTagsRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}
@end
