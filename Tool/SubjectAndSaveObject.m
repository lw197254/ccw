//
//  SubjectAndSaveObject.m
//  chechengwang
//
//  Created by 严琪 on 2017/5/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "SubjectAndSaveObject.h"

#import "UserSubjectAddViewModel.h"
#import "UserSubjectDeleteViewModel.h"

#import "UserCollectionAddViewModel.h"
#import "UserCollectionDeleteViewModel.h"

#import "UserModel.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"


@interface SubjectAndSaveObject()

@property(nonatomic,strong)NSMutableDictionary *dic;

@property(nonatomic,strong)UserSubjectAddViewModel *subjectAddModel;
@property(nonatomic,strong)UserSubjectDeleteViewModel *subjectDeleteModel;

@property(nonatomic,strong)UserCollectionAddViewModel *collectionAddModel;
@property(nonatomic,strong)UserCollectionDeleteViewModel *collectionDeleteModel;
@property(nonatomic,strong)UserCollectionDeleteViewModel *collectionDeleteModels;



@end

//成功
static NSString *success = @"1";
//失败
static NSString *fail = @"2";



@implementation SubjectAndSaveObject

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

#pragma 收藏

-(UserCollectionAddViewModel*)collectionAddModel{
    if (!_collectionAddModel) {
        _collectionAddModel = [UserCollectionAddViewModel SceneModel];
        _collectionAddModel.request.uid = [UserModel shareInstance].uid;
        
        @weakify(self);
        [[RACObserve(self.collectionAddModel.request, state)filter:^BOOL(id value) {
            return self.collectionAddModel.request.succeed||self.collectionDeleteModel.request.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (self.collectionAddModel.request.succeed) {
                
                NSDictionary*dict = self.collectionAddModel.request.output;
                self.collectionAddModel.subid = dict[@"data"][@"id"];
                
                [self callInfoServiceWithSaveId:self.collectionAddModel.subid model:self.collectionAddModel.model modelType:self.collectionAddModel.ids type:success];
                
            }else{
                NSLog(@"收藏失败");
                [self callInfoService:self.collectionAddModel.model type:fail];
            }
            
        }];
    }
    return _collectionAddModel;
}

-(UserCollectionDeleteViewModel *)collectionDeleteModel{
    if (!_collectionDeleteModel) {
        _collectionDeleteModel = [UserCollectionDeleteViewModel SceneModel];
        
        
        @weakify(self);
        [[RACObserve(self.collectionDeleteModel.request,state)filter:^BOOL(id value) {
            return self.collectionDeleteModel.request.succeed||self.collectionDeleteModel.request.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (self.collectionDeleteModel.request.succeed) {
                [self callInfoServiceWithMoveModel:self.collectionDeleteModel.model modelType:self.collectionDeleteModel.ids type:success];
            }else{
                NSLog(@"收藏失败");
                [self callInfoServiceWithMoveModel:self.collectionDeleteModel.model modelType:self.collectionDeleteModel.ids type:fail];
            }
        }];

    }
    return _collectionDeleteModel;
}

-(UserCollectionDeleteViewModel *)collectionDeleteModels{
    if (!_collectionDeleteModels) {
        _collectionDeleteModels = [UserCollectionDeleteViewModel SceneModel];
        
        
        @weakify(self);
        [[RACObserve(self.collectionDeleteModels.request,state )filter:^BOOL(id value) {
            return self.collectionDeleteModels.request.failed||self.collectionDeleteModels.request.succeed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (self.collectionDeleteModels.request.succeed) {
                if([self.collectionDeleteModels.ids isEqualToString:artInfo]){
                    [self.collectionDeleteModels.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [[[KouBeiArtModel Model] where:@{@"id":obj}] delete ];
                        NSLog(@"收藏取消 %@",obj);
                    }];
                }else if([self.collectionDeleteModels.ids isEqualToString:koubeiInfo]){
                    [self.collectionDeleteModels.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [[[KouBeiDBModel Model] where:@{@"id":obj}] delete ];
                        NSLog(@"收藏取消 %@",obj);
                    }];
                    
                }else if([self.collectionDeleteModels.ids isEqualToString:chexi]){
                    
                    [self.collectionDeleteModels.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [[[KouBeiCarDeptModel Model] where:@{@"id":obj}] delete ];
                        NSLog(@"收藏取消 %@",obj);
                    }];
                    
                }else if([self.collectionDeleteModels.ids isEqualToString:chexing]){
                    [self.collectionDeleteModels.array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [[[KouBeiCarTypeModel Model] where:@{@"id":obj}] delete ];
                        NSLog(@"收藏取消 %@",obj);
                    }];
                }
                
                [self callInfoService:nil type:success];
            }else{
                NSLog(@"收藏失败");
                [self callInfoService:nil type:fail];
            }
            
        }];
        
    }
    return _collectionDeleteModels;
}


