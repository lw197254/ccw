//
//  Location.h
//  TMC_convenientTravel
//
//  Created by 刘伟 on 16/7/11.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "LocationModel.h"
typedef void(^LocationSuccessBlock)(CLLocationCoordinate2D coordinate,NSString *cityName,NSString*address);
typedef void(^LocationFailedBlock)(NSString*errorMessage);
@interface Location : NSObject
-(void)startLocationSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock loactionPermissionErrorAlertShow:(BOOL)loactionPermissionErrorAlertShow;
//-(void)startLocationSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock loactionPermissionErrorAlertShow:(BOOL)loactionPermissionErrorAlertShow withCache:(BOOL)withCache;
+(instancetype)shareInstance;
@property(nonatomic,copy)NSString*city;
@property(nonatomic,copy)NSString*cityId;
@property(nonatomic,copy)NSString*address;
@property(nonatomic,strong)LocationModel*historyLocationModel;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
-(void)startLocationNeedCityIDSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock;
-(void)startLocationNeedCityIDSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock loactionPermissionErrorAlertShow:(BOOL)loactionPermissionErrorAlertShow;
///开启定位权限
-(void)editPermission;
@end
