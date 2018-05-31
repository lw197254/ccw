//
//  ParentViewController.m
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/2.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"
#import "FatherViewModel.h"

#import <cobub/cobub.h>

@interface ParentViewController ()<UINavigationBarDelegate>

@property(nonatomic,strong)UIView *popView;

@property(nonatomic,strong) UILabel *label;
///侧滑手势
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition*  interactiveTransition;
@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
       self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackgroundColor:[UIColor whiteColor]];
    self.rt_disableInteractivePop = YES;
//    self.navigationStyle = navigationStyleNormal;
///设置返回按钮颜色为白色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
   
//    [self showbackButtonwithTitle:@"返回"];
//     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonTouch)];
    
    //去掉阴影线
//    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:seperateLineColor];
    if(self.title.isNotEmpty){
        [self showNavigationTitle:self.title];
    }
    
       // Do any additional setup after loading the view.
}
-(void)setNavigationBackgroundColor:(UIColor*)color{
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color size:CGSizeMake(30, 30)] forBarMetrics:UIBarMetricsDefault];
    NSLog(@"%@",self.navigationController);
//    self.navigationController.navigationBar.translucent = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)createBackButtonWithTitle:(NSString*)title{
    _backButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"ic_back"]];
    [_backButton setImage:[UIImage imageNamed:@"ic_backSelected"] forState:UIControlStateHighlighted];
//    _backButton.frame = CGRectMake(0, 0, 80, 44);
//    [ _backButton setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [_backButton setTitle:title forState:UIControlStateNormal];
//    CGFloat width = [_backButton.titleLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
//    CGFloat imageWidth = [_backButton.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
//    _backButton.frame =CGRectMake(0, 0, width+ imageWidth+10, 44);
//    _backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
//    [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
//    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -width, 0, width)];
}
-(void)showbackButtonwithTitle:(NSString*)title{
    if([self.rt_navigationController.rt_viewControllers firstObject]!=self){
    [self createBackButtonWithTitle:title];
    [self showBarButton:NAV_LEFT button:_backButton];
    }
    
}

-(void)showNavigationWithImageName:(NSString*)imageName{
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [imageView sizeToFit];
    self.navigationItem.titleView = imageView;
}
-(void)showNavigationTitle:(NSString*)title{
    [self setNavigationtitle:title textColor:BlackColor333333 ];
}
-(void)setTitle:(NSString *)title{
    [self showNavigationTitle:title];
}
-(void)setNavigationtitle:(NSString*)text textColor:(UIColor*)textColor {
    
    UILabel*label = [Tool createLabelWithTitle:text frame:CGRectZero textColor:textColor tag:100];
    label.font =FontOfSize(17);
    self.navigationItem.titleView=label;
    [label sizeToFit];
  
}
-(void)setNavigationButtontitle:(NSString*)text textColor:(UIColor*)textColor {
    
    UIButton *button = [Tool createButtonWithImage:[UIImage imageNamed:@"箭头向下"] target:self action:@selector(topclick:) tag:1];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.text = text;

//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
//    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
//    button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
//    //button标题的偏移量，这个偏移量是相对于图片的
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.titleView=button;
    //[button sizeToFit];
    
}

-(void)topclick:(UIButton *)click{
    
}

-(void)refreshViewController{
    
}

- (void)showBarButton:(EzNavigationBar)position imageName:(NSString *)imageName{
    UIButton *button = [[UIButton alloc] initNavigationButton:[UIImage imageNamed:imageName]];
   

    [self showBarButton:position button:button];
}
- (void)showBarButton:(EzNavigationBar)position button:(UIButton *)button{
    if (position==NAV_LEFT) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
       
       
    }else{
         button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
         
        
    }
    [super showBarButton:position button:button];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [MobClick beginLogPageView:classNameFromClass(self.class)];
    [UMSAgent startTracPage:classNameFromClass(self.class)];
    
    if (self.rt_navigationController.rt_viewControllers.count >0&&[self.rt_navigationController.rt_viewControllers firstObject]!=self) {
        //        self.tabBarController.tabBar.hidden = YES;
        
        [self showbackButtonwithTitle:nil];
//        [self showBarButton:NAV_LEFT imageName:@"ic_back.png"];
    }else{
        //        self.tabBarController.tabBar.hidden = NO;
        
        
    }
   
    
   
    
    
}

 
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [UMSAgent endTracPage:classNameFromClass(self.class)];
    [MobClick endLogPageView:classNameFromClass(self.class)];
  
}///最左边pop手势，因为重写了leftButton，所以要重写代理方法，否则会
-(void)viewDidAppear:(BOOL)animated{
  
    __weak typeof(self)weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
     
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.rt_navigationController&&self.rt_navigationController.rt_viewControllers.count==1) {
        return NO;
    }else{
        return YES;
    }
}
-(void)addjustButton:(UIButton*)button WithTitle:(NSString*)title{
    [button setTitle:title forState:UIControlStateNormal];
    CGFloat  titleWidth = [button.titleLabel systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].width;
    if (titleWidth > 82) {
        titleWidth = 82;
    }
    if (button.imageView.image&&button.imageView.hidden ==NO) {
        CGFloat  imageWidth = [button.imageView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].width;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+5, 0, imageWidth);
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, titleWidth+imageWidth+10+5, 44);
    }else{
         button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, titleWidth+2, 44);
    }
   
}

