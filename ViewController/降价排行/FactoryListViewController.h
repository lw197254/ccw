//
//  FactoryListViewController.h
//  chechengwang
//
//  Created by 严琪 on 2017/10/24.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"
#import "BrandModel.h"
#import "CarCheXingModel.h"

typedef NS_ENUM(NSInteger,UIControllerType) {
    //选车级别
    UIControllerCarLevel = 1,
    //车系详情
    UIControllerCarType = 2,
    //车型详情
    UIControllerCarCheXingType = 3
};

typedef void(^ChildIdsBlock)(NSString *carID,NSString *carTypeID);

typedef void(^ReduceBrandSelectLevel)(NSString *level);

@interface FactoryListViewController : ParentViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) UIControllerType controllerType;

@property (copy, nonatomic) BrandModel *carModel;

@property (copy, nonatomic) CarCheXingModel *carCheXingModel;

@property (copy, nonatomic) ReduceBrandSelectLevel levelBlock;

@property (copy, nonatomic) ChildIdsBlock childBlock;

@property (copy, nonatomic) NSString *selectLevel;
@property(nonatomic,copy) NSString *carID;
@property(nonatomic,copy) NSString *carTypeID;

@end
