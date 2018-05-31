//
//  BuyCarCalculatorRightListViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
typedef void(^BuyCarCalculatorRightListSelectedBlock)(NSInteger index,NSString*selectedItem);
@interface BuyCarCalculatorRightListViewController : ParentViewController

-(void)selectWithArray:(NSArray*)array selectedItem:(NSString*)selectedItem selectedBlock:(BuyCarCalculatorRightListSelectedBlock)selectedBlock;
@end
