//
//  UserCollectionDeleteViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UserCollectionDeleteViewModel.h"

@implementation UserCollectionDeleteViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [UserCollectionDeleteRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
//    [[RACObserve(self.request, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          if (self.request.succeed) {
//              return self.request.succeed;
//          }
//          return self.request.failed;
//      }]subscribeNext:^(id x) {
//          @strongify(self);
//          NSDictionary*dict = self.request.output;
//          NSError*error;
//          
//          self.msg = dict[@"msg"];
//          
//          if (error) {
//              NSLog(@"%@", error.description);
//          }
//          
//          
//      }];
}
@end
