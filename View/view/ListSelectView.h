//
//  ListSelectView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/7/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ListSelectViewAnimationComplationBlock)(BOOL isFinished);
typedef void(^ListSelectViewItemSelectedBlock)(NSInteger index,NSString*itemString);
@interface ListSelectView : UIView

-(void)showWithlistArray:(NSArray<NSString*>*)listArray selectedString:(NSString*)selectedString  animationComplation:(ListSelectViewAnimationComplationBlock)animationComplationFinishedBlock itemSelectedBlock:(ListSelectViewItemSelectedBlock)itemSelectBlock dismissAnimationCompletionBlock:(ListSelectViewAnimationComplationBlock)dismissAnimationCompletionBlock;
-(void)dismissWithAnimationComplation:(ListSelectViewAnimationComplationBlock)animationComplationFinishedBlock;
@end
