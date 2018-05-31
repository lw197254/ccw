//
//  FeedBackViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/2/22.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "FeedBackRequest.h"

@interface FeedBackViewModel : FatherViewModel
@property(nonatomic,strong)FeedBackRequest *request;
@property(nonatomic,assign)bool isok;
@end
