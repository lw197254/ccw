//
//  BrandViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BrandViewModel.h"

@implementation BrandViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [BrandRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        self.model = [[BrandListModel alloc]initWithDictionary:self.request.output error:nil];
        
        
    }];
}

@end
