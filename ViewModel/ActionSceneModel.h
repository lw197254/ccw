//
//  ActionSceneModel.h
//  rssreader
//
//  Created by zhuchao on 15/2/10.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

#import "FatherViewModel.h"

@interface ActionSceneModel : FatherViewModel
+ (ActionSceneModel *)sharedInstance;
-(void)sendRequest:(Request *)req
           success:(void (^)())successHandler
             error:(void (^)())errorHandler;
@end
