//
//  CompareListViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/2/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
@class FindCarByGroupByCarTypeGetCarModel;

typedef enum{
    ENUM_ViewController_TypeNormal,
    ENUM_ViewController_TypeNewCompare,//综合对比
    ENUM_ViewController_TypeParamsCompare,//参数对比
 
}ENUM_ViewController_FatherType;
@interface CompareListViewController : ParentViewController

-(void)editCompareSlectedDictWithModel:(FindCarByGroupByCarTypeGetCarModel*)model isDelete:(BOOL)isDelete;

@property(nonatomic,assign) ENUM_ViewController_FatherType fatherType;
@end
