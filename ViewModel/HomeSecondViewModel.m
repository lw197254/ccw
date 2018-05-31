//
//  HomeSecondViewModel.m
//  chechengwang
//
//  Created by 严琪 on 16/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "HomeSecondViewModel.h"

@implementation HomeSecondViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [HomelistSecondRequest RequestWithBlock:^{
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
          self.data = [[HomeModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          NSString*path = self.request.cacheURL;
          [self.request.output writeToFile:path atomically:YES];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}
-(HomeModel*)data{
    if (!_data) {
        NSString*path = self.request.cacheURL;
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict.isNotEmpty) {
            _data = [[HomeModel alloc]initWithDictionary:dict[@"data"] error:nil];
        }
        
    }
    return _data;
}


@end
