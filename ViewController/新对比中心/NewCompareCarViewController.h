//
//  NewCompareCarViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/8/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"


@interface NewCompareCarViewController : ParentViewController
@property (assign, nonatomic) CGPoint printPoint;

//所有车型
@property(nonatomic,strong)NSArray<NSString*>*carIds;



@end
