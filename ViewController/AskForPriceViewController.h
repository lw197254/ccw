//
//  AskForPriceViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "CarTypeDetailModel.h"
@interface AskForPriceViewController : ParentViewController
//车系，车型id传一个即可
///车系id
@property(nonatomic,copy)NSString*carSerieasId;
///车型id
@property(nonatomic,copy)NSString*carTypeId;

///城市地址
@property(nonatomic,copy)NSString*cityName;

///城市id （可选）
@property(nonatomic,copy)NSString*cityId;
///如果是经销商传下面2个参数
@property(nonatomic,copy)NSString*carTypeName;
///经销商 （可选）
@property(nonatomic,copy)NSString*delearId;
@end
