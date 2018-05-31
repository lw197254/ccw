//
//  HomeViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/2/27.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface HomeViewController : ParentViewController
///定位完成
@property(nonatomic,assign)BOOL locationFinished;
///广告完成
@property(nonatomic,assign)BOOL adFinished;
///引导页完成
@property(nonatomic,assign)BOOL guideFinished;

-(void)refreshCurrentViewController;
@end
