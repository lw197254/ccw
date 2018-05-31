//
//  FindCarByGroupGetCarListViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FindCarByGroupGetCarListViewModel.h"

@implementation FindCarByGroupGetCarListViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [FindCarByGroupGetCarListRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        self.model = [[FindCarByGroupGetCarListModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
        
    }];

}
@end