-(void)leftButtonTouch{
    [self.rt_navigationController popViewControllerAnimated:YES];
    ///取消所有延迟的函数，防止一些函数影响界面
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
  
//    [self cancelAllRequestInCurrentVC];
}



//-(void)showNavigationBar{
//    self.navigitionBar = [[CustomNavigationBar alloc]init];
//    [self.view addSubview:self.navigitionBar];
//    [self.navigitionBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_equalTo(44);
//    }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

///车城网的方法
-(void)initCheRightButton:(UIButton *)button :(UIButton *)button1{
    
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
  
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightButtom = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
 
     UIBarButtonItem *rightButtom1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
 
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
   
    [array addObject:rightButtom1];
    [array addObject:rightButtom];
 
    
    self.navigationItem.rightBarButtonItems = array;
}

-(void)btnClick:(UIButton *)button{
}

-(void)showSaveSuccessWithTitle:(NSString*)title{
    if (self.popView ==nil) {
        self.popView = [[UIView alloc] init];
        
        [self.view addSubview:self.popView];
        
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(270);
        }];
        
        UIImageView *imagebackground = [[UIImageView alloc]init];
        
        self.label = [[UILabel alloc] init];
        
        self.label.font = FontOfSize(14);
        self.label.textColor = [UIColor whiteColor];
        
        [self.popView addSubview:self.label];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.popView);
            make.bottom.equalTo(self.popView.mas_bottom).offset(-12);
        }];
        
        [self.popView addSubview:imagebackground];
        [self.popView sendSubviewToBack:imagebackground];
        
        [imagebackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.popView);
        }];
        
        imagebackground.image = [UIImage imageNamed:@"toast_sc"];
    }
    self.label.text=title;
    
    self.popView.alpha = 1;
    
    [UIView animateWithDuration:2.f animations:^{
        self.popView.alpha = 0.f;
    }];

}
// 收藏成功
-(void)showSaveSuccess{
   
    [self showSaveSuccessWithTitle:@"收藏成功"];
    
}

-(UIView *)popView{
    if(!_popView){
        _popView = [[UIView alloc] init];
        
        [self.view addSubview:_popView];
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(270);
        }];
        
        UIImageView *imagebackground = [[UIImageView alloc]init];
        
        [_popView addSubview:imagebackground];
        [_popView sendSubviewToBack:imagebackground];
        
        [imagebackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_popView);
        }];
        
        imagebackground.image = [UIImage imageNamed:@"toast_sc"];
    }
    return _popView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = FontOfSize(14);
        _label.textColor = [UIColor whiteColor];
        
        [self.popView addSubview:self.label];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.popView);
            make.bottom.equalTo(self.popView.mas_bottom).offset(-12);
        }];
        
    }
    return _label;
}

-(void)showSaveRemoveWithTitle:(NSString*)title{
    
    self.label.text=title;
    self.popView.alpha = 1;
    [UIView animateWithDuration:2.f animations:^{
        self.popView.alpha = 0.f;
    }];

}
// 收藏取消
-(void)showSaveRemove{
   
    [self showSaveRemoveWithTitle:@"已取消"];
}

///这边是用来做经销商底部按钮
-(void)initButtonView{
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button1];
    [button1 setTitle:@"拨打电话" forState:UIControlStateNormal];
    [button1 setTitleColor:BlackColor333333 forState:UIControlStateNormal];
    button1.titleLabel.font = FontOfSize(16);
    [button1 setBackgroundColor:BlackColorF8F8F8];
    
    [button1 addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
         make.bottom.equalTo(self.view).with.offset(-SafeAreaBottom);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kwidth/2);
    }];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button2];
    [button2 setTitle:@"询底价" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font = FontOfSize(16);
    [button2 setBackgroundColor:BlueColor447FF5];
    
    [button2 addTarget:self action:@selector(askPrise:) forControlEvents:UIControlEventTouchUpInside];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(button1);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(kwidth/2);
    }];
    
}
-(void)askPrise:(UIButton *)sender
{
   
}

-(void)makeCall:(UIButton *)sender
{
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
   
}
-(void)setNavigationBarBottomLineHidden:(BOOL)navigationBarBottomLineHidden{
   
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    UIView*view = backgroundView.subviews.firstObject;
    
    if (navigationBarBottomLineHidden!=view.hidden) {
        view.hidden = navigationBarBottomLineHidden;
    }
    if (navigationBarBottomLineHidden!=_navigationBarBottomLineHidden) {
        _navigationBarBottomLineHidden = navigationBarBottomLineHidden;
    }
}

#ifdef DEBUG
///因为错误日志会后面的覆盖前面的，所以debug版本打印日志，release版本使用友盟统计，同理，setCobub 方法放到 [self setUmeng]之前，也是为了友盟错误统计能够使用，Cobub的错误统计废弃
-(void)dealloc{
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@消失了",classNameFromClass([self class])]);
}




#endif
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
