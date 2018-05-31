//
//  UserInfoViewModel.m
//  12123
//
//  Created by 琪琪雪雪 on 16/10/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "UserInfoViewModel.h"

@implementation UserInfoViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [UpdateUserInfoRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
   
    self.uploadHeadImageRequest = [UploadHeadImageRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.uploadHeadImageRequest];
    }];
    
   }

@end
