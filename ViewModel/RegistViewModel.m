//
//  RegistViewModel.m
//  12123
//
//  Created by 刘伟 on 2016/9/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "RegistViewModel.h"

@implementation RegistViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.checkMobileRequest = [CheckMobileRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.checkMobileRequest];
    }];
    
    self.registRequest = [RegistRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.registRequest];
    }];
    self.codeRequest = [GetVerificationCodeRequest RequestWithBlock:^{
       @strongify(self);
        [self SEND_ACTION:self.codeRequest];
    }];
     self.codeRequest.msgtype = msgTypeRegist;
   
    self.userInfoRequest = [UserInfoRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.userInfoRequest];
    }];
}
@end
