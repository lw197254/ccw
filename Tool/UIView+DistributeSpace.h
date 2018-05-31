//
//  UIView+DistributeSpace.h
//  CarAssistantsTest
//
//  Created by 刘伟 on 15/5/19.
//  Copyright (c) 2015年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DistributeSpace)
- (void) distributeSpacingVerticallyWith:(NSArray*)views;
//n个视图挨在一起
- (void) distributeVerticallyWith:(NSArray*)views withTopSpaceBaifenbi:(CGFloat)baofenbi;
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;
-(void)distributeSpacingHorizontallySpaceEqualWith:(NSArray *)views;
-(void)distributeHorizontallyWith:(NSArray *)views;//n个视图挨在一起
-(void)distributeSpacingHorizontallySpaceEqualWith:(NSArray *)views withLeftSpaceBaifenbi:(CGFloat)baofenbi;
@end
