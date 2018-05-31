//
//  DeliverData.h
//  chechengwang
//
//  Created by 严琪 on 2017/4/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MatchModel.h"
#import "InfoContentModel.h"

@interface DeliverData : NSObject
-(void)setinfo:(NSMutableArray<InfoContentModel> *)infos matches:(NSMutableArray<MatchModel> *)matcharray;
@end
