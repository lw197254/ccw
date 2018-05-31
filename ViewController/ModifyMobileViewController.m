//
//  ModifyMobileViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/5/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ModifyMobileViewController.h"
#import "ModifyMobileViewModel.h"
#import "CheckmobileRequest.h"
#import "Timer.h"
@interface ModifyMobileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getPasscodeButton;


@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property(nonatomic,strong)ModifyMobileViewModel*viewModel;
@property(nonatomic,strong)Timer*timer;
@end

@implementation ModifyMobileViewController



- (IBAction)getPassCodeClicked:(UIButton*)sender {
    
    NSString*mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    
    if(mobile.length ==0){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号不能为空"];
        return;
    }else if (mobile.length != 11||[[mobile substringToIndex:1] integerValue]!=1){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号格式不正确"];
        return;
    }
    [self.mobileField resignFirstResponder];
    [self.passCodeField resignFirstResponder];
   
    
    
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



//注册
- (IBAction)confirmClicked:(UIButton *)sender {
    [MobClick event:findpage_regist];
    // [UMSAgent postEvent:findpage_regist];
    [self.mobileField resignFirstResponder];
    [self.passCodeField resignFirstResponder];
  
    
    NSString*mobile = [self.mobileField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    NSString* passCode = [self.passCodeField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
   
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
    
    
    self.viewModel.request.mobile =mobile;
    
    self.viewModel.request.code =passCode;
   
    
    self.viewModel.request.startRequest = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [ModifyMobileViewModel SceneModel];
    [self showNavigationTitle:@"修改手机号码"];
   
   
    @weakify(self);
    [[RACSignal combineLatest:@[self.mobileField.rac_textSignal,self.passCodeField.rac_textSignal] reduce:^(NSString*acount,NSString*password){
        return @(acount.isNotEmpty&&password.isNotEmpty);
    }]subscribeNext:^(NSNumber *res) {
        @strongify(self);
        if (res.boolValue == NO) {
            
            self.confirmButton.enabled = NO;
            
        }else{
            
            self.confirmButton.enabled = YES;
            
        }
    }];
      [RACObserve(self.viewModel.checkMobileRequest, state) subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.checkMobileRequest.succeed) {
            self.viewModel.codeRequest.mobile = self.viewModel.checkMobileRequest.mobile;
            self.viewModel.codeRequest.msgtype = msgTypeModifyMobile;
            self.viewModel.codeRequest.startRequest = YES;
            
        }else if(self.viewModel.checkMobileRequest.failed){
            self.getPasscodeButton.enabled = YES;
            [self.getPasscodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.timer stopTimer];
        }
        
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
    [[RACObserve(self.viewModel.request, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return  self.viewModel.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          [UserModel shareInstance].mobile =self.viewModel.request.mobile;
          
          //       __block UIViewController*vc;
          //        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          //            if ([obj isKindOfClass:[LoginViewController class]]) {
          //                if(((LoginViewController*)obj).loginSuccessBlock){
          //                    ((LoginViewController*)obj).loginSuccessBlock();
          //                }
          //                *stop  = YES;
          //                vc = self.navigationController.viewControllers[idx-1];
          //            }
          //
          //        }];
          //        [AlertView showAlertWithMessage:@"注册成功" confirmBlock:^{
          //            [self.navigationController popToViewController:vc animated:YES];
          //        } withVC:self];
          [[DialogView sharedInstance]showDlg:[UIApplication sharedApplication].keyWindow textOnly:@"手机号修改成功"];
         
          [self.rt_navigationController popViewControllerAnimated:YES];
          
          
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
