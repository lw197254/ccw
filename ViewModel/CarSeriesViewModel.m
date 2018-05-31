//
//  CarSeriesViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/29.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "CarSeriesViewModel.h"

@implementation CarSeriesViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
   @weakify(self);
    self.request = [CarSeriesRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state) filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model = [[CarSeriesListModel alloc]initWithDictionary:self.request.output error:nil];
    }];
    self.factoryRequest = [CarSeriesListWithfactoryRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.factoryRequest];
    }];
    [[RACObserve(self.factoryRequest, state) filter:^BOOL(id value) {
        @strongify(self);
        return self.factoryRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.factoryModel = [[CarSeriesFactoryListModel alloc]initWithDictionary:self.factoryRequest.output[@"data"] error:nil];
    }];

    
}
@end
