//
//  FindCarViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FindCarViewModel.h"

@implementation FindCarViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.brandListRequest = [FindCarBrandListRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.brandListRequest];
    }];
    [[RACObserve(self.brandListRequest, state)filter:^BOOL(id value) {
        return self.brandListRequest.succeed;
    }]subscribeNext:^(id x) {
        
        if (!self.model.isNotEmpty||self.refreshImmediately) {
             self.model = [[FindCarBrandListModel alloc]initWithDictionary:self.brandListRequest.output[@"data"] error:nil];
        }
        
        NSString*path = self.brandListRequest.cacheURL;
        [self.brandListRequest.output writeToFile:path atomically:YES];
        
    }];
    
    
   
   
}

-(FindCarBrandListModel*)model{
    if (!_model) {
        NSString*path = self.brandListRequest.cacheURL;
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict.isNotEmpty) {
            _model = [[FindCarBrandListModel alloc]initWithDictionary:dict[@"data"] error:nil];
        }
        
    }
    return _model;
}


//-(NSArray*)sectionIndexTitleArray{
//    return @[@"#",@"A",@"B",@"C"];
//}
//-(NSArray*)sectionHeaderTitleArray{
//    return @[@"热门品牌",@"A",@"B",@"C"];
//}
@end
