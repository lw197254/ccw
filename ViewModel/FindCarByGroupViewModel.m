//
//  FindCarByGroupViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FindCarByGroupViewModel.h"

@implementation FindCarByGroupViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
        @weakify(self);
    ///获取条件列表
    self.getConditionListRequest = [FindCarByGroupGetConditionRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.getConditionListRequest];
    }];
   
   
//    self.getCarListCountRequest = [FindCarByGroupGetCarListCountRequest RequestWithBlock:^{
//        @strongify(self);
//        [self SEND_ACTION:self.getCarListCountRequest];
//    }];
    [[RACObserve(self.getConditionListRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.getConditionListRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        self.getConditionListModel = [[FindCarByGroupGetConditionListModel alloc]initWithDictionary:self.getConditionListRequest.output error:&error];
        
    }];
   
   
   
//    [[RACObserve(self.getCarListCountRequest, state)filter:^BOOL(id value) {
//        @strongify(self);
//        return self.getCarListCountRequest.succeed;
//    }]subscribeNext:^(id x) {
//        @strongify(self);
//        NSError*error;
//        self.getCarListCountModel = [[FindCarByGroupGetCarCountModel alloc]initWithDictionary:self.getCarListCountRequest.output error:&error];
//        
//    }];

    
}
@end
