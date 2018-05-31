//
//  NickNameViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/8.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "NickNameViewController.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"
#import "UserInfoViewModel.h"
@interface NickNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UserInfoViewModel*viewModel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.titleString.isNotEmpty) {
         self.titleLabel.text = self.titleString;
    }else{
         self.titleLabel.text = @"昵称";
    }
    self.viewModel = [UserInfoViewModel viewModel];
    
    [self addRAC];
    ///隐藏跳过按钮
    self.skipButton.hidden = self.hideRightButton;
   
}
-(void)addRAC{
    @weakify(self);
    [[RACSignal combineLatest:@[self.nickNameField.rac_textSignal] reduce:^(NSString*acount){
        return @(acount.isNotEmpty);
    }]subscribeNext:^(NSNumber *res) {
        @strongify(self);
        if (res.boolValue == NO) {
            
            self.saveButton.enabled = NO;
            
        }else{
           
            self.saveButton.enabled = YES;
            
        }
    }];
    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.request.succeed||self.viewModel.request.failed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.request.succeed) {
            [UserModel shareInstance].nickname = self.viewModel.request.nickname;
            [[UserModel shareInstance]updateToUserdefault];
            if (self.nickNameModifySuccessBlock) {
                self.nickNameModifySuccessBlock(self.viewModel.request.nickname);
            }
            [self cancelClicked:nil];
        }
       
        
    }];
    
//    [[RACSignal combineLatest:@[self.nickNameField.rac_textSignal] reduce:^(NSString*nickName){
//        return @([ZhengZeBianMa checkUserNameInputWithStr:nickName]);
//       
//    }]subscribeNext:^(NSNumber *res) {
//        @strongify(self);
//        if (res.boolValue == YES) {
//            self.saveButton.userInteractionEnabled  = YES;
//            [self.saveButton setBackgroundColor: LightBlueColor];
//        }else{
//            self.saveButton.userInteractionEnabled = NO;
//            [self.saveButton setBackgroundColor:[LightBlueColor colorWithAlphaComponent:0.3]];
//        }
//    }];

}
- (IBAction)backClicked:(UIButton *)sender {
    [self cancelClicked:nil];
}
- (IBAction)cancelClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        CustomNavigationController*nav =   [Tool currentNavigationController ];
        
        if (nav.rt_viewControllers.count-2 >0&&[nav.rt_viewControllers[nav.rt_viewControllers.count-2] isKindOfClass:[ShadowLoginViewController class]]) {
            [nav popToViewController:nav.rt_viewControllers[nav.rt_viewControllers.count-1-2] animated:YES];
            if (_block) {
                _block();
            }
        }else if (nav.rt_viewControllers.count-1 >0&&[nav.rt_viewControllers[nav.rt_viewControllers.count-1] isKindOfClass:[RegistViewController class]]) {
            [nav popToViewController:nav.rt_viewControllers[nav.rt_viewControllers.count-1-1] animated:YES];
            if (_block) {
                _block();
            }
            
        }
    }];

}

- (IBAction)saveButtonClicked:(UIButton *)sender {
    [self.nickNameField resignFirstResponder];
    NSString*name = [self.nickNameField.text  stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    if (name.length == 0) {
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"用户名不能为空"];
        return;
    }
    if(![ZhengZeBianMa checkNickNameWithStr:name]){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"用户名格式错误"];
        return;
    }
    self.viewModel.request.nickname = name;
    self.viewModel.request.startRequest = YES;
    
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
