//
//  HomeMenuViewModel.m
//  chechengwang
//
//  Created by 严琪 on 16/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "HomeMenuViewModel.h"

@implementation HomeMenuViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [HomeMenuRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_CACHE_ACTION:self.request];
    }];
    self.launchSreenRequest = [LaunchSreenRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_CACHE_ACTION:self.launchSreenRequest];
    }];
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          NSError*error;
          self.data = [[HomeMenuModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          
        
          
          if (!error) {
              NSString*path = self.request.cacheURL;
              [self.request.output writeToFile:path atomically:YES];
             
          }
      }];

    [[RACObserve(self.launchSreenRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.launchSreenRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.launchSreenRequest.output;
          if (dict.isNotEmpty) {
               NSDictionary*dic =dict[@"data"];
              if (dic.isNotEmpty) {
                   [[NSUserDefaults standardUserDefaults]setObject:dict[@"data"] forKey:launchScreenImage];
              }else{
                  [[NSUserDefaults standardUserDefaults]removeObjectForKey:launchScreenImage];
              }
          }
         
          
         
          
                }];
}
-(HomeMenuModel*)data{
    if (!_data) {
        NSString*path = self.request.cacheURL;
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict.isNotEmpty) {
            _data = [[HomeMenuModel alloc]initWithDictionary:dict[@"data"] error:nil];
        }
        
    }
    return _data;
}
@end
