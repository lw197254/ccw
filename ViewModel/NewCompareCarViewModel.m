//
//  NewCompareCarViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "NewCompareCarViewModel.h"

@implementation NewCompareCarViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [NewCompareCarRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary*dict = self.request.output;
        self.data = [[NewCompareCarListModel alloc]initWithDictionary:dict error:nil];
    }];
}


@end
