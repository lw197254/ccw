//
//  ModifyMobileViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ModifyMobileViewModel.h"

@implementation ModifyMobileViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [ModifyMobileRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    self.checkMobileRequest = [CheckMobileRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.checkMobileRequest];
    }];

    self.codeRequest = [GetVerificationCodeRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.codeRequest];
    }];
    self.codeRequest.msgtype = msgTypeModifyMobile;
}
@end
