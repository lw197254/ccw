//
//  VideoDetailViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "VideoDetailViewModel.h"

@implementation VideoDetailViewModel

-(void)loadSceneModel{
    
    [super loadSceneModel];
    @weakify(self);
    self.request = [VideoDetailRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    
    self.videoCommentrequest = [CommiteListRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.videoCommentrequest];
    }];
    
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          NSDictionary *dic = self.request.output;
          NSError*error;
          self.data = [[VideoDetailModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
    
    [[RACObserve(self.videoCommentrequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.videoCommentrequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          NSDictionary *dic = self.videoCommentrequest.output;
          NSError*error;
          self.list = [[CommiteListModel alloc]initWithDictionary:self.videoCommentrequest.output[@"data"] error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
