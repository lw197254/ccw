//
//  HaveSeeViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/29.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "HaveSeeViewModel.h"

@implementation HaveSeeViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [HaveSeeRequest RequestWithBlock:^{
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
