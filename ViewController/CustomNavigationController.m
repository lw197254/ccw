//
//  CustomViewController.m
//  12123
//
//  Created by 刘伟 on 2016/11/4.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "CustomNavigationController.h"
#import "FatherViewModel.h"
#import "VideoViewController.h"
@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.rt_viewControllers.count ==1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    UIViewController*view = [super popViewControllerAnimated:animated];
     [self cancelRequestWithViewController:view];
    return view;
}
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
   NSArray*viewControllers= [super popToViewController:viewController animated:animated];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self cancelRequestWithViewController:obj];
    }];
    return viewControllers;
}
///当前界面pop后取消网络请求
-(void)cancelRequestWithViewController:(UIViewController*)vc{
//    unsigned int outCount;
//    objc_property_t*properties = class_copyPropertyList([vc class], &outCount);
//    for (NSInteger i = 0; i < outCount; i++) {
//        objc_property_t prop = properties[i];
//        const char*char_f = property_getName(prop);
//        NSString*propertyName = [NSString stringWithUTF8String:char_f];
//        
//        id proPertyValue = [vc valueForKey:propertyName];
//        if ([proPertyValue isKindOfClass:[FatherViewModel class]]) {
//            FatherViewModel*viewModel = proPertyValue;
//            unsigned int outCount1;
//            objc_property_t*properties1 = class_copyPropertyList([viewModel class], &outCount1);
//            for (NSInteger i = 0; i < outCount1; i++) {
//                objc_property_t prop1 = properties1[i];
//                const char*char_f1 = property_getName(prop1);
//                NSString*propertyName1 = [NSString stringWithUTF8String:char_f1];
//                
//                id proPertyValue1 = [viewModel valueForKey:propertyName1];
//                if ([proPertyValue1 isKindOfClass:[FatherRequest class]]) {
//                    FatherRequest*request = proPertyValue1;
//                    [request cancle];
//                }
//            }
//        }
//        //        if (proPertyValue) {
//        //            [props setObject:proPertyValue forKey:propertyName];
//        //        }
//        
////        NSObject *temp = proPertyValue;
////        NSLog(@"%@计数器是:%d",propertyName,CFGetRetainCount((__bridge CFTypeRef)(temp)));
//    }
//    free(properties);

}


-(BOOL)shouldAutorotate
{
    UIViewController * last = [self.rt_viewControllers lastObject];
    if ([last isKindOfClass:[VideoViewController class]]) {
        NSLog(@"VideoViewController");
        return NO;
    }
    //除le 其余的viewcontroller
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
        return [self.rt_viewControllers.lastObject
                supportedInterfaceOrientations];
}
-
(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.rt_viewControllers.lastObject
            preferredInterfaceOrientationForPresentation];
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
