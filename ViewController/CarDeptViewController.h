//
//  CarDeptViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
///车系详情
typedef void(^AAblock)(NSString*name);
@interface CarDeptViewController : ParentViewController 


@property(nonatomic,strong)NSString *chexiid;
@property(nonatomic,strong)NSString *picture;
@property(nonatomic,copy)AAblock block;
@end
