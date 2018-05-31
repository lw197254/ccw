//
//  ReduceBrandSelectViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/25.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"

typedef void(^ParentCarIDAndCarTypeID)(NSString *brandID,NSString *carID,NSString *carTypeID);
@interface ReduceBrandSelectViewController : ParentViewController

@property(nonatomic,copy) ParentCarIDAndCarTypeID parentBlock;


@property(nonatomic,copy) NSString *brandID;
@property(nonatomic,copy) NSString *carID;
@property(nonatomic,copy) NSString *carTypeID;

@end
