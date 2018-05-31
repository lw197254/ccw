//
//  UserSujectDB.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "UserSujectDB.h"
#import "UserModel.h"

@interface UserSujectDB()
@property(nonatomic,strong)UserSubjectListViewModel *userSubjectListViewModel;

@property(nonatomic,strong)UserCollectionListViewModel *userCollectionListViewModel;
@end

@implementation UserSujectDB

#pragma 初始化
-(UserSubjectListViewModel *)userSubjectListViewModel{
    if (!_userSubjectListViewModel) {
        _userSubjectListViewModel = [UserSubjectListViewModel SceneModel];
        _userSubjectListViewModel.request.uid = [UserModel shareInstance].uid;
    }
    return _userSubjectListViewModel;
}

-(UserCollectionListViewModel *)userCollectionListViewModel{
    if (!_userCollectionListViewModel) {
        _userCollectionListViewModel = [UserCollectionListViewModel SceneModel];
        _userCollectionListViewModel.request.uid = [UserModel shareInstance].uid;
    }
    return _userCollectionListViewModel;
}



-(void)setUpSubjectList{
    self.userSubjectListViewModel.request.startRequest =YES;
}


-(void)setUpCollectionList{
   
    
    [[RACObserve(self.userCollectionListViewModel, isFinishCollectionList)filter:^BOOL(id value) {
        return self.userCollectionListViewModel.isFinishCollectionList;
    }]subscribeNext:^(id x) {
        self.isCollection =  self.userCollectionListViewModel.isFinishCollectionList;
    }];
     self.userCollectionListViewModel.request.startRequest =YES;
}


@end
