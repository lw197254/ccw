//
//  getUserPushDynamicViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/31.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "GetUserPushDynamicViewModel.h"
@implementation GetUserPushDynamicViewModel


-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [CheckMyDynamic RequestWithBlock:^{
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
          
          self.count = self.request.output[@"data"];
          
      }];
}

@end
