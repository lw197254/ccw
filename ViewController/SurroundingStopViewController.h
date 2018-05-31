//
//  SurroundingStopViewController.h
//  12123
//
//  Created by 刘伟 on 2016/10/20.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
///周边停车
typedef NS_ENUM(NSInteger,MapType){
    MapTypeAll = 0,
    MapTypeTrafficHighHappened = 1,
    MapTypeTrafficCondition = 2,
    MapTypeSurroundingStop = 3
    
};
@interface SurroundingStopViewController : ParentViewController
@property(nonatomic,assign)MapType mapType;
@end
