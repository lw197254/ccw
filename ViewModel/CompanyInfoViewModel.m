//
//  CompanyInfoViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CompanyInfoViewModel.h"

@implementation CompanyInfoViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [CompanyInfoRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model = [[CompanyInfoModel alloc]initWithDictionary:[self.request.output valueForKey:@"data"] error:nil];
    }];
}

@end
