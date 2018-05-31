//
//  CarTypeDetailViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CarTypeDetailViewModel.h"

@implementation CarTypeDetailViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [CarTypeRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model = [[CarTypeDetailModel alloc]initWithDictionary:self.request.output[@"data"] error:nil];
    }];
}

@end
