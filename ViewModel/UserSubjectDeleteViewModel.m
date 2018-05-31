//
//  UserSubjectDeleteViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UserSubjectDeleteViewModel.h"

@implementation UserSubjectDeleteViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [UserSubjectDeleteRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
}


@end