#pragma 订阅

-(UserSubjectAddViewModel*)subjectAddModel{
    if (!_subjectAddModel) {
        _subjectAddModel = [UserSubjectAddViewModel SceneModel];
        _subjectAddModel.request.uid =   [UserModel shareInstance].uid;
        
        
        @weakify(self);
        [[RACObserve(self.subjectAddModel.request,state)filter:^BOOL(id value) {
            return self.subjectAddModel.request.succeed||self.subjectAddModel.request.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (self.subjectAddModel.request.succeed) {
                
                NSDictionary*dict = self.subjectAddModel.request.output;
                self.subjectAddModel.subid = [dict objectForKey:@"data"][@"id"];
                
                self.subjectAddModel.model.subId = self.subjectAddModel.subid;
                NSLog(@"订阅成功 %@",self.subjectAddModel.model.authorName);
                [self.subjectAddModel.model save];
                [self callSubjectService:self.subjectAddModel.model type:success];
            }else{
                NSLog(@"订阅失败 %@",self.subjectAddModel.model.authorName);
                [self callSubjectService:self.subjectAddModel.model type:fail];
            }
            
        }];

    }
    return _subjectAddModel;
}


-(UserSubjectDeleteViewModel*)subjectDeleteModel{
    if (!_subjectDeleteModel) {
        _subjectDeleteModel = [UserSubjectDeleteViewModel SceneModel];
        
        @weakify(self);
        [[RACObserve(self.subjectDeleteModel.request, state)filter:^BOOL(id value) {
            return self.subjectDeleteModel.request.succeed||self.subjectDeleteModel.request.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (self.subjectDeleteModel.request.succeed) {
                NSLog(@"订阅取消 %@",self.subjectDeleteModel.model.authorName);
                [[[SubjectUserModel Model] where:@{@"subId":self.subjectDeleteModel.model.subId}] delete ];
                [self callSubjectService:self.subjectDeleteModel.model type:success];
            }else{
                NSLog(@"订阅失败 %@",self.subjectDeleteModel.model.authorName);
                [self callSubjectService:self.subjectDeleteModel.model type:fail];
            }
            
        }];

        
    }
    return _subjectDeleteModel;
}

-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[KouBeiArtModel class],artInfo,[KouBeiDBModel class],koubeiInfo,[KouBeiCarDeptModel class],chexi,
                [KouBeiCarTypeModel class],chexing,nil];
        
    }
    return _dic;
}


#pragma 主要方法体
-(void)InfoMoveObjects:(NSMutableArray *)array typeid:(NSString *)ids
{

    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        return ;
    }
    
 
    self.collectionDeleteModels.ids = ids;
    self.collectionDeleteModels.array = [array copy];
    self.collectionDeleteModels.request.ids = array;
    self.collectionDeleteModels.request.startRequest =YES;
    
}

-(void)InfoMoveObject:(NSObject *)model typeid:(NSString *)ids{
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        return ;
    }
   
    
    if([ids isEqualToString:artInfo]){
        KouBeiArtModel *md =  (KouBeiArtModel *)model;
        self.collectionDeleteModel.request.ids = [NSArray arrayWithObjects:md.id ,nil];
    }else if([ids isEqualToString:koubeiInfo]){
        KouBeiDBModel *md =  (KouBeiDBModel *)model;
        self.collectionDeleteModel.request.ids = [NSArray arrayWithObjects:md.id ,nil];
    }else if([ids isEqualToString:chexi]){
        KouBeiCarDeptModel *md =  (KouBeiCarDeptModel *)model;
        self.collectionDeleteModel.request.ids = [NSArray arrayWithObjects:md.id ,nil];
    }else if([ids isEqualToString:chexing]){
        KouBeiCarTypeModel *md =  (KouBeiCarTypeModel *)model;
        self.collectionDeleteModel.request.ids = [NSArray arrayWithObjects:md.id ,nil];
    }
    
    self.collectionDeleteModel.model = model;
    self.collectionDeleteModel.ids = ids;
    self.collectionDeleteModel.request.startRequest =YES;
   
}

