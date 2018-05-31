//
//  UserSujectDB.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/12.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserSubjectListViewModel.h"
#import "UserCollectionListViewModel.h"

@interface UserSujectDB : NSObject

@property(nonatomic,assign)bool isCollection;

-(void)setUpSubjectList;


-(void)setUpCollectionList;

@end
