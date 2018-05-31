//
//  DealerViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerViewModel.h"

@implementation DealerViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [DealerRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
         @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
         @strongify(self);
        NSDictionary *dit = self.request.output;
        
        DealerListModel*model = [[DealerListModel alloc]initWithDictionary:self.request.output[@"data"] error:nil];
        
        self.model = model;
        
 
    }];
}
@end
