//
//  ModifyPasswordViewController.m
//  TMC_lutao
//
//  Created by 刘伟 on 16/4/11.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "UserModel.h"
#import "ModifyPasswordViewModel.h"
#import "Timer.h"
#import "GetVerificationCodeViewModel.h"
#import "NewPasswordViewController.h"

@interface ForgetPasswordViewController ()

@property(nonatomic,strong)GetVerificationCodeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *getPasscodeButton;
@property(nonatomic,strong)Timer*timer;
@end

@implementation ForgetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [GetVerificationCodeViewModel SceneModel];
    [self showNavigationTitle:@"忘记密码"];
    if (self.mobile.length > 0) {
        self.mobileField.text = self.mobile;
    }
    @weakify(self);
    [[RACSignal combineLatest:@[self.mobileField.rac_textSignal,self.passcodeField.rac_textSignal] reduce:^(NSString*acount,NSString*password){
        return @(acount.isNotEmpty&&password.isNotEmpty);
    }]subscribeNext:^(NSNumber *res) {
        @strongify(self);
        if (res.boolValue == NO) {
           
            self.confirmButton.enabled = NO;
            
        }else{
            
            self.confirmButton.enabled = YES;
            
        }
    }];
//    [[RACObserve(self.viewModel.passwordRequest, state)
//            filter:^BOOL(id value) {
//                @strongify(self);
//                return self.viewModel.passwordRequest.succeed;
//            }]
//           subscribeNext:^(id x) {
//                @strongify(self);
//               NewPasswordViewController*newVC = [[NewPasswordViewController alloc]init];
//               newVC.mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
//               [self.navigationController pushViewController:newVC animated:YES];
////               [AlertView showAlertWithMessage:@"密码修改成功,请重新登陆" confirmBlock:^{
////                   [self dismissViewControllerAnimated:YES completion:nil];
////               } withVC:self];
//          
//           }];
            [[RACObserve(self.viewModel.codeRequest, state)
              filter:^BOOL(id value) {
                  @strongify(self);
                  return self.viewModel.codeRequest.succeed;
              }]
             subscribeNext:^(id x) {
                 [[DialogView sharedInstance]showDlg:self.view textOnly:@"验证码已发送，请注意查收"];
                 
    
             }];

    [[RACObserve(self.viewModel.codeRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.codeRequest.failed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          [self.timer stopTimer];
          self.getPasscodeButton.enabled = YES;
          
      }];
    [[RACObserve(self.viewModel.checkCodeRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.checkCodeRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          self.viewModel.passwordRequest.mobile =self.viewModel.checkCodeRequest.mobile;
          
          self.viewModel.passwordRequest.code =self.viewModel.checkCodeRequest.code;
          NewPasswordViewController*vc = [[NewPasswordViewController alloc]init];
          vc.viewModel  = self.viewModel;
          [self.rt_navigationController pushViewController:vc animated:YES];
          
      }];
   
    

    // Do any additional setup after loading the view from its nib.
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

- (IBAction)ConfirmClicked:(UIButton *)sender
{
    [self.mobileField resignFirstResponder];
    [self.passcodeField resignFirstResponder];
    
    
    NSString*mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    NSString* passCode = [self.passcodeField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
  
    if(mobile.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号不能为空"];
        return;
    }else if (mobile.length != 11||[[mobile substringToIndex:1] integerValue]!=1){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号格式不正确"];
        return;
    }

    
    if(passCode.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"验证码不能为空"];
        return;
    }
    self.viewModel.checkCodeRequest.mobile = mobile;
    self.viewModel.checkCodeRequest.code = passCode;
    
    self.viewModel.checkCodeRequest.startRequest = YES;
   

    
    
//    self.viewModel.passwordRequest.mobile = _mobileField.text;
//    self.viewModel.passwordRequest.code = _passcodeField.text;
//        [self.passcodeField resignFirstResponder];
//
//    self.viewModel.passwordRequest.startRequest = YES;
//    @weakify(self);
//    [[RACObserve(self.viewModel.passwordRequest, state)
//      filter:^BOOL(id value) {
//          @strongify(self);
//          return self.viewModel.passwordRequest.succeed;
//      }]
//     subscribeNext:^(id x) {
//         [AlertView showAlertWithMessage:@"密码修改成功,请重新登陆" confirmBlock:^{
//             [self dismissViewControllerAnimated:YES completion:nil];
//         } withVC:self];
//    
//     }];

//    NSString*oldPassword = [_oldPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString*newPassWord = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString*confirmPassword = [_confirmPasswordFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (![newPassWord isEqualToString:confirmPassword]) {
//        return;
//    }
//    [self.viewModel.request.params setObject:newPassWord forKey:@"newPwd"];
//    [self.viewModel.request.params setObject:oldPassword forKey:@"oldPwd"];
//    [self.viewModel.request.params setObject:[UserModel shareInstance].userCode forKey:@"username"];
//    self.viewModel.request.startRequest = YES;
//    @weakify(self);
//    [[RACObserve(self.viewModel.request, state)
//    filter:^BOOL(id value) {
//        @strongify(self);
//        return self.viewModel.request.succeed;
//    }]
//    subscribeNext:^(id x) {
//        [UserModel loginOut];
//        
//    }];
    
}

- (IBAction)getPasscodeClicked:(UIButton *)sender
{
    [self.mobileField resignFirstResponder];
    [self.passcodeField resignFirstResponder];
    NSString*mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    NSString* passCode = [self.passcodeField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    
    if(mobile.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号不能为空"];
        return;
    }else if (mobile.length != 11||[[mobile substringToIndex:1] integerValue]!=1){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号格式不正确"];
        return;
    }
    self.viewModel.codeRequest.mobile = mobile;
  
        self.viewModel.codeRequest.msgtype = msgTypeFindPasswordBack;
    
    self.viewModel.codeRequest.startRequest = YES;
    sender.enabled = NO;
   self.timer =  [Timer timerWithTimeInerval:60 repeatBlock:^(NSString *time) {
        [sender setTitle:time forState:UIControlStateNormal];
        //       sender.titleLabel.text = time;
    } finishedRepeat:^(NSString *title) {
        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
        //        sender.titleLabel.text = @"获取验证码";
        sender.enabled = YES;
    } ];

//    if (_mobileField.text.length == 11)
//    {
//        sender.userInteractionEnabled = NO;
//        [Timer timerWithTimeInerval:10 repeatBlock:^(NSString *time) {
//            NSString *sentStr = [NSString stringWithFormat:@"(%@s)已发送",time];
//            [sender setTitle:sentStr forState:UIControlStateNormal];
//            sender.backgroundColor = [UIColor darkGrayColor];
//        } finishedRepeat:^(NSString *title) {
//            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
//            sender.userInteractionEnabled = YES;
//            sender.backgroundColor = OrangeColor;
//            
//        }];
//        self.viewModel.codeRequest.mobile = _mobileField.text;
//        self.viewModel.codeRequest.startRequest = YES;
//        @weakify(self);
//        [[RACObserve(self.viewModel.codeRequest, state)
//          filter:^BOOL(id value) {
//              @strongify(self);
//              return self.viewModel.codeRequest.succeed;
//          }]
//         subscribeNext:^(id x) {
//             [AlertView showAlertWithMessage:@"验证码已发送，请注意查收"];
//        
//         }];
//
//    }
//    else
//        [AlertView showAlertWithMessage:@"手机号码不正确"];
}



@end
