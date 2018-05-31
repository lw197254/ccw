//
//  XiHaoClickViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "XiHaoClickViewModel.h"

@implementation XiHaoClickViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [XiHaoClickRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}
@end
