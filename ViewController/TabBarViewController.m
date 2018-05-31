//
//  TabBarViewController.m
//  TMC_lutao
//
//  Created by 刘伟 on 16/3/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "TabBarViewController.h"
#import "ParentViewController.h"
#import "CustomNavigationController.h"

#import "BaseCollectionViewController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>
@property(nonatomic,copy) NSString *oldAgent;
@property(nonatomic,strong) NSMutableArray *olderViewControllerArray;



@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray*array = @[
  @{@"VC":@"HomeViewController",@"title":@"首页",@"imageName":@"btn_home_n",@"selectedImageName":@"btn_home_s"},
   @{@"VC":@"FindCarViewController",@"title":@"选车",@"imageName":@"btn_car_n.png",@"selectedImageName":@"btn_car_s"}
  , @{@"VC":@"FindViewController",@"title":@"发现",@"imageName":@"发现",@"selectedImageName":@"发现选中"}
  ,
  @{@"VC":@"OtherViewController",@"title":@"我的",@"imageName":@"btn_my_n.png",@"selectedImageName":@"btn_my_s"}
 ];
//    @{@"VC":@"PriceViewController",@"title":@"汽车报价",@"imageName":@"personCenter.png",@"selectedImageName":@"personCenterSelected.png"},
    NSMutableArray*controllers = [[NSMutableArray alloc]init];
    for(NSInteger i = 0; i <array.count;i++ ){
        
        NSDictionary*dict = array[i];
        Class class = NSClassFromString(dict[@"VC"]);
        ParentViewController*vc = [[class alloc]init];
        CustomNavigationController*nav = [[CustomNavigationController alloc]initWithRootViewController:vc];
        nav.tabBarItem.title = dict[@"title"];
        
      UIImage*selectedImage =   [UIImage imageNamed:dict[@"selectedImageName"]];
      selectedImage =   [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//        vc.hidesBottomBarWhenPushed = YES;
        nav.tabBarItem.selectedImage = selectedImage;
        UIImage*normalImage =   [UIImage imageNamed:dict[@"imageName"]];
        normalImage =   [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.image = normalImage;
        [controllers addObject:nav];
    }
    self.tabBar.tintColor = BlueColor447FF5;
    
   
    self.viewControllers = controllers;
    self.oldViewContoller = [self.viewControllers firstObject];
    self.tabBar.translucent = YES;
    @weakify(self);
    [RACObserve(self,selectedViewController )subscribeNext:^(id x) {
        if (!self.olderViewControllerArray) {
            self.olderViewControllerArray  = [NSMutableArray array];
            
        }
        
        [self.olderViewControllerArray addObject:self.selectedViewController];
        if (self.olderViewControllerArray.count >2) {
            [self.olderViewControllerArray removeObjectAtIndex:0];
        }
        self.oldViewContoller = [self.olderViewControllerArray firstObject];
        @strongify(self);
        switch (self.selectedIndex) {
            case 0:
                ///首页
//                [self removeWebViewAgent];
//                [MobClick event:home];
                break;
            case 1:{
//                找车
//               [self setWebViewAgent];
//                [MobClick event:search_car];
                break;
            }
            case 2:
//                其他
//                [self removeWebViewAgent];
//                [MobClick event:newspage];
                break;
            case 3:
//                我的
//                [self removeWebViewAgent];
//                [MobClick event:minepage];
                break;
                
            default:
                break;
        }
    }];
    // Do any additional setup after loading the view.
}


 -(void)setWebViewAgent{
         UIWebView *webview = [[UIWebView alloc] init];
     if (!self.oldAgent.isNotEmpty) {
         self.oldAgent = [webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
     }
     
         
         //add my info to the new agent
         NSString *newAgent = [self.oldAgent stringByAppendingString:@"client_app client_app_wz_ios"];
         NSLog(@"new agent :%@", newAgent);
         
         //regist the new agent
         NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent",nil];
         
         [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
     }
-(void)removeWebViewAgent{
         if (self.oldAgent.isNotEmpty) {
             NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:self.oldAgent, @"UserAgent",nil];
             
             [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];

         }
         
     
}
-(BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
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
