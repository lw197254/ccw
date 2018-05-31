//
//  ConditionSelectCarViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ConditionSelectCarViewModel.h"

@implementation ConditionSelectCarViewModel

-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.configRequest = [ConditionSelectCarConfigRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.configRequest];
    }];
    self.countRequest = [ConditionSelectCarCountRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.countRequest];
    }];
    self.resultRequest = [ConditionSelectCarResultRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.resultRequest];
    }];

    [[RACObserve(self.resultRequest, state)filter:^BOOL(id value) {
         @strongify(self);
        return self.resultRequest.succeed;
    }]subscribeNext:^(id x) {
         @strongify(self);
        ConditionSelectCarResultListModel*model =  [[ConditionSelectCarResultListModel alloc]initWithDictionary:self.resultRequest.output[@"data"] error:nil];
        if (!self.showList) {
            self.showList = [NSMutableArray<ConditonSelectCarResultModel*> array];
        }
        
        self.showList  = [self success:self.showList newArray:model.list currentPage:[self.resultRequest.page integerValue] initPage:1];
        self.model = model;
    }];
    
  }
-(NSArray*)data{
    if (!_data) {
        NSString*path = [[NSBundle mainBundle]pathForResource:@"conditionSelectCarConfig" ofType:@"json"];
        NSMutableData*data = [[NSMutableData alloc]initWithContentsOfFile:path];
        NSError*error;
        _data =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    return _data;

}
@end
