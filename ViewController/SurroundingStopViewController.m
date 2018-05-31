//
//  SurroundingStopViewController.m
//  12123
//
//  Created by 刘伟 on 2016/10/20.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "SurroundingStopViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "CustomPinAnnotationView.h"
#import "HomeAlertView.h"
#import "AFNetworking.h"
#import "WZpointModel.h"
#import "PanoControlViewController.h"
#import "CustomAnimation.h"

@interface SurroundingStopViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>

//@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) BMKMapView *mapView;
@property(nonatomic,strong)BMKPoiSearch*poisearch;

@property(nonatomic,assign)CLLocationCoordinate2D userLocation;
@property(nonatomic,strong)BMKLocationService* locService;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property(nonatomic,strong)NSMutableArray*stopPointModelArray;
@property(nonatomic,strong)NSArray * mapTypeArray;
@property(nonatomic,strong)NSMutableArray * trafficPointModelArray;
@property(nonatomic,assign)BOOL userLocationDidUpdated;
@property (weak, nonatomic) IBOutlet UIButton *trafficConditionButton;
@property(nonatomic,copy)NSString*titleString;
@end
NSString * const trafficAll = @"全部";
NSString * const trafficHighHappen = @"违章高发地";
NSString * const trafficCondition = @"实时路况";
NSString * const trafficStop = @"周边停车";
@implementation SurroundingStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight-20-44)];
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    self.mapTypeArray = @[trafficAll,trafficHighHappen,trafficCondition,trafficStop];
    self.titleString =self.mapTypeArray[self.mapType];
    [self showNavigationTitle:self.titleString];
    _locService = [[BMKLocationService alloc]init];
//    self.mapView = [[BMKMapView alloc]init];
//    [self.view addSubview:_mapView];
//    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    _stopPointModelArray = [[NSMutableArray alloc]init];
    // 设置地图级别
    [_mapView setZoomLevel:13];
    
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    _mapView.isSelectedAnnotationViewFront = YES;
    
    _poisearch = [[BMKPoiSearch alloc]init];
    //开启定位
    _locService.delegate = self;
    [_locService startUserLocationService];
   
    [self createRightButtonItem];
    // Do any additional setup after loading the view from its nib.
