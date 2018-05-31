//
//  FindCarByGroupGetCarListByCarTypeViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FindCarByGroupGetCarListByCarTypeViewModel.h"

@implementation FindCarByGroupGetCarListByCarTypeViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [FindCarByGroupGetCarListByCarTypeRequest RequestWithBlock:^{
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
