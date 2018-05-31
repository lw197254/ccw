//
//  AskForPriceViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "AskForPriceViewModel.h"

@implementation AskForPriceViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.askRequest = [AskForPriceDealerListRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.askRequest];
    }];
    self.commitRequest = [AskForPriceCommitRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.commitRequest];
    }];
    [[RACObserve(self.askRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.askRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        NSDictionary *dic = self.askRequest.output;
        self.model = [[AskForPriceModel alloc]initWithDictionary:self.askRequest.output[@"data"] error:&error] ;
       
    }];
    
    
    self.carSeriesRequest = [AskForPriceCarseriesRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.carSeriesRequest];
    }];
    self.messageRequest = [AskForPriceMessageRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.messageRequest];
    }];
    [[RACObserve(self.carSeriesRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.carSeriesRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        self.carSeriesListModel = [[AskForPriceCarSeriesListModel alloc]initWithDictionary:self.carSeriesRequest.output error:&error] ;
       
    }];

    
}
@end
