//
//  BuyCarCalculatorViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
@class BuyCarCalculatorDataModel;
///默认进来第一次选中是贷款还是全款
typedef NS_ENUM(NSInteger,BuyType){
    ///默认值全款
     BuyTypeQuanKuan = 0,
    ///贷款买车
    BuyTypeDaiKuan= 1
};
@interface BuyCarCalculatorViewController : ParentViewController
@property(nonatomic,copy)NSString*cheXingString;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,copy)NSString*paiLiangString;
@property(nonatomic,copy)NSString*seatNumber;
///默认为 BuyTypeDaiKuan
@property(nonatomic,assign)BuyType buyType;
///数据
@property(nonatomic,strong)BuyCarCalculatorDataModel*dataModel;
-(void)updateDataModel;

@property(nonatomic,copy)NSString*cheXingId;
@end
