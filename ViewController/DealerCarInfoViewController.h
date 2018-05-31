//
//  DealerCarInfoViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface DealerCarInfoViewController : ParentViewController

///dealerId	int	经销商ID 必填
@property(nonatomic,copy)NSString *dealerId;
///carId	int	车型ID 必填
@property(nonatomic,copy)NSString *carId;
///typeId	int	车系ID 必填
@property(nonatomic,copy)NSString *typeId;
@end
