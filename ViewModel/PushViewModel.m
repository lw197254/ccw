//
//  PushViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "PushViewModel.h"

@implementation PushViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.pushLogReqeust = [PushLogReqeust RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.pushLogReqeust];
    }];
    [[RACObserve(self.pushLogReqeust, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.pushLogReqeust.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.pushLogReqeust.output;
          NSError*error;
      }];
    
    self.pushUpdateDeviceRequest = [PushUpdateDeviceRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.pushUpdateDeviceRequest];
    }];

    [[RACObserve(self.pushUpdateDeviceRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.pushUpdateDeviceRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.pushUpdateDeviceRequest.output;
          NSError*error;
      }];
    [[RACSignal combineLatest:@[RACObserve([UserModel shareInstance], uid),RACObserve(self.pushUpdateDeviceRequest,token)] reduce:^(NSString*uid,NSString*token){
        @strongify(self);
        BOOL uidChange = NO;
        //请求的uid不为空时，uid变为空           /第一次uid为空时发送请求，
        if (![self.pushUpdateDeviceRequest.uid isEqualToString:uid]||!self.pushUpdateDeviceRequest.uid.isNotEmpty) {
            if (uid.isNotEmpty) {
                self.pushUpdateDeviceRequest.uid = uid;
            }else{
                self.pushUpdateDeviceRequest.uid = @"0";
            }
            
            uidChange = YES;
        }
        
        return @(token.isNotEmpty&&uidChange);
        
    }]subscribeNext:^(NSNumber* x) {
        @strongify(self);
        if (x.boolValue) {
            self.pushUpdateDeviceRequest.startRequest = YES;
        }
    }];

}

@end
