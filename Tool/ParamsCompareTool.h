//
//  ParamsCompareTool.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CompareBodySize;

@interface ParamsCompareTool : NSObject

@property(nonatomic,copy)CompareBodySize *leftParams;

@property(nonatomic,copy)CompareBodySize *rightParams;

@property(nonatomic,assign)NSInteger count;

-(void)checkEachOther;
-(NSString *)getLeftParams;
-(NSString *)getRightParams;
-(void)removeAll;

//是否显示底部显示更多功能
-(bool)isShowFooter;

-(NSString *)getSmallLeftParams;
-(NSString *)getSmallRighParams;

@end
