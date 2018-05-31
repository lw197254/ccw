//
//  DealerDetailViewModel.m
//  chechengwang
//
//  Created by 严琪 on 17/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerDetailViewModel.h"

@implementation DealerDetailViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [DealerDetailRequest RequestWithBlock:^{
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
          self.data = [[DealerDetailModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
