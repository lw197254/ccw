//
//  RegistViewController.m
//  12123
//
//  Created by 刘伟 on 2016/9/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistViewModel.h"
#import "CheckmobileRequest.h"
#import "Timer.h"

#import "WebViewController.h"
#import "NickNameViewController.h"
@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getPasscodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property(nonatomic,strong)RegistViewModel*viewModel;

@property(nonatomic,strong)Timer*timer;
@end

@implementation RegistViewController
- (IBAction)getPassCodeClicked:(UIButton*)sender {
    [self.mobileField resignFirstResponder];
    [self.passCodeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    NSString*mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
 
    if(mobile.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号不能为空"];
        return;
    }else if (mobile.length != 11||[[mobile substringToIndex:1] integerValue]!=1){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号格式不正确"];
        return;
    }
  
   
    self.viewModel.codeRequest.mobile = mobile;
    self.viewModel.checkMobileRequest.mobile = mobile;
    self.viewModel.checkMobileRequest.startRequest = YES;
//    self.viewModel.codeRequest.startRequest = YES;
    sender.enabled = NO;
   self.timer = [Timer timerWithTimeInerval:60 repeatBlock:^(NSString *time) {
       NSString*timeString = [time stringByAppendingString:@"S"];
        [sender setTitle:timeString forState:UIControlStateNormal];
//       sender.titleLabel.text = time;
    } finishedRepeat:^(NSString *title) {
        [sender setTitle:@"重新获取" forState:UIControlStateNormal];
//        sender.titleLabel.text = @"获取验证码";
        sender.enabled = YES;
    } ];
    

}


/// 同意用户协议
- (IBAction)agreeProtocolButtonClicked:(UIButton *)sender {
    WebViewController*vcc = [[WebViewController alloc]init];
    //  vcc.urlString = [NSString stringWithFormat:@"%@/protocol",urlBottom];
    [MobClick event:findpage_protocal];
    // [UMSAgent postEvent:findpage_protocal];
    
    vcc.urlString = @"http://m.checheng.com/agreement.html";
    vcc.titleString  =@"用户协议";
    [self.rt_navigationController pushViewController:vcc animated:YES];

}
- (IBAction)securyTextChanged:(UIButton *)sender {
    sender.selected  =!sender.selected;
    self.passwordField.secureTextEntry = !sender.selected;
}

//注册
- (IBAction)confirmClicked:(UIButton *)sender {
    [MobClick event:findpage_regist];
   // [UMSAgent postEvent:findpage_regist];
    [self.mobileField resignFirstResponder];
    [self.passCodeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    NSString*mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    NSString* passCode = [self.passCodeField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    NSString* password =  [self.passwordField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    if(mobile.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号不能为空"];
        return;
    }else if (mobile.length != 11||[[mobile substringToIndex:1] integerValue]!=1){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号格式不正确"];
         return;
    }
    
    if(password.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"密码不能为空"];
        return;
    }else if (password.length < 6){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"密码长度不能小于6位"];
        return;
    }else if(password.length > 12){
         [[DialogView sharedInstance]showDlg:self.view textOnly:@"密码长度不能大于12位"];
        
        return;
    }else if (![ZhengZeBianMa checkPasswordInputWithStr:password]){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"密码只能为数字和字符"];
         return;
    }

    if(passCode.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"验证码不能为空"];
        return;
    }
    
   
    self.viewModel.registRequest.mobile =mobile;
    
    self.viewModel.registRequest.code =passCode;
    self.viewModel.registRequest.pwd = password;
    
    self.viewModel.registRequest.startRequest = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [RegistViewModel SceneModel];
    [self showNavigationTitle:@"注册"];
    self.mobileField.text = self.mobile;
//    self.codeButton.titleLabel.text = @"获取验证码";
    @weakify(self);
        [[RACSignal combineLatest:@[self.mobileField.rac_textSignal,self.passwordField.rac_textSignal,self.passCodeField.rac_textSignal] reduce:^(NSString*mobile,NSString*password,NSString*passCode){
           
            return @(mobile.isNotEmpty&&password.isNotEmpty&&passCode.isNotEmpty);
    }]subscribeNext:^(NSNumber* enabled) {
        @strongify(self);
        if (enabled.boolValue == NO) {
            
            self.confirmButton.enabled = NO;
            
        }else{
            
            self.confirmButton.enabled = YES;
            
        }

    }];
      [RACObserve(self.viewModel.checkMobileRequest, state) subscribeNext:^(id x) {
          @strongify(self);
        if (self.viewModel.checkMobileRequest.succeed) {
            self.viewModel.codeRequest.startRequest = YES;

        }else if(self.viewModel.checkMobileRequest.failed){
            self.getPasscodeButton.enabled = YES;
             [self.getPasscodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.timer stopTimer];
        }
        
    }];
    [[RACObserve(self.viewModel.userInfoRequest,state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.userInfoRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          
          [[UserModel shareInstance] mergeFromDictionary:self.viewModel.userInfoRequest.output[@"data"] useKeyMapping:YES];
          [self registSuccess];
          //          [self.navigationController popViewControllerAnimated:YES];
          //[[DialogUtil sharedInstance]showDlg:self.view textOnly:[@"成功"]];
          //         self.dataArray = self.viewModel.model.data;
          //        [self.tableView reloadData];
          
      }];

    
    
    
    [[RACObserve(self.viewModel.codeRequest, state)
     filter:^BOOL(id value) {
         @strongify(self);
         return self.viewModel.codeRequest.succeed;
     }]subscribeNext:^(id x) {
          @strongify(self);
         [[DialogView sharedInstance]showDlg:self.view textOnly:@"验证码已发送"];
        
         
     }];
    [[RACObserve(self.viewModel.codeRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.codeRequest.failed;
      }]subscribeNext:^(id x) {
           @strongify(self);
          [self.timer stopTimer];
           [self.getPasscodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
          self.getPasscodeButton.enabled = YES;
          
      }];
    [[RACObserve(self.viewModel.registRequest, state)
    filter:^BOOL(id value) {
        @strongify(self);
        return  self.viewModel.registRequest.succeed;
    }]subscribeNext:^(id x) {
        @strongify(self);
        [UserModel shareInstance].uid = [self.viewModel.registRequest.output valueForKeyPath:@"data.uid"];
        [[UserModel shareInstance]updateToUserdefault];
        self.viewModel.userInfoRequest.uid = [UserModel shareInstance].uid;
        self.viewModel.userInfoRequest.startRequest = YES;
//       __block UIViewController*vc;
//        [self.rt_navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj isKindOfClass:[LoginViewController class]]) {
//                if(((LoginViewController*)obj).loginSuccessBlock){
//                    ((LoginViewController*)obj).loginSuccessBlock();
//                }
//                *stop  = YES;
//                vc = self.rt_navigationController.viewControllers[idx-1];
//            }
//            
//        }];
//        [AlertView showAlertWithMessage:@"注册成功" confirmBlock:^{
//            [self.navigationController popToViewController:vc animated:YES];
//        } withVC:self];
        
        
    }];

    // Do any additional setup after loading the view from its nib.
    
    //添加点击事件
//    UITapGestureRecognizer* protocol = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpweb)];
//    [_userprotocol addGestureRecognizer:protocol];
//    //文字下划线
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString: self.userprotocol.text];
//    NSRange contentRange = {0,self.userprotocol.text.length};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//    self.userprotocol.attributedText = content;
//    _userprotocol.userInteractionEnabled = YES;
}
-(void)registSuccess{
    [[DialogView sharedInstance]showDlg:[UIApplication sharedApplication].keyWindow textOnly:@"注册成功"];
    NickNameViewController*vc = [[NickNameViewController alloc]init];
    vc.block = self.block;
    [self presentViewController:vc animated:YES completion:^{
        
    }];

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
