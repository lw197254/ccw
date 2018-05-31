//
//  CoBuBViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/7/10.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CoBuBViewModel.h"

@implementation CoBuBViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [CoBubRequest RequestWithBlock:^{
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
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
    
}

@end
