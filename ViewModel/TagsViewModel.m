//
//  TagsViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TagsViewModel.h"

@implementation TagsViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [TagsRequest RequestWithBlock:^{
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
          self.data = [[TagsListModel alloc]initWithDictionary:self.request.output error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