//    _mapView.frame = CGRectMake(0, _mapView.frame.origin.y, _mapView.frame.size.width, self.view.frame.size.height - _mapView.frame.origin.y);
//      _mapView.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0);

    //是否显示比例尺
    _mapView.showMapScaleBar = YES;
    //比例尺高度
    
    [self.view layoutIfNeeded];
    CGRect frame = self.locationButton.frame;
    _mapView.mapScaleBarPosition = CGPointMake(frame.origin.x+frame.size.width+12, self.mapView.frame.size.height - frame.size.height);
}
///
-(void)setUserLocationDidUpdated:(BOOL)userLocationDidUpdated{
    if (_userLocationDidUpdated!=userLocationDidUpdated) {
        _userLocationDidUpdated = userLocationDidUpdated;
        //定位更新以后，刷新界面
        if (_userLocationDidUpdated) {
            [self refresh];
        }
       
       
    }
}
//创建右上角的刷新，选项切换按钮
-(void)createRightButtonItem{
    UIButton*buttonLeft = [Tool createButtonWithImage:[UIImage imageNamed:@"筛选"] target:self action:@selector(showSelect) tag:0];
    buttonLeft.frame = CGRectMake(0, 0, 22, 22);
    UIButton*buttonRight = [Tool createButtonWithImage:[UIImage imageNamed:@"刷新"] target:self action:@selector(refresh) tag:0];
    buttonRight.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem*itemLeft = [[UIBarButtonItem alloc]initWithCustomView:buttonLeft];
    UIBarButtonItem*itemRight = [[UIBarButtonItem alloc]initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItems = @[itemLeft,itemRight];
}
//展示右上角的选项
-(void)showSelect{
    [[HomeAlertView shareInstanceWithItemArray: self.mapTypeArray itemSelected:^(NSString *itemTitle, NSInteger itemIndex) {
        self.mapType = itemIndex;
        [self refresh];
    } cancel:^{
        
    }] show];
}
//刷新界面
-(void)refresh{
    if(self.userLocationDidUpdated==NO){
        return;
    }
    
       switch (self.mapType) {
           case MapTypeAll:{
               
               [self.mapView removeAnnotations:self.stopPointModelArray];
             
               if (![self.titleString isEqualToString:trafficAll]) {
                   [self showNavigationTitle:trafficAll];
                   self.titleString = trafficAll;
               }
               [self.mapView removeAnnotations:self.trafficPointModelArray];
               [self.mapView removeAnnotations:self.stopPointModelArray];
               self.mapView.trafficEnabled = YES;
               self.trafficConditionButton.selected = YES;
               [self surroundingStop];
               [self afnetworkingWZcall];
           }
               
               break;
        case MapTypeTrafficCondition:{
            
            [self.mapView removeAnnotations:self.stopPointModelArray];
            if (![self.titleString isEqualToString:trafficCondition]) {
                [self showNavigationTitle:trafficCondition];
                self.titleString = trafficCondition;
            }
            [self.mapView removeAnnotations:self.trafficPointModelArray];
            [self.mapView removeAnnotations:self.stopPointModelArray];
            self.mapView.trafficEnabled = YES;
            self.trafficConditionButton.selected = YES;
        }
            
            break;
        case MapTypeSurroundingStop:{
            if (![self.titleString isEqualToString:trafficStop]) {
                [self showNavigationTitle:trafficStop];
                self.titleString = trafficStop;
            }
            [self.mapView removeAnnotations:self.trafficPointModelArray];
            [self.mapView removeAnnotations:self.stopPointModelArray];
            self.trafficConditionButton.selected = NO;
            self.mapView.trafficEnabled = NO;
            [self surroundingStop];
            
        }
            
            break;
        case MapTypeTrafficHighHappened:{
           
            if (![self.titleString isEqualToString:trafficHighHappen]) {
               
                self.titleString = trafficHighHappen;
                 [self showNavigationTitle:trafficHighHappen];
            }
            [self.mapView removeAnnotations:self.trafficPointModelArray];
            [self.mapView removeAnnotations:self.stopPointModelArray];
             self.trafficConditionButton.selected = NO;
            self.mapView.trafficEnabled = NO;
            [self afnetworkingWZcall];
        }
            
            break;
            
        default:
            break;
    }
    
}
-(void)surroundingStop{
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc]init];
    nearbySearchOption.location = self.userLocation;
    nearbySearchOption.radius = 10000;
    NSString*keyword = @"停车场";
    if (self.mapType == MapTypeTrafficHighHappened) {
        keyword = trafficHighHappen;
    }
    nearbySearchOption.keyword = keyword;
    nearbySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;
    BOOL flag = [_poisearch poiSearchNearBy: nearbySearchOption];
    if(flag)
    {
        //        _nextPageButton.enabled = true;
        NSLog(@"城市内检索发送成功");
        //        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"%@已更新",keyword]];
    }
    else
    {
        //        _nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[NSString stringWithFormat:@"%@更新失败",keyword]];
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

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].keyWindow textOnly:@"定位失败"];
}


