//
//  HomeViewModel.m
//  chechengwang
//
//  Created by 严琪 on 16/12/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [HomelistRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
                   NSError*error;
          self.data = [[HomeModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];
           NSString*path = self.request.cacheURL;
          [self.request.output writeToFile:path atomically:YES];
          if (error) {
              NSLog(@"%@", error.description);
          }
      }];
    
    
//    self.xihaorequest = [HomeXihaoRequest RequestWithBlock:^{
//        @strongify(self);
//        [self SEND_ACTION:self.xihaorequest];
//    }];
//
//    [[RACObserve(self.xihaorequest, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          return self.xihaorequest.succeed;
//      }]subscribeNext:^(id x) {
//          @strongify(self);
//          NSError*error;
//          NSDictionary *dic = self.xihaorequest.output;
//          self.xihaodata = [[XiHaoSubjectListModel alloc]initWithDictionary:self.xihaorequest.output error:&error];
//          NSString*path = self.xihaorequest.cacheURL;
//          [self.xihaorequest.output writeToFile:path atomically:YES];
//          if (error) {
//              NSLog(@"%@", error.description);
//          }
//      }];
    
    self.tagrequest = [TagsRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.tagrequest];
    }];
    
    self.tagrequest = [TagsRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.tagrequest];
    }];
    [[RACObserve(self.tagrequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.tagrequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSError*error;
          NSDictionary *dic = self.tagrequest.output;
          self.tagdata = [[TagsListModel alloc]initWithDictionary:self.tagrequest.output error:&error];
          NSString*path = self.tagrequest.cacheURL;
          [self.tagrequest.output writeToFile:path atomically:YES];
                if (error) {
                        NSLog(@"%@", error.description);
                }
      }];
}
-(HomeModel*)data{
    if (!_data) {
        NSString*path = self.request.cacheURL;
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict.isNotEmpty) {
            _data = [[HomeModel alloc]initWithDictionary:dict[@"data"] error:nil];
        }
        
    }
    return _data;
}

-(TagsListModel *)tagdata{
    if (!_tagdata) {
        NSString*path = self.tagrequest.cacheURL;
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict.isNotEmpty) {
            _tagdata = [[TagsListModel alloc]initWithDictionary:dict error:nil];
        }
    }
    return _tagdata;
}

//-(XiHaoSubjectListModel *)xihaodata{
//    if (!_xihaodata) {
//        NSString*path = self.xihaorequest.cacheURL;
//        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
//        if (dict.isNotEmpty) {
//            _xihaodata = [[XiHaoSubjectListModel alloc]initWithDictionary:dict[@"data"] error:nil];
//        }
//
//    }
//    return _xihaodata;
//}

@end
