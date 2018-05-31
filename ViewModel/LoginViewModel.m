//
//  LoginViewModel.m
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/23.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.loginRequest = [LoginRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.loginRequest];
    }];
    

    [[RACObserve(self.loginRequest, state)
    filter:^BOOL(id value) {
         @strongify(self);
        return self.loginRequest.succeed;
    }]
    subscribeNext:^(id x) {
         @strongify(self);
        NSDictionary*dict = [self.loginRequest.output valueForKey:@"data"];
        if (dict!=nil) {
            [[UserModel shareInstance]mergeFromDictionary:dict useKeyMapping:YES];
        }
    }];
    self.thirdLoginRequest = [ThirdLoginRequest RequestWithBlock:^{
        @strongify(self);
        
        [self SEND_ACTION:self.thirdLoginRequest];
    }];
    self.userInfoRequest = [UserInfoRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.userInfoRequest];
    }];
   
   }

@end
