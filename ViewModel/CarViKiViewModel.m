//
//  CarViKiViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/15.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarViKiViewModel.h"

@implementation CarViKiViewModel
-(void)loadSceneModel{
    
    [super loadSceneModel];
    @weakify(self);
    self.request = [CarViKiRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
      
        NSDictionary*dict = self.request.output;
        NSError*error;
        self.model = [[CarViKiModel alloc]initWithDictionary:self.request.output error:&error];
        if (error) {
            NSLog(@"%@", error.description);
        }

    }];
   }

@end
