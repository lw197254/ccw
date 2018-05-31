//
//  ParameterViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParameterViewModel.h"

@implementation ParameterViewModel
-(void)loadSceneModel{
    
    [super loadSceneModel];
    @weakify(self);
    self.request = [ParameterRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    self.carSeariesRequest = [ParameterCarSeariesRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.carSeariesRequest];
    }];

    [[RACObserve(self.request, state)filter:^BOOL(id value) {
          @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
         @strongify(self);
        self.data = self.request.output[@"data"];
    }];
    [[RACObserve(self.carSeariesRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.carSeariesRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.data = self.carSeariesRequest.output[@"data"];
    }];

}
-(NSArray*)mapArray{
    if (!_mapArray) {
        NSString*path = [[NSBundle mainBundle]pathForResource:@"ParamaterMap" ofType:@"json"];
        NSMutableData*data = [[NSMutableData alloc]initWithContentsOfFile:path];
        NSError*error;
     _mapArray =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
    }
    return _mapArray;
}
@end
