//
//  CompareContentView.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/22.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareContentView.h"
#import "CompareTableView.h"
#import "CompareTopView.h"
#import "NewCompareCarViewController.h"

@interface CompareContentView()

@property(nonatomic,assign)CGPoint oldCGFloat;

@end

@implementation CompareContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.isNeedparent = NO;
        
        UISwipeGestureRecognizer * recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self addGestureRecognizer:recognizerUp];
        
        UISwipeGestureRecognizer * recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self addGestureRecognizer:recognizerDown];
        
        UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizerLeft];
        
        
        UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizerRight];

    }
    return self;
}


#pragma mark - 重载系统的hitTest方法

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NewCompareCarViewController *currentVC = (NewCompareCarViewController *)self.nextResponder;
    currentVC.printPoint = point;
    if ([self.topView pointInside:point withEvent:event]) {
        self.scrollView.scrollEnabled = NO;
//        if (self.isNeedparent) {
//            return self.contentView.tableView;
//        }
        return [super hitTest:point withEvent:event];
      
    } else {
        self.isNeedparent = NO;
        self.scrollView.scrollEnabled = YES;
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark 判断手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    CGPoint point = [recognizer locationInView:self.topView];
    if (CGRectContainsPoint(self.topView.frame, point)) {
        if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
            NSLog(@"swipe down");
            
        }
        if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
            NSLog(@"swipe up");
            
        }
        if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
            NSLog(@"swipe left");
            
        }
        if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"swipe right");
            
        }
    }

    
}


@end
