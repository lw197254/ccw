//
//  NewCarForSaleViewModel.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "NewCarForSaleViewModel.h"

@implementation NewCarForSaleViewModel
-(void)loadSceneModel{
    [super loadSceneModel];
    
    @weakify(self);
    self.request = [NewCarForSaleRequest RequestWithBlock:^{
        @strongify(self);
        [self SEND_ACTION:self.request];
    }];
    [[RACObserve(self.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.request.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *dic = self.request.output;
        NewCarForSaleSectionModel*model = [[NewCarForSaleSectionModel alloc]initWithDictionary:self.request.output error:nil];
        NewCarForSaleListModel*listModel = [[NewCarForSaleListModel alloc]init];
        NewCarForSaleSectionModel*model1 = [[NewCarForSaleSectionModel alloc]init];
        model1.title = @"新车上市";
       
        NewCarForSaleSectionModel*model2 = [[NewCarForSaleSectionModel alloc]init];
        listModel.list = [NSMutableArray array];
       model1.list = [NSMutableArray<NewCarForSaleModel> array];
        model2.list = [NSMutableArray<NewCarForSaleModel> array];
         model2.title = @"即将上市";
        [model.list enumerateObjectsUsingBlock:^(NewCarForSaleModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == NewCarForSaleTypeOnsale) {
                [model1.list addObject:obj];
            }else{
                [model2.list addObject:obj];
            }
            
            
        }];
        
        if (model1.list.count!=0) {
            [listModel.list addObject:model1];
        }
        if (model2.list.count!=0) {
            [listModel.list addObject:model2];
        }
     // self.list = [self success:self.list newArray:model.list currentPage:self.request.page initPage:1];
              
        self.model=  listModel;
    }];
}
@end
