//
//  InformationViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "InformationViewModel.h"
#import "HomeMenuRequest.h"
@implementation InformationViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    self.list = [NSMutableArray array];
    @weakify(self);
    self.carTypeRequest = [InformationCarTypeRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.carTypeRequest];
    }];
    self.carSeriesRequest = [InformationCarSeriesRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.carSeriesRequest];
    }];
    [[RACObserve(self.carTypeRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.carTypeRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        InformationListModel*model = [[InformationListModel alloc]initWithDictionary:self.carTypeRequest.output[@"data"] error:&error];
       
        if (self.carTypeRequest.page==1) {
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:model.list];
        }else{
            self.list=  [self success:self.list newArray:model.list currentPage:self.carSeriesRequest.page initPage:1];
        }

        if (model.list.count >0) {
            self.carTypeRequest.page++;
        }
        self.model = model;
    }];
       [[RACObserve(self.carSeriesRequest, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.carSeriesRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSError*error;
        InformationListModel*model  = [[InformationListModel alloc]initWithDictionary:self.carSeriesRequest.output[@"data"] error:&error];
       
      
        if (self.carSeriesRequest.page==1) {
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:model.list];
        }else{
             self.list=  [self success:self.list newArray:model.list currentPage:self.carSeriesRequest.page initPage:1];
        }
        if (model.list.count > 0) {
            self.carSeriesRequest.page++;
        }
        self.model = model;
        
    }];

    self.menuRequst = [HomeMenuRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_CACHE_ACTION:self.menuRequst];
    }];
  
    [[RACObserve(self.menuRequst, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.menuRequst.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          NSError*error;
          self.menuModel = [[HomeMenuModel alloc]initWithDictionary:self.menuRequst.output[@"data"] error:&error];
          
          
          
          if (!error) {
              NSString*path = self.menuRequst.cacheURL;
              [self.menuRequst.output writeToFile:path atomically:YES];
              
          }
      }];

}
-(HomeMenuModel*)menuModel{
    if (!_menuModel) {
        
        
        NSString*path = self.menuRequst.cacheURL;
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dict.isNotEmpty) {
            _menuModel = [[HomeMenuModel alloc]initWithDictionary:dict[@"data"] error:nil];
        }

       
//        @property(nonatomic,copy) NSString *typename;
//        @property(nonatomic,copy) NSString *id;
//        @property(nonatomic,copy) NSString *catdir;
        MenuModel*model = [[MenuModel alloc]init];
        model.id = @"115";
        model.typename = @"全部";
        NSMutableArray<MenuModel>*array = [NSMutableArray<MenuModel> arrayWithArray:_menuModel.menu];
        [array insertObject:model atIndex:0];
        _menuModel.menu = array;
    }
    return _menuModel;
}
@end
