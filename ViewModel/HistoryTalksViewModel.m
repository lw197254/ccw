//
//  HistoryTalksViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/18.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "HistoryTalksViewModel.h"
@implementation HistoryTalksViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [TalksHistoryRequest RequestWithBlock:^{
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
          self.data = [[CommiteListModel alloc]initWithDictionary:self.request.output error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}


@end
