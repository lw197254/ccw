//
//  NotificationViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/7/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NotificationViewModel.h"

@implementation NotificationViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [NotificationRequest RequestWithBlock:^{
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
          self.data = [[NotificationModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