/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    self.userLocation = userLocation.location.coordinate;
    
    self.userLocationDidUpdated = YES;
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
        if (annotationView == nil) {
            annotationView = [[CustomPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            ((CustomPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            // 设置重天上掉下的效果(annotation)
//            ((CustomPinAnnotationView*)annotationView).animatesDrop = YES;
        }
    
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    
        annotationView.canShowCallout = YES;
        // 设置是否可以拖拽
        annotationView.draggable = NO;
    if(((CustomAnimation*)annotation).isStop ==YES){
      annotationView.image = [UIImage imageNamed:@"停车"];
    }else{
        annotationView.image = [UIImage imageNamed:@"定位blue"];
    }
   
    ((CustomPinAnnotationView*)annotationView).indexString =((CustomAnimation*)annotation).positionName;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    
    
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            CustomAnimation* item = [[CustomAnimation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.positionName = @"P";
            item.isStop = YES;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [self.stopPointModelArray addObjectsFromArray:annotations];
        [_mapView showAnnotations:annotations animated:YES];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"周边停车场更新成功"];
           } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}
///路况
- (IBAction)trafficClicked:(UIButton *)sender {
    sender.selected =!sender.selected;
    self.mapView.trafficEnabled = sender.selected;
}
//全景
- (IBAction)paroMapClicked:(UIButton *)sender {
   
    if (self.userLocationDidUpdated) {
         PanoControlViewController*vc = [[PanoControlViewController alloc]init];
        vc.userLocation = self.userLocation;
        [self.navigationController pushViewController:vc animated:YES];
 
    }else{
        [AlertView showAlertWithMessage:@"定位失败，无法使用全景地图"];
    }
}
//位置,重新在地图上更新，将当前的用户位置设为未更新，通过位置更新后重新加载当前位置的高发地或者周边停车
- (IBAction)licationClicked:(UIButton *)sender {
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    self.userLocationDidUpdated = NO;
}
//加  3-21地图比例尺范围
- (IBAction)plusClicked:(UIButton *)sender {
    if(_mapView.zoomLevel < 21){
        _mapView.zoomLevel++;
    }
}
//减
- (IBAction)minusClicked:(UIButton *)sender {
    if(_mapView.zoomLevel > 3){
        _mapView.zoomLevel--;
    }
}

-(void)traffic:(UIButton*)button{
    button.selected =!button.selected;
    self.mapView.trafficEnabled = button.selected;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
     _locService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//加入违章高发地查询
-(void)afnetworkingWZcall{
    
    NSString *url = @"http://v.juhe.cn/wzpoints/query";

    NSString *key = @"0e694dfc9636e55289a1e943791d8977";
    
    NSNumber *num1 = [NSNumber numberWithDouble:self.userLocation.latitude];
    NSString *lat = [num1 stringValue];
    
    NSNumber *num2 = [NSNumber numberWithDouble:self.userLocation.longitude];
    NSString *lon = [num2 stringValue];
    NSString *r =@"2000";
    
    NSString *pagesize = @"40";
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    NSDictionary *dic = @{@"key":key,@"lat":lat,@"lon":lon,@"pagesize":pagesize,@"r":r};
    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        if(responseObject){
            
             self.trafficPointModelArray = [NSMutableArray array];
            if (![responseObject[@"result"][@"list"] isKindOfClass:[NSArray class]]) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"违章高发地更新失败"];
                return ;
            }
            
            
            NSArray*array = responseObject[@"result"][@"list"];
            
            [self.trafficPointModelArray removeAllObjects];
            
            int i = 1;
  
            for (NSDictionary *dict in array) {
      
                NSError*error;
                WZpointModel*pointModel = [[WZpointModel alloc]initWithDictionary:dict error:&error];
                
//                BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
                CustomAnimation*item = [[CustomAnimation alloc]init];
                CLLocationCoordinate2D coor;
                coor.latitude =[[pointModel.location objectAtIndex:1]doubleValue];
                coor.longitude =[[pointModel.location objectAtIndex:0]doubleValue];
                item.coordinate = coor;
                item.positionName = [NSString stringWithFormat:@"%d",i+1];
                item.title = pointModel.address;
                item.isStop =NO;
                // 把模型加到arrayModels中
                [self.trafficPointModelArray addObject:item];
                i++;
            }
        
  
           
            [_mapView addAnnotations:self.trafficPointModelArray];
            [_mapView showAnnotations:_trafficPointModelArray animated:YES];
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"违章高发地更新成功"];
 
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
          [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"违章高发地更新失败"];
    }];
    
}


@end
