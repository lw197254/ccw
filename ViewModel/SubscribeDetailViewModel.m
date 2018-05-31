//
//  SubscribeDetailViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SubscribeDetailViewModel.h"


@implementation SubscribeDetailViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    self.showList = [NSMutableArray<SubscribeDetailArticleModel*> array];
    @weakify(self);
    self.request = [SubscribeDetailRequest RequestWithBlock:^{
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
          SubscribeDetailModel*model = [[SubscribeDetailModel alloc]initWithDictionary:self.request.output[@"data"] error:nil];
          if (self.request.page==1) {
              [self.showList removeAllObjects];
          }
       self.showList = [self success:self.showList newArray:model.list currentPage:self.request.page initPage:1];
          self.showList = [self.deliverModel deliverSubscribeDetailArticleMode:self.showList];
          self.request.page++;
          self.model = model;
      }];
}

@end
