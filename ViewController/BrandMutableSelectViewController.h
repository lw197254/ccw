//
//  BrandViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "ConditionModel.h"
typedef void(^BrandMulableSelectedBlock)(NSArray<ConditionModel*>*selectedArray);
@interface BrandMutableSelectViewController : ParentViewController



//@property(nonatomic,strong)NSMutableArray*orignalSelectedArray;
-(void)resetWithSelectedArray:(NSArray<ConditionModel*>*)selectedArray selectedFinishedBlock:(BrandMulableSelectedBlock)block sectionKey:(NSString*)sectionKey;
+(UIButton*)createBrandButtonWithTitle:(NSString*)title;
@end
