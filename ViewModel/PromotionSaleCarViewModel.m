//
//  PromotionSaleCarViewModel.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionSaleCarViewModel.h"

@implementation PromotionSaleCarViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [PromotionSaleCarsRequest RequestWithBlock:^{
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
          self.data = [[PromotionListModel alloc]initWithDictionary:self.request.output error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
