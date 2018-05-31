//
//  PhotoSelectCarAndColorViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PhotoSelectCarAndColorViewModel.h"

@implementation PhotoSelectCarAndColorViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [PhotoCarTypeAndColorRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.model = [[CarTypeAndColorModel alloc]initWithDictionary:self.request.output[@"data"] error:nil];
    }];
}
@end
