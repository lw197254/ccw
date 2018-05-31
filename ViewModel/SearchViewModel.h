//
//  SearchViewModel.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "HotSearchRequest.h"
#import "HotSearchListModel.h"
#import "SearchSuggestionRequest.h"
#import "SearchSugestionListModel.h"
#import "SearchResultModel.h"
#import "SearchResultRequest.h"
#import "SearchArtmoreRequest.h"
#import "SubmitSearchResultRequest.h"
@interface SearchViewModel : FatherViewModel
@property(nonatomic,strong)HotSearchRequest*hotSearchRequest;
@property(nonatomic,strong)HotSearchListModel*hotSearchListModel;

@property(nonatomic,strong)SearchSuggestionRequest*searchSuggestionRequest;
@property(nonatomic,strong)SearchSugestionListModel*searchSuggestionListModel;
@property(nonatomic,strong)SubmitSearchResultRequest*submitSearchResultRequest;
@property(nonatomic,strong)SearchResultRequest*searchResultRequest;
@property(nonatomic,strong)SearchArtmoreRequest*searchArtmoreRequest;
@property(nonatomic,strong)SearchResultModel*searchResultModel;
@end
