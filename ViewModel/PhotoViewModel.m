//
//  PhotoViewModel.m
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoViewModel.h"


@implementation PhotoViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [PhotoRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    self.modelDict = [NSMutableDictionary dictionary];
   }

@end
