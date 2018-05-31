//
//  ShadowLoginViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ShadowLoginViewController.h"
#import "LoginUIView1.h"
#import "FastLoginView.h"

#import "RegistViewController.h"
#import "ForgetPasswordViewController.h"
#import "GetUserPushDynamicViewModel.h"
#import "XiHaoUserCheckTagsViewModel.h"

#import "TagsModel.h"



@interface ShadowLoginViewController ()<ShadowLoginViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) LoginUIView1 *view1;
@property (strong, nonatomic) FastLoginView *view2;

@property(nonatomic,strong)ThirdLoginObject*thirdLogin;
@property(nonatomic,strong)GetUserPushDynamicViewModel *viewModel;
@property(nonatomic,strong)XiHaoUserCheckTagsViewModel *tagViewModel;

@end


#define leftView @"leftView"
#define rightView @"rightView"

@implementation ShadowLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configUI];
    [self showNavigationTitle:@"密码登录"];
    [self showBarButton:NAV_RIGHT title:@"注册" fontColor:BlackColor333333];
 

}


-(void)configUI{
    [self.scrollview setContentSize:CGSizeMake(2*kwidth, kheight)];
    
    self.view2 = [[FastLoginView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight-64)];
    self.view2.showDelagate = self;
    [self.scrollview addSubview:self.view2];
    
    
    CGFloat x = CGRectGetMaxX(self.view2.frame);
    self.view1 = [[LoginUIView1 alloc] initWithFrame:CGRectMake(x, 0, kwidth, kheight-64)];
    self.view1.showDelagate = self;
    
    [self.scrollview addSubview:self.view1];
    
  

    
    self.scrollview.pagingEnabled = YES;
    self.scrollview.scrollEnabled = NO;
}

//注册
-(void)rightButtonTouch{
    RegistViewController *regist = [[RegistViewController alloc]init];
//    regist.mobile = self.accountField.text;
    regist.block = self.loginSuccessBlock;
    [self.rt_navigationController pushViewController:regist animated:YES];
}

//退出
-(void)leftButtonTouch{
    [super leftButtonTouch];
//    [self.viewModel.loginRequest cancle];
}

#pragma mark ShadowLoginViewControllerDelegate

-(void)forgetPassword:(NSString *)mobil{
    ForgetPasswordViewController*forget = [[ForgetPasswordViewController alloc]init];
    if (mobil.length!=0) {
        forget.mobile = mobil;
    }
    [self.rt_navigationController pushViewController: forget animated:YES];
}

-(void)loginSucess{
    
    self.tagViewModel.request.uid = [UserModel shareInstance].uid;
    NSArray *temparray = [TagsModel findAll];
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:1];
    [temparray enumerateObjectsUsingBlock:^(TagsModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ids addObject:obj.id];
    }];
    self.tagViewModel.request.tags = [ids componentsJoinedByString:@","];
    self.tagViewModel.request.startRequest = YES;
//    self.viewModel.request.uid = [UserModel shareInstance].uid;
//    
//    @weakify(self)
//    [[RACObserve(self.viewModel, count) filter:^BOOL(id value) {
//        return self.viewModel.count;
//    }]subscribeNext:^(id x) {
//        @strongify(self)
//        if (x) {
//            [UserModel shareInstance].dynamicCount = self.viewModel.count;
//            [[UserModel shareInstance] updateToUserdefault];
// 
//        }else{
//            [self.rt_navigationController popViewControllerAnimated:YES];
//            if (self.loginSuccessBlock) {
//                self.loginSuccessBlock();
//                return;
//            }
//        }
//    }];
//    self.viewModel.request.startRequest = YES;
//    [self.rt_navigationController popViewControllerAnimated:YES];
//    if (self.loginSuccessBlock) {
//        self.loginSuccessBlock();
//        return;
//    }
}

-(void)changeView:(NSString *)viewName{
    if ([viewName isEqualToString:leftView]) {
        [self showNavigationTitle:@"密码登录"];
        [self showBarButton:NAV_RIGHT title:@"注册" fontColor:BlackColor333333];
        [self.scrollview setContentOffset: self.view1.frame.origin animated:YES];
    }else{
        [self showNavigationTitle:@"快速登录"];
        [self showBarButton:NAV_RIGHT title:@"" fontColor:BlackColor333333];
        [self.scrollview setContentOffset: self.view2.frame.origin animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginSuccess:(LoginSuccessBlock)successBlock{
    [self.rt_navigationController popViewControllerAnimated:YES];
    if (self.loginSuccessBlock != successBlock) {
        self.loginSuccessBlock = successBlock;
    }
}

-(void)thridLogin:(ThirdLoginType *)type{
    [self.thirdLogin loginWithLoginDetailType:ThirdLoginTypeWeichat];
}

-(ThirdLoginObject*)thirdLogin{
    if (!_thirdLogin) {
        _thirdLogin = [[ThirdLoginObject alloc]init];
    }
    return _thirdLogin;
}

-(GetUserPushDynamicViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [GetUserPushDynamicViewModel SceneModel];
    }
    return _viewModel;
}

-(XiHaoUserCheckTagsViewModel *)tagViewModel{
    if (!_tagViewModel) {
        _tagViewModel = [XiHaoUserCheckTagsViewModel SceneModel];
        
        [[RACObserve(_tagViewModel.request,state) filter:^BOOL(id value) {
            return _tagViewModel.request.succeed;
        }]subscribeNext:^(id x) {
            if (x) {
                
                [self.rt_navigationController popViewControllerAnimated:YES];
                if (self.loginSuccessBlock) {
                    self.loginSuccessBlock();
                    return;
                }
                
                [TagsModel deleteAll];
            }
        }];
    }
    return _tagViewModel;
}



@end
