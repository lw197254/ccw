//
//  SubjectAndSaveObject.h
//  chechengwang
//
//  Created by 严琪 on 2017/5/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "SubjectUserModel.h"


#import "KouBeiCarDeptModel.h"
#import "KouBeiCarTypeModel.h"
#import "KouBeiDBModel.h"
#import "KouBeiArtModel.h"

//文章的block
typedef void(^InfoBlock)(bool isok);
//订阅的block
typedef void(^SubjectBlock)(bool isok);

@interface SubjectAndSaveObject : NSObject
///添加订阅
-(void)SubjectSaveObject:(SubjectUserModel *) model;

///取消订阅
-(void)SubjectMoveObject:(SubjectUserModel *) model;

///收藏文章
-(void)InfoSaveObject:(NSObject *) model typeid:(NSString *)ids;

///取消收藏文章
-(void)InfoMoveObject:(NSObject *) model typeid:(NSString *)ids;
-(void)InfoMoveObjects:(NSMutableArray *)array  typeid:(NSString *)ids;

@property(nonatomic,copy)InfoBlock infoBlock;

@property(nonatomic,copy)SubjectBlock subjectBlock;

@end
