//
//  NickNameViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/5/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "RegistViewController.h"
typedef void(^NickNameModifySuccessBlock)(NSString*nickName);


@interface NickNameViewController : ParentViewController
@property(nonatomic,copy)LoginSuccessBlock block;
@property(nonatomic,assign)BOOL hideRightButton;
@property(nonatomic,copy)NSString* titleString;
@property (copy, nonatomic) NickNameModifySuccessBlock nickNameModifySuccessBlock;
@end
