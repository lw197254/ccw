//
//  FeedBackViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/2/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackViewModel.h"
#import "DialogView.h"

@interface FeedBackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *commite;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property(nonatomic,assign)NSString *placeholder;

@property(nonatomic,strong)FeedBackViewModel *viewModel;





@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.placeholder = @"请填写您需要反馈的内容";

    [self setTitle:@"意见反馈"];
    self.messageTextView.text = self.placeholder;
    self.messageTextView.textColor = BlackColor999999;
    self.messageTextView.delegate = self;
    
    [self.commite setBackgroundColor:BlackColorF1F1F1];
    
    
    
    
}


//实时的显示文字个数
-(void)initTextView{

}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView isEqual:self.messageTextView]){
        if([textView.text isEqualToString:self.placeholder]){
            textView.text=@"";
            textView.textColor=BlackColor333333;
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([textView isEqual:self.messageTextView]){
        if(textView.text.length ==0 ){
            textView.text =self.placeholder;
            textView.textColor = BlackColor999999;
            self.countLabel.text = @"0/100";
            [self.commite setBackgroundColor:BlackColorF1F1F1];
        }else if(textView.text.length<=100){
            NSString *info = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
            info = [info stringByAppendingString:@"/100"];
            self.countLabel.text = info;
            [self.commite setBackgroundColor:BlueColor447FF5];
        }else{
             NSString *info = [NSString stringWithFormat:@"%@",textView.text];
             info = [info substringWithRange:NSMakeRange(0, 100)];
             textView.text = info;
        }
    }
}

- (IBAction)callService:(id)sender {
    

    NSString *phoneNumber = self.phone.text;
   ///手机号可以为空,如果不为空则验证手机号
    
    if (([phoneNumber isNotEmpty]&&
        phoneNumber.length==11&&[[phoneNumber substringToIndex:1] isEqualToString:@"1"])||!phoneNumber.isNotEmpty) {
        
    }else{
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号格式错误"];
        return;
    }
    
    
    if (self.messageTextView.text.length>0) {
        self.viewModel = [FeedBackViewModel SceneModel];
        self.viewModel.request.content = self.messageTextView.text;
        self.viewModel.request.contact = phoneNumber;
        self.viewModel.request.name = self.name.text;
        self.viewModel.request.startRequest = YES;
        
        
        [RACObserve(self.viewModel, isok) subscribeNext:^(id x) {
            if (self.viewModel.isok) {
                [[DialogView sharedInstance]showDlg:self.view textOnly:@"发送成功"];
                [self leftButtonTouch];
            }
        }];
    }else{
         [[DialogView sharedInstance]showDlg:self.view textOnly:@"意见不能为空"];
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
