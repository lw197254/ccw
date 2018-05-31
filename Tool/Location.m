//
//  Location.m
//  TMC_convenientTravel
//
//  Created by 刘伟 on 16/7/11.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "Location.h"

#import "LocationViewModel.h"
#import "DialogView.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CustomAlertView.h"
@interface Location()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,strong)BMKGeoCodeSearch* geocodesearch;
//@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy)LocationSuccessBlock successBlock;
@property(nonatomic,copy)LocationFailedBlock failedBlock;
@property(nonatomic,assign)BOOL needCityId;
///权限是否显示alert  default ==YES
@property(nonatomic,assign)BOOL loactionPermissionErrorAlertShow;

@property(nonatomic,strong)LocationViewModel *viewModel;

//@property(nonatomic,copy)NSString*cityName;
@end
@implementation Location

+(instancetype)shareInstance{
   static Location * instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class]alloc]init];
        
    });
    return instance;
}
-(instancetype)init{
    if(self = [super init]){
        _historyLocationModel = [[LocationModel alloc]init];
        self.loactionPermissionErrorAlertShow = YES;
        _city = _historyLocationModel.city;
        _cityId= _historyLocationModel.cityId;
        _address = _historyLocationModel.address;
        _coordinate = CLLocationCoordinate2DMake(_historyLocationModel.lat, _historyLocationModel.lon);
          _locService = [[BMKLocationService alloc]init];
        // 设置代理
        _locService.delegate = self;
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self; // 不用时，置nil
        // 设置定位精确度到米
        _locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
       
//    // 开始定位
//    [_locationManager startUpdatingLocation];

    }
    return self;
}
-(void)startLocationSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock loactionPermissionErrorAlertShow:(BOOL)loactionPermissionErrorAlertShow{
    self.loactionPermissionErrorAlertShow = loactionPermissionErrorAlertShow;
     self.needCityId = NO;
    if (finishLocationBlock!=_successBlock) {
        _successBlock = finishLocationBlock;
    }
    if (failedBlock!=_failedBlock) {
        _failedBlock = failedBlock;
    }
 
        [_locService startUserLocationService];
    
    
}
-(void)startLocationNeedCityIDSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock loactionPermissionErrorAlertShow:(BOOL)loactionPermissionErrorAlertShow{
    self.loactionPermissionErrorAlertShow = loactionPermissionErrorAlertShow;
    self.needCityId = YES;
    if (finishLocationBlock!=_successBlock) {
        _successBlock = finishLocationBlock;
    }
    if (failedBlock!=_failedBlock) {
        _failedBlock = failedBlock;
    }
    [_locService startUserLocationService];
}
-(void)startLocationNeedCityIDSuccess:(LocationSuccessBlock)finishLocationBlock failed:(LocationFailedBlock)failedBlock{
    [self startLocationNeedCityIDSuccess:finishLocationBlock failed:failedBlock loactionPermissionErrorAlertShow:YES];

}
#pragma mark ---- 定位成功  代理
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
    
    //取得CLLocation对象
    CLLocation *location = userLocation.location ;
    
    
    
    // 获取当前所在的城市名
    
  
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

  
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
        if (error == 0) {
     
        
                
                //获取城市
            NSString *city = result.addressDetail.city;
                //获取地址
            NSString *address = result.address;
                //全局赋值
                self.address = address;
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                self.city = city;
                self.coordinate  = result.location;
                if (self.needCityId) {
                    if (!self.viewModel) {
                        self.viewModel = [LocationViewModel SceneModel];
                        @weakify(self);
                        [[RACObserve(self.viewModel, cityId)filter:^BOOL(id value) {
                            @strongify(self);
                            return self.viewModel.cityId.isNotEmpty;
                        }]subscribeNext:^(id x) {
                            @strongify(self);
                            self.cityId = self.viewModel.cityId;
                            
                            
                            if (self.successBlock) {
                                
                                self.successBlock(self.coordinate,city,address);
                            }
                            
                        }];
                        [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
                            @strongify(self);
                            return self.viewModel.request.failed;
                        }]subscribeNext:^(id x) {
                            @strongify(self);
                            
                            
                            if (self.failedBlock) {
                                
                                self.failedBlock(@"定位失败");
                            }
                            
                        }];
                    }
                    self.viewModel.request.cityname = city;
                    self.viewModel.request.startRequest = YES;
                    
                    
                }else{
                    
                    if (self.successBlock) {
                        
                        self.successBlock(self.coordinate,city,address);
                    }
                }
                
                
            
        }else{
            NSString* errorString = @"没有结果返回";
                      if (self.failedBlock) {
                self.failedBlock(errorString);
            }

        }
    
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_locService stopUserLocationService];
    NSString*errorString = @"定位错误";
    if ([error code]==kCLErrorLocationUnknown) {
        errorString =  @"无法获取位置信息";
    }else if ([error code]==kCLErrorDenied) {
        errorString= @"检测地理位置信息失败，\n请到权限管理中进行修改!";
        if (self.loactionPermissionErrorAlertShow==YES) {
            [[CustomAlertView alertView]showWithTitle:nil message:errorString cancelButtonTitle:@"取消" confirmButtonTitle:@"前往修改" cancel:^{
                
            } confirm:^{
                [self editPermission];
            }];
        }
        if (self.failedBlock) {
            self.failedBlock(nil);
        }
        return;
    }

    if (self.failedBlock) {
        self.failedBlock(errorString);
    }

}
-(void)editPermission{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
        
    }
}
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation *> *)locations
//{
////    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
//    
//    //取得CLLocation对象
//    CLLocation *location = [locations lastObject];
//    
//  
//    
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count > 0){
//            @weakify(self);
//            CLPlacemark *placemark = [placemarks firstObject];
//        
//            //获取城市
//            NSString *city = placemark.locality;
//            //获取地址
//            NSString *address = [placemark.locality stringByAppendingFormat:@"%@%@",
//                                 placemark.subLocality,placemark.name];//placemark.subLocality+placemark.name;
//            //全局赋值
//            self.address = address;
//            if (!city) {
//                city = placemark.administrativeArea;
//              
//            }
//             city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
//            self.city = city;
//            self.coordinate  = location.coordinate;
//                       if (self.needCityId) {
//                if (!self.viewModel) {
//                     self.viewModel = [LocationViewModel SceneModel];
//                    [[RACObserve(self.viewModel, cityId)filter:^BOOL(id value) {
//                        @strongify(self);
//                        return self.viewModel.cityId.isNotEmpty;
//                    }]subscribeNext:^(id x) {
//                        @strongify(self);
//                        self.cityId = self.viewModel.cityId;
//                       
//                       
//                        if (self.successBlock) {
//                            
//                            self.successBlock(location.coordinate,city,address);
//                        }
//
//                    }];
//                    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
//                        @strongify(self);
//                        return self.viewModel.request.failed;
//                    }]subscribeNext:^(id x) {
//                        @strongify(self);
//                       
//                        
//                        if (self.failedBlock) {
//                            
//                            self.failedBlock(@"定位失败");
//                        }
//                        
//                    }];
//                }
//                self.viewModel.request.cityname = city;
//                self.viewModel.request.startRequest = YES;
//                
//                
//                            }else{
//                                
//                if (self.successBlock) {
//                   
//                    self.successBlock(location.coordinate,city,address);
//                }
//            }
//            
//            
//        }else{
//            NSString*errorString = @"定位错误";
//             if (error == nil && [placemarks count] == 0)
//            {
//               errorString = @"没有结果返回";
//            }
//            else if (error != nil)
//            {
//                
//               errorString = [NSString stringWithFormat:@"定位 error  = %@", error.description];
//            }
//            if (self.failedBlock) {
//                self.failedBlock(errorString);
//            }
//
//        }
//        
//    }];
//}
/**
 *定位失败，回调此方法
 */
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//     [manager stopUpdatingLocation];
//    NSString*errorString = @"定位错误";
//    if ([error code]==kCLErrorDenied) {
//        errorString= @"检测地理位置信息失败，\n请到权限管理中进行修改!";
//    }
//    if ([error code]==kCLErrorLocationUnknown) {
//        errorString =  @"无法获取位置信息";
//    }
//    if (self.failedBlock) {
//        self.failedBlock(errorString);
//    }
//    
//}
-(void)dealloc{
    self.locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
}
@end
