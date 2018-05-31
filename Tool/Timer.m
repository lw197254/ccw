//
//  Timer.m
//  Qumaipiao
//
//  Created by 刘伟 on 15/6/24.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import "Timer.h"

@implementation Timer{
    NSTimer *_timer;
    NSTimer *timer1;
}
+(instancetype)shareTimer{
    static Timer*timer=nil;
    static dispatch_once_t predicate4;
    dispatch_once(&predicate4, ^{
        timer = [[Timer alloc]init];
    });
    return timer;
}
-(void)setTime:(NSTimeInterval)time{
    if (_time!=time) {
        _time = time;
    }
    
    if (time!=0) {
        [self openTimer ];
        [self time1];
    }
}
+(instancetype)timerWithTimeInerval:(NSTimeInterval)time {
  
   
    Timer*timer = [[Timer alloc]init];
        
    timer.time = time;
   
    [timer openTimer ];
     [timer time1];
    return timer;
}

+(instancetype)timerWithTimeInerval:(NSTimeInterval)time startDate:(NSDate *)startDate{
    


        Timer*timer = [[Timer alloc]init];
        timer.time = time;
    
        NSDate*nowDate = [NSDate date];
        NSDate*endDate = [NSDate dateWithTimeInterval:time sinceDate:startDate];
        timer.time = [endDate timeIntervalSinceDate:nowDate];
        [timer openTimer ];
        [timer time1];
    
    return timer;
}
-(NSString*)nowTitle{
//    NSInteger min = ((NSInteger)_time)/60;
//    NSInteger second = (NSInteger)_time -min*60;
//    NSString*str = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)min,(long)second];
    NSString*str =  [ NSString stringWithFormat:@"%ld",(long)_time ];
    return str;
}
-(void)openTimer{
    
    
    [timer1 invalidate];
        timer1= [NSTimer scheduledTimerWithTimeInterval:_time target:self selector:@selector(finishedTimer)  userInfo:nil repeats:NO];
  

    
    
    
}
-(void)stopTimer{
    [_timer invalidate];
    [timer1 invalidate];
}
-(void)time1{
    [_timer invalidate];
    
      _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
   
   
}
-(void)repeat{
    _time--;
//       NSInteger min = ((NSInteger)_time)/60;
//    NSInteger second = (NSInteger)_time -min*60;
//    NSString*str = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)min,(long)second];
    NSString*str =  [ NSString stringWithFormat:@"%ld",(long)_time ];
    

    if ((NSInteger)_time<=0) {
        _time=0;
        [_timer invalidate];
        [timer1 invalidate];
     //   _finishedBlock(str);
    }else{
        _block(str);
    }


//    if ([self respondsToSelector:_selector]) {
//        [self performSelector:_selector];
    
//    }
    
}
-(void)finishedTimer{
//    NSInteger min = ((NSInteger)_time)/60;
//    NSInteger second = (NSInteger)_time -min*60;
//    NSString*str = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)min,(long)second];
    NSString*str =  [ NSString stringWithFormat:@"%ld",(long)_time ];
    _finishedBlock(str);
}
-(void)finishedRepeat:(FinishedRepeatBlock)finishedBlock{
    
    if (_finishedBlock!=finishedBlock) {
       
            _finishedBlock = finishedBlock;

    }
}
-(void)repeat:(repeatBlock)block{
    if (_block!=block) {
        _block=nil;
        _block= block;
    }
}
+(void)stopTimer{
    Timer*timer = [Timer shareTimer];
    [timer stopTimer];
}
+(instancetype)timerWithTimeInerval:(NSTimeInterval)time repeatBlock:(repeatBlock)repeatBlock finishedRepeat:(FinishedRepeatBlock)finishedBlock{
    
  Timer*timer = [Timer  timerWithTimeInerval:time];
    if (timer.block!=repeatBlock) {
        timer.block=nil;
        timer.block= repeatBlock;
    }
    if (timer.finishedBlock!=finishedBlock) {
        
        timer.finishedBlock = finishedBlock;
        
    }

    return timer;
}
+(instancetype)timerWithTimeInerval:(NSTimeInterval)time startDate:(NSDate*)startDate repeatBlock:(repeatBlock)repeatBlock finishedRepeat:(FinishedRepeatBlock)finishedBlock {
    Timer*timer = [Timer  timerWithTimeInerval:time startDate:startDate];
    if (timer.block!=repeatBlock) {
        timer.block=nil;
        timer.block= repeatBlock;
    }
    if (timer.finishedBlock!=finishedBlock) {
        
        timer.finishedBlock = finishedBlock;
        
    }
    
    return timer;
    
}

@end
