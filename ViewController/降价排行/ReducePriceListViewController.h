//
//  ReducePriceListViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/20.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"

@interface ReducePriceListViewController : ParentViewController


//关联车型的降价促销
@property(nonatomic,copy)NSString *carID;

@property(nonatomic,copy)NSString *carTypeID;

@end
