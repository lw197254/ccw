//
//  UserCollectionListViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserCollectionRequest.h"
#import "CollectionList.h"



@interface UserCollectionListViewModel : FatherViewModel
@property(nonatomic,strong)UserCollectionRequest *request;
@property(nonatomic,strong)CollectionList *data;

@property(nonatomic,assign)bool isFinishCollectionList;

@end
