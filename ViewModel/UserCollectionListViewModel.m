//
//  UserCollectionListViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UserCollectionListViewModel.h"


@implementation UserCollectionListViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [UserCollectionRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          NSDictionary*dict = self.request.output;
          NSError*error;
          self.data = [[CollectionList alloc]initWithDictionary:self.request.output error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
          
          [self rebuildSubjects];
      }];
}


-(void)rebuildSubjects{
      NSLog(@"初始化 %@ 数值 %ld",self.class,self.data.data.series.count);
    
    if (self.data.data.series.count>0) {
        
        [self.data.data.series enumerateObjectsUsingBlock:^(KouBeiCarDeptModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *browse = [KouBeiCarDeptModel findByColumn:@"id" value:obj.id];
            if (![browse count]) {
                [obj save];
            }
            
        }];
    }else{
        KouBeiCarDeptModel *model  = [[KouBeiCarDeptModel alloc] init];
        if ([model isTableExist]) {
            [KouBeiCarDeptModel deleteAll];
        }
    }
     NSLog(@"初始化 %@ 数值 %ld",self.class,self.data.data.car.count);
    if (self.data.data.car.count>0) {
        
        [self.data.data.car enumerateObjectsUsingBlock:^(KouBeiCarTypeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *browse = [KouBeiCarTypeModel findByColumn:@"id" value:obj.id];
            if (![browse count]) {
                [obj save];
            }
            
        }];
    }else{
        KouBeiCarTypeModel *model  = [[KouBeiCarTypeModel alloc] init];
        if ([model isTableExist]) {
             [KouBeiCarTypeModel deleteAll];
        }
       
    }
     NSLog(@"初始化 %@ 数值 %ld",self.class,self.data.data.art.count);
    if (self.data.data.art.count>0) {
        
        [self.data.data.art enumerateObjectsUsingBlock:^(KouBeiArtModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *browse = [KouBeiArtModel findByColumn:@"id" value:obj.id];
            if (![browse count]) {
                [obj save];
            }
            
        }];
    }else{
        KouBeiArtModel *model  = [[KouBeiArtModel alloc] init];
        if ([model isTableExist]) {
            [KouBeiArtModel deleteAll];
        }
    }
     NSLog(@"初始化 %@ 数值 %ld",self.class,self.data.data.repution.count);
    if (self.data.data.repution.count>0) {
        
        [self.data.data.repution enumerateObjectsUsingBlock:^(KouBeiDBModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *browse = [KouBeiDBModel findByColumn:@"id" value:obj.id];
            if (![browse count]) {
                [obj save];
            }
            
        }];
    }else{
        KouBeiDBModel *model  = [[KouBeiDBModel alloc] init];
        if ([model isTableExist]) {
            [KouBeiDBModel deleteAll];
        }
    }
    
    
    self.isFinishCollectionList = YES;
}

@end
