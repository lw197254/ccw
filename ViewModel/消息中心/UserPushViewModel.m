//
//  UserPushViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/10/27.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UserPushViewModel.h"

@implementation UserPushViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [UserPushCountRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.request.output;
          NSError*error;
      }];
}
@end
