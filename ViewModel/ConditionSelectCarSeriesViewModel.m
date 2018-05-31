//
//  ConditionSelectCarSeriesViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarSeriesViewModel.h"

@implementation ConditionSelectCarSeriesViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [ConditionSelectCarSeriesRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        self.model = [[FindCarByGroupByCarTypeGetCarListModel alloc]initWithDictionary:self.request.output error:&error];
        
    }];
    
}

@end
