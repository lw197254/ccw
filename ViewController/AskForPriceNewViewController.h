//
//  AskForPriceViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "CarTypeDetailModel.h"
@interface AskForPriceNewViewController : ParentViewController
///车系id
@property(nonatomic,copy)NSString*carSerieasId;
@property(nonatomic,copy)NSString*imageUrl;
///车型id （车系id, 车型id传一个即可）
@property(nonatomic,copy)NSString*carTypeId;
///城市id （可选）
@property(nonatomic,copy)NSString*cityId;
@property(nonatomic,copy)NSString*cityName;
///如果是经销商传下面2个参数
@property(nonatomic,copy)NSString*carTypeName;

@property(nonatomic,copy)NSString*delearId;
@end
