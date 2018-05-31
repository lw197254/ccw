//
//  ActiveViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/5.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ActiveViewController.h"




#import "CityViewController.h"
#import "ActionSceneModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ActiveViewModel.h"

//分享
#import "ArtPopView.h"
#import "ShareModel.h"
#import "SharePlatform.h"
#import "MyUMShare.h"

@interface ActiveViewController ()
@property (strong, nonatomic) UIButton *cityButton;
@property (strong, nonatomic) ActiveViewModel *viewModel;
@property (copy, nonatomic) NSString *cityId;
@property(nonatomic,strong)id webViewContext;


@property(nonatomic,strong)JSContext *webViewShareContext;
@property(nonatomic,strong)ArtPopView *artPopView;

@property(nonatomic,copy)NSString *sharetitle;
@property(nonatomic,copy)NSString *des;
@property(nonatomic,copy)NSString *imageurl;
@property(nonatomic,copy)NSString *linkurl;

@end

@implementation ActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.urlString = @"http://192.168.1.219:8080/api/testHttpHead";

//    self.viewModel = [ActiveViewModel SceneModel];
    //self.webView.scrollView.bounces = NO;
//    self.webView.delegate = self;
    
   
//    [[RACObserve(self.viewModel.request, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          return self.viewModel.request.succeed;
//      }]subscribeNext:^(id x) {
//          @strongify(self);
//          NSDictionary*dict = self.request.output;
//          NSError*error;
//          self.data = [[InfoBaseModel alloc]initWithDictionary:self.request.output[@"data"] error:&error];

//      }];
    if (self.cityShow) {

         [self showCity];
         @weakify(self);
        [[RACObserve([AreaNewModel shareInstanceSelectedInstance],id)filter:^BOOL(id value) {
            return [AreaNewModel shareInstanceSelectedInstance].id.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (![self.cityId isEqual:[AreaNewModel shareInstanceSelectedInstance].id]) {
                self.cityId = [AreaNewModel shareInstanceSelectedInstance].id;


            }

        }];


        [[RACObserve([AreaNewModel shareInstanceSelectedInstance],name)filter:^BOOL(id value) {
            return [AreaNewModel shareInstanceSelectedInstance].name.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self addjustButton:self.cityButton WithTitle:[AreaNewModel shareInstanceSelectedInstance].name];
            [self.cityButton exchangeImageAndTitle];
        }];
    }
   
    // Do any additional setup after loading the view.
}
-(void)showCity{
    if (!self.cityButton) {
        
        self.cityButton = [[UIButton alloc]initNavigationButtonWithTitle:@"" color:BlackColor333333 font:FontOfSize(14)];
          [self.cityButton setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
        [self.cityButton addTarget:self action:@selector(cityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.cityButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
       
        
    }
    [self showBarButton:NAV_RIGHT button:self.cityButton];

}
//城市选择
-(void)cityButtonClicked:(UIButton*)button{
    CityViewController*vc = [[CityViewController alloc]init];
   
    [self.rt_navigationController pushViewController:vc animated:YES];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
//    // 方法一
//    CGFloat height = [self.webView sizeThatFits:CGSizeZero].height;
//    
//    // 方法二
//    CGFloat height = webView.scrollView.contentSize.height;
   
    self.webViewContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    self.webViewContext[@"getCityId"] = self;
    @weakify(self);
   // NSString*str = [NSString stringWithFormat:@"getCityId(%@)",self.cityId];
    self.webViewContext[@"getCityId"] = ^NSString*(){
        @strongify(self);

        return self.cityId;
    };
    
    self.webViewShareContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.webViewShareContext[@"share"] = self;
    
    
    self.webViewShareContext[@"share"] = ^(NSString *title,NSString *des,NSString *imageurl,NSString *linkurl)    {
        //qq:1  朋友圈:2 qq空间：4
         @strongify(self);
          self.sharetitle = title;
          self.des = des;
          self.imageurl = imageurl;
          self.linkurl = linkurl;
          [self.artPopView show];
 
    };
    
}

-(ArtPopView *)artPopView{
    if (!_artPopView) {
        _artPopView = [[ArtPopView alloc] init];
        _artPopView.artPopViewType = ArtPopViewTypeShare;
        _artPopView.delegate = self;
        _artPopView.shareItems = [SharePlatform getSharePlatforms];
    }
    return _artPopView;
}


-(void)Handleclick:(ShareModel*) model{
    if ([model.name isEqualToString:@"微信"]) {
        [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeWechat title:self.sharetitle conent:self.des artUrl:self.linkurl picUrl:self.imageurl];
    }
    
    if ([model.name isEqualToString:@"朋友圈"]) {
        [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeWechatTimeline title:self.sharetitle conent:self.des artUrl:self.linkurl picUrl:self.imageurl];
    }
    
    if ([model.name isEqualToString:@"QQ好友"]) {
        [MyUMShare shareWithSSDKPlatform:SSDKPlatformTypeQQ title:self.sharetitle conent:self.des artUrl:self.linkurl picUrl:self.imageurl];
    }
    
    if ([model.name isEqualToString:@"QQ空间"]) {
        [MyUMShare shareWithSSDKPlatform:SSDKPlatformSubTypeQZone title:self.sharetitle conent:self.des artUrl:self.linkurl picUrl:self.imageurl];
    }
    
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
