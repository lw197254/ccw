//
//  UserSubjectiListViewModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UserSubjectListViewModel.h"


@implementation UserSubjectListViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    @weakify(self);
    self.request = [UserSubjectRequest RequestWithBlock:^{
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
          self.data = [[SubjectUserList alloc]initWithDictionary:self.request.output error:&error];
          if (error) {
              NSLog(@"%@", error.description);
          }
          
          [self rebuildSubjects];
      }];
}


-(void)rebuildSubjects{
    NSLog(@"初始化 %@ 数值 %ld",self.class,self.data.data.count);
    if (self.data.data.count>0) {
        
        [self.data.data enumerateObjectsUsingBlock:^(SubjectUserModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:obj.authorId];
            if (![browse count]) {
                [obj save];
            }else{
                SubjectUserModel *model = browse[0];
                if (![model.subId isNotEmpty]) {
                    model.subId = obj.subId;
                    [model save];
                }
            }

        }];
    }
    
}

@end
