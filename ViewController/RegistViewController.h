//
//  RegistViewController.h
//  12123
//
//  Created by 刘伟 on 2016/9/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"

@interface RegistViewController : ParentViewController

@property(nonatomic,copy)NSString*mobile;
@property (copy, nonatomic) LoginSuccessBlock block;

@end
