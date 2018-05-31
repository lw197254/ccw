//
//  NewPasswordViewController.m
//  12123
//
//  Created by 刘伟 on 2016/9/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "ModifyPasswordViewModel.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"
@interface NewPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    [self showNavigationTitle:@"设置新密码"];
    
    @weakify(self);
    [[RACSignal combineLatest:@[self.passwordField.rac_textSignal] reduce:^(NSString*password){
        return @(password.isNotEmpty);
    }]subscribeNext:^(NSNumber *res) {
        @strongify(self);
        if (res.boolValue == NO) {
            
            self.confirmButton.enabled = NO;
            
        }else{
           
            self.confirmButton.enabled = YES;
            
        }
    }];
    
    [[RACObserve(self.viewModel.passwordRequest, state)
      filter:^BOOL(id value) {
          @strongify(self);
          return  self.viewModel.passwordRequest.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
         
              __block UIViewController*vc;
              [self.rt_navigationController.rt_viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  if ([obj isKindOfClass:[ShadowLoginViewController class]]) {
                      *stop  = YES;
                     
                           if(((ShadowLoginViewController*)obj).loginSuccessBlock){
                          ((ShadowLoginViewController*)obj).loginSuccessBlock();
                           }
                            vc = self.rt_navigationController.rt_viewControllers[idx-1];
                             [self.rt_navigationController popToViewController:vc animated:YES];
                       }else{
                           [AlertView showAlertWithMessage:@"密码修改成功，请重新登录" confirmBlock:^{
                               [self.rt_navigationController popToViewController:obj animated:YES];
                               
                           } withVC:self];
                       }
                 
                      
                      
                      
              }];

          
         
      
    }];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)confirmButtonClicked:(UIButton *)sender {
    [self.passwordField resignFirstResponder];
    
  
   
    NSString* password =  [self.passwordField.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    
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
    

    
    
    self.viewModel.passwordRequest.pwd = password;
    
    self.viewModel.passwordRequest.startRequest = YES;
}
- (IBAction)securyTextChanged:(UIButton *)sender {
    sender.selected  =!sender.selected;
    self.passwordField.secureTextEntry = !sender.selected;
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
