//
//  Timer.h
//  Qumaipiao
//
//  Created by 刘伟 on 15/6/24.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^repeatBlock)(NSString* time);
typedef void (^FinishedRepeatBlock)(NSString* title);
@interface Timer : NSObject
@property(nonatomic,assign)NSTimeInterval time;
@property(nonatomic,copy)repeatBlock block;
@property(nonatomic,copy)FinishedRepeatBlock finishedBlock;
//-(instancetype)initWithTimeInerval:(NSTimeInterval)time target:(id)target selector:(SEL)selector;
//-(instancetype)initWithTimeInerval:(NSTimeInterval)time startDate:(NSDate*)startDate target:(id)target selector:(SEL)selector;
//-(void)repeat:(repeatBlock)block;
//-(void)finishedRepeat:(FinishedRepeatBlock)finishedBlock;
+(instancetype)timerWithTimeInerval:(NSTimeInterval)time repeatBlock:(repeatBlock)repeatBlock finishedRepeat:(FinishedRepeatBlock)finishedBlock ;
+(instancetype)timerWithTimeInerval:(NSTimeInterval)time startDate:(NSDate*)startDate repeatBlock:(repeatBlock)repeatBlock finishedRepeat:(FinishedRepeatBlock)finishedBlock ;


//-(NSString*)nowTitle;
-(void)stopTimer;
+(instancetype)shareTimer;
@end
