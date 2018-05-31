//
//  SearchViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SearchViewModel.h"
@implementation SearchViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.hotSearchRequest = [HotSearchRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.hotSearchRequest];
    }];
    [[RACObserve(self.hotSearchRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.hotSearchRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.hotSearchListModel = [[HotSearchListModel alloc]initWithDictionary:self.hotSearchRequest.output error:nil];
    }];
    
    self.submitSearchResultRequest = [SubmitSearchResultRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.submitSearchResultRequest];
    }];
    
    self.searchSuggestionRequest = [SearchSuggestionRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.searchSuggestionRequest];
    }];
    [[RACObserve(self.searchSuggestionRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.searchSuggestionRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.searchSuggestionListModel = [[SearchSugestionListModel alloc]initWithDictionary:self.searchSuggestionRequest.output error:nil];
    }];

    self.searchResultRequest = [SearchResultRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.searchResultRequest];
    }];
    [[RACObserve(self.searchResultRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.searchResultRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.searchResultModel = [[SearchResultModel alloc]initWithDictionary:self.searchResultRequest.output[@"data"] error:nil];
    }];
    self.searchArtmoreRequest = [SearchArtmoreRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.searchArtmoreRequest];
    }];

}
@end
