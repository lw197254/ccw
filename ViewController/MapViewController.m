//
//  MapViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CustomPinAnnotationView.h"
#import "CustomAnimation.h"
#import "BMKGeometry.h"
@interface MapViewController ()<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"地图"];
    
    self.mapView.delegate  = self;
    
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 地图
-(void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    [self addMap];
}
-(void)addMap{
    
    
    __block  CGFloat minLat = 0;
    __block  CGFloat maxLat = 0;
    __block CGFloat minLon = 0;
    __block  CGFloat maxLon = 0;
    
    
    [self.animationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CustomAnimation* item = obj;
        
        if (minLon==0) {
            minLon = item.coordinate.longitude;
        }
        if (minLat ==0) {
            minLat = item.coordinate.latitude;
            
        }
        
        minLat = (minLat < item.coordinate.latitude?minLat:item.coordinate.latitude);
        maxLat = (maxLat > item.coordinate.latitude?maxLat:item.coordinate.latitude);
        minLon = (minLon < item.coordinate.longitude?minLon:item.coordinate.longitude);
        maxLon = (maxLon > item.coordinate.longitude?maxLon:item.coordinate.longitude);
        
        
    }];
    //计算中心点
    CLLocationCoordinate2D centCoor;
    centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
    centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
    BMKCoordinateSpan span;
    //计算地理位置的跨度
    span.latitudeDelta = maxLat - minLat;
    span.longitudeDelta = maxLon - minLon;
    //得出数据的坐标区域
    BMKCoordinateRegion region = BMKCoordinateRegionMake(centCoor, span);
    
    
    [self.mapView addAnnotations:self.animationArray];
    if (self.animationArray.count >=1) {
        [self.mapView selectAnnotation: [self.animationArray firstObject] animated:NO];
    }
    
    //百度地图的坐标范围转换成相对视图的位置
    CGRect fitRect = [self.mapView convertRegion:region toRectToView:self.mapView];
    NSLog(@"%f,%f,%f,%f",fitRect.origin.x,fitRect.origin.y,fitRect.size.width,fitRect.size.height);
    NSInteger width = 15;
    NSInteger height = 15;
    fitRect.origin.x -= width;
    fitRect.origin.y -=height;
    fitRect.size.width  += (width*2);
    fitRect.size.height += (height*2);
    NSLog(@"%f,%f,%f,%f",fitRect.origin.x,fitRect.origin.y,fitRect.size.width,fitRect.size.height);
    //将地图视图的位置转换成地图的位置，
    BMKMapRect fitMapRect = [self.mapView convertRect:fitRect toMapRectFromView:self.mapView];
    //    BMKMapRect rect = [self.moreStoreAndMapCell.mapView mapRectThatFits:fitMapRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)];
    //         [self.moreStoreAndMapCell.mapView showAnnotations:self.animationArray animated:YES];
    
    //设置地图可视范围为数据所在的地图位置
    [self.mapView setVisibleMapRect:fitMapRect animated:YES];
    
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    NSString *AnnotationViewID = @"parking";
    BMKAnnotationView* annotationView;
    //    if(((CustomAnimation*)annotation).isStop ==YES){
    //        AnnotationViewID = @"parking";
    //        // 生成重用标示identifier
    //
    //
    //        // 检查是否有重用的缓存
    //        annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    //
    //        // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    //        if (annotationView == nil) {
    //            annotationView = [[CustomPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    //            //            ((CustomPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
    //            // 设置重天上掉下的效果(annotation)
    //            //            ((CustomPinAnnotationView*)annotationView).animatesDrop = YES;
    //        }
    //
    //        annotationView.image = [UIImage imageNamed:@"停车"];
    //        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    //        annotationView.canShowCallout = YES;
    //    }else{
    AnnotationViewID = @"location";
    // 生成重用标示identifier
    
    
    // 检查是否有重用的缓存
    annotationView= [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[CustomPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        //            ((CustomPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        //            ((CustomPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.image = [UIImage imageNamed:@"定位红"];
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    //        [annotationView addGestureRecognizer:tap];
    //    }
    
    //    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth-100, 50)];
    //    popView.backgroundColor = [UIColor whiteColor];
    //    [popView.layer setMasksToBounds:YES];
    //    [popView.layer setCornerRadius:3.0];
    //    popView.alpha = 0.9;
    //    //        //设置弹出气泡图片
    //    //        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:tt.imgPath]];
    //    //        image.frame = CGRectMake(0, 160, 50, 60);
    //    //        [popView addSubview:image];
    //
    //    //自定义气泡的内容，添加子控件在popView上
    //    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(8, 4, 160, 30)];
    //    driverName.text = annotation.title;
    //    driverName.numberOfLines = 0;
    //    driverName.backgroundColor = [UIColor clearColor];
    //    driverName.font = [UIFont systemFontOfSize:15];
    //    driverName.textColor = [UIColor blackColor];
    //    driverName.textAlignment = NSTextAlignmentLeft;
    //    [popView addSubview:driverName];
    //
    //    UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 180, 30)];
    //    carName.text = annotation.subtitle;
    //    carName.backgroundColor = [UIColor clearColor];
    //    carName.font = [UIFont systemFontOfSize:11];
    //    carName.textColor = [UIColor lightGrayColor];
    //    carName.textAlignment = NSTextAlignmentLeft;
    //    [popView addSubview:carName];
    //
    //    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    ////    pView.frame = CGRectMake(0, 0, ScreenWidth-100, popViewH);
    //
    //    annotationView.paopaoView = pView;
    
    // 设置位置
    //    annotationView.centerOffset = CGPointMake(annotationView.frame.size.width, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    ((CustomPinAnnotationView*)annotationView).indexString =((CustomAnimation*)annotation).positionName;
    //真是的数字
    int realcount = [((CustomAnimation*)annotation).positionName intValue]-2;
    if(realcount < 0){
        realcount = 0;
    }
    annotationView.tag = realcount;
    
    return annotationView;
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    
    BMKMapRect fitMapRect =  mapView.visibleMapRect;
    CGRect fitRect = [mapView convertMapRect:fitMapRect toRectToView:mapView];
    NSInteger height = 65;
    if (view.frame.origin.y < height) {
        height = height - view.frame.origin.y;
    }else if(mapView.frame.size.height - view.frame.origin.y < 35){
        height = mapView.frame.size.height - view.frame.origin.y-35;
    }else{
        height = 0;
    }
    
    
    fitRect.origin.y -=height;
    
    
    NSLog(@"%f,%f,%f,%f",fitRect.origin.x,fitRect.origin.y,fitRect.size.width,fitRect.size.height);
    //将地图视图的位置转换成地图的位置，
    fitMapRect = [mapView convertRect:fitRect toMapRectFromView:mapView];
    
    [mapView setVisibleMapRect:fitMapRect animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.rt_navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.rt_navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
