//
//  CityNewViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/15.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CityNewViewModel.h"

@implementation CityNewViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [CityNewRequest RequestWithBlock:^{
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
          
          NSArray*info = [self.request.output valueForKeyPath:@"data.info"];
          
         
          if (info.count > 0) {
              [self.request.output[@"data"] writeToFile:self.request.cacheURL atomically:YES];
              self.model = [[ProvinceListNewModel alloc]initWithDictionary:self.request.output[@"data"] error:nil];
          }
          
         
          
          
          
      }];
}
-(ProvinceListNewModel*)model{
    if (!_model) {
          NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:self.request.cacheURL];
        _model = [[ProvinceListNewModel alloc]initWithDictionary:dict error:nil];
    }
    return _model;
}
@end