-(void)InfoSaveObject:(NSObject *)model typeid:(NSString *)ids{
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        return ;
    }
    
    if([ids isEqualToString:artInfo]){
        KouBeiArtModel *md =  (KouBeiArtModel *)model;
        self.collectionAddModel.request.colId =md.colId;
        if ([md.artType isEqualToString:zimeiti]) {
            self.collectionAddModel.request.type = @"4";
        }else{
            self.collectionAddModel.request.type = @"3";
        }
    }else if([ids isEqualToString:koubeiInfo]){
        KouBeiDBModel *md =  (KouBeiDBModel *)model;
        self.collectionAddModel.request.colId =md.colId;
        self.collectionAddModel.request.type = @"5";
    }else if([ids isEqualToString:chexi]){
        KouBeiCarDeptModel *md =  (KouBeiCarDeptModel *)model;
        self.collectionAddModel.request.colId =md.colId;
        self.collectionAddModel.request.type = @"1";
    }else if([ids isEqualToString:chexing]){
        KouBeiCarTypeModel *md =  (KouBeiCarTypeModel *)model;
        self.collectionAddModel.request.colId =md.colId;
        self.collectionAddModel.request.type = @"2";
    }else if([ids isEqualToString:myvideo]){
         KouBeiArtModel *md =  (KouBeiArtModel *)model;
        self.collectionAddModel.request.colId =md.colId;
        self.collectionAddModel.request.type = @"6";
    }

    self.collectionAddModel.model = model;
    self.collectionAddModel.ids = ids;
    self.collectionAddModel.request.uid = [UserModel shareInstance].uid;
    self.collectionAddModel.request.startRequest =YES;

}

#pragma 订阅方法体

-(void)SubjectSaveObject:(SubjectUserModel *)model {
    
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        return ;
    }
    
    self.subjectAddModel.model = [model copy];
    self.subjectAddModel.request.authorId = model.authorId;
    self.subjectAddModel.request.startRequest = YES;
}

-(void)SubjectMoveObject:(SubjectUserModel *)model {

    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
        return ;
    }
    
    self.subjectDeleteModel.model = [model copy];
    self.subjectDeleteModel.request.id = model.subId;
    self.subjectDeleteModel.request.startRequest = YES;

}



///文章请求 保存方法
-(void)callInfoServiceWithSaveId:(NSString *)subid model:(NSObject *)model modelType:(NSString*)ids type:(NSString *)type {
    
    if (self.infoBlock && [type isEqualToString:success]) {
        //save
        
        if([ids isEqualToString:artInfo]){
            KouBeiArtModel *md =  (KouBeiArtModel *)model;
            md.id = subid;
            [md save];
            NSLog(@"收藏成功 %@",md.title);
        }else if([ids isEqualToString:koubeiInfo]){
            KouBeiDBModel *md =  (KouBeiDBModel *)model;
            md.id = subid;
            NSLog(@"收藏成功 %@",md.title);
            [md save];
        }else if([ids isEqualToString:chexi]){
            KouBeiCarDeptModel *md =  (KouBeiCarDeptModel *)model;
            md.id = subid;
            NSLog(@"收藏成功 %@",md.name);
            [md save];
        }else if([ids isEqualToString:chexing]){
            KouBeiCarTypeModel *md =  (KouBeiCarTypeModel *)model;
            md.id = subid;
            NSLog(@"收藏成功 %@",md.name);
            [md save];
        }else if([ids isEqualToString:myvideo]){
            KouBeiArtModel *md =  (KouBeiArtModel *)model;
            md.id = subid;
            NSLog(@"收藏成功 %@",md.title);
            [md save];
        }
        
        self.infoBlock(YES);
    }else{
        self.infoBlock(NO);
    }
    
}

-(void)callInfoServiceWithMoveModel:(NSObject *)model modelType:(NSString*)ids type:(NSString *)type{
    if (self.infoBlock && [type isEqualToString:success]) {
        //save
        
        if([ids isEqualToString:artInfo]){
            KouBeiArtModel *md =  (KouBeiArtModel *)model;
            NSLog(@"收藏取消 %@",md.title);
            [[[KouBeiArtModel Model] where:@{@"id":md.id}] delete ];
        }else if([ids isEqualToString:koubeiInfo]){
            KouBeiDBModel *md =  (KouBeiDBModel *)model;
            NSLog(@"收藏取消 %@",md.title);
            [[[KouBeiDBModel Model] where:@{@"id":md.id}] delete ];
        }else if([ids isEqualToString:chexi]){
            KouBeiCarDeptModel *md =  (KouBeiCarDeptModel *)model;
            NSLog(@"收藏取消 %@",md.name);
            [[[KouBeiCarDeptModel Model] where:@{@"id":md.id}] delete ];
        }else if([ids isEqualToString:chexing]){
            KouBeiCarTypeModel *md =  (KouBeiCarTypeModel *)model;
            NSLog(@"收藏取消 %@",md.name);
            [[[KouBeiCarTypeModel Model] where:@{@"id":md.id}] delete ];
        }
        
        self.infoBlock(YES);
    }else{
        self.infoBlock(NO);
    }

}


///文章请求
-(void)callInfoService:(NSObject *)object type:(NSString *)type {
    
    if (self.infoBlock && [type isEqualToString:success]) {
        //save
        self.infoBlock(YES);
    }else{
        self.infoBlock(NO);
    }
    
}


///订阅请求
-(void)callSubjectService:(NSObject *)object type:(NSString *)type {
    
    if (self.subjectBlock && [type isEqualToString:success]) {
        //save
        self.subjectBlock(YES);
    }else{
        self.subjectBlock(NO);
    }
    
}





@end
