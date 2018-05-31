//
//  PhotoMenuViewModel.m
//  chechengwang
//
//  Created by 严琪 on 17/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoMenuViewModel.h"

@implementation PhotoMenuViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [PhotoMenuRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    
    NSString*path =   [[NSBundle mainBundle]pathForResource:@"photoMenuList" ofType:@"plist"];
    NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
   self.data = [[PicMenuBaseModel alloc]initWithDictionary:dict error:nil];
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.request.output;
          NSError*error;
        self.data = [[PicMenuBaseModel alloc]initWithDictionary:self.request.output error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
}

@end
