//
//  ReBackViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ReBackViewModel.h"

@implementation ReBackViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [ReBackrRequest RequestWithBlock:^{
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
          self.data = [[CommiteListModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}


@end
