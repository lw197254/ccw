//
//  BrandIntroduceViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BrandIntroduceViewModel.h"

@implementation BrandIntroduceViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [BrandIntroduceRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model = [[BrandIntroduceModel alloc]initWithDictionary:[self.request.output valueForKeyPath:@"data.brand_info"] error:nil];
    }];
}

@end
