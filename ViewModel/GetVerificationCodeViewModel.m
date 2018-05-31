//
//  GetVerificationCodeViewModel.m
//  TMC_convenientTravel
//
//  Created by Mr.Yan on 16/5/21.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "GetVerificationCodeViewModel.h"

@implementation GetVerificationCodeViewModel
-(void)loadSceneModel
{
    [super loadSceneModel];
    @weakify(self);
    self.codeRequest = [GetVerificationCodeRequest RequestWithBlock:^{
        @strongify(self);
       
        [self SEND_ACTION:self.codeRequest];
    }];
     self.codeRequest.msgtype = msgTypeFindPasswordBack;
    self.passwordRequest = [ForgetPasswordRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.passwordRequest];
    }];
    self.checkCodeRequest = [CheckcodeRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.checkCodeRequest];
    }];
    
    self.checkCodeRequest.msgtype = msgTypeFindPasswordBack;
}
@end
