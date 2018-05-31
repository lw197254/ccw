//
//  InformationViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface InformationViewController : ParentViewController
///两个二选一
@property(nonatomic,copy)NSString*carTypeId;
@property(nonatomic,copy)NSString*carSeriesId;
@end
