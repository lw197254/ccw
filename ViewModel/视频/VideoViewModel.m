//
//  VideoViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoViewModel.h"

@implementation VideoViewModel
-(void)loadSceneModel{
    
    [super loadSceneModel];
    @weakify(self);
    self.listRequest = [VideoListRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.listRequest];
    }];
    
    self.labelRequest = [VideoLabelRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.labelRequest];
    }];

    
    [[RACObserve(self.listRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.listRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          NSDictionary *dic = self.listRequest.output;
          NSError*error;
          self.info = [[VideoListModel alloc]initWithDictionary:self.listRequest.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
    
    [[RACObserve(self.labelRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.labelRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
         NSDictionary *dic = self.labelRequest.output;
          NSError*error;
          self.labelinfo = [[VideoLabelListModel alloc]initWithDictionary:self.labelRequest.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}
@end
