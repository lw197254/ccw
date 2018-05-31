//
//  InfoViewModel.m
//  chechengwang
//
//  Created by 严琪 on 16/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "InfoViewModel.h"

@implementation InfoViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [InfoDetailRequest RequestWithBlock:^{
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
          self.data = [[InfoBaseModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
