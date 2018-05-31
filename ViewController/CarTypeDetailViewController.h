//
//  CarTypeDetailViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface CarTypeDetailViewController : ParentViewController
@property(nonatomic,copy)NSString*chexingId;

@property(nonatomic,copy)NSString*pic;

@property(nonatomic,assign)BOOL needAnimation;
@end

