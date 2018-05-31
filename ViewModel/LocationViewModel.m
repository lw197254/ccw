//
//  LocationViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/2.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "LocationViewModel.h"

@implementation LocationViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    
    @weakify(self);
    self.request = [GetCityIdRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
         
          self.cityId = self.request.output[@"data"][@"cityId"] ;
}];
}

@end
