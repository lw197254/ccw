//
//  CompanyIntroduceViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/4.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CompanyIntroduceViewController.h"
#import "CompanyInfoViewModel.h"
#import "PhoneCallWebView.h"
#import "AskForPriceViewController.h"
@interface CompanyIntroduceViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreButton;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstaint;

///可能需要隐藏的界面
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property(nonatomic,strong)CompanyInfoViewModel* viewModel;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@end

@implementation CompanyIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.line1.backgroundColor = BlackColorE3E3E3;
    self.line2.backgroundColor = BlackColorE3E3E3;
    self.line3.backgroundColor = BlackColorE3E3E3;
     self.line4.backgroundColor = BlackColorE3E3E3;
    [self showNavigationTitle:@"公司介绍"];
    self.viewModel = [CompanyInfoViewModel SceneModel];
    self.viewModel.request.dealerId = self.dealerId;
    self.viewModel.request.startRequest = YES;
    [self.loadMoreButton exchangeImageAndTitle];
    @weakify(self);
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        [self.scrollView dismissWithOutDataView];
        return self.viewModel.model.isNotEmpty;
        
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self updateUIData];
    }];
    [[RACObserve(self.viewModel.request, state)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.request.failed;
        
    }]subscribeNext:^(id x) {
        @strongify(self);
        [self.scrollView showNetLost];
    }];

    
    // Do any additional setup after loading the view from its nib.
}
-(void)updateUIData{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片105_80"] ];
    self.companyNameLabel.text = self.viewModel.model.name;
    NSString*address;
    if (self.viewModel.model.address.isNotEmpty) {
        address = [@"地址：" stringByAppendingString:self.viewModel.model.address];
    }else{
        address = @"地址：暂无";
    }
    
    self.addressLabel.attributedText =[address stringWithParagraphlineSpeace:10 textColor:BlackColor999999 textFont:FontOfSize(14)];
    
    NSString*info = self.viewModel.model.content;
    if (info.isNotEmpty) {
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[info dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.textView.attributedText = attrStr;
          self.textViewHeightConstaint.priority = 200;
        CGSize size = [self.textView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        if (size.height< self.textViewHeightConstaint.constant) {
            self.textViewHeightConstaint.constant = size.height;
             self.textViewHeightConstaint.priority = 900;
              [self.loadMoreButton setHidden:YES];
            [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.00001);
            }];
            
        }else{
            self.textViewHeightConstaint.priority = 900;
            self.textViewHeightConstaint.constant = 200;
              [self.loadMoreButton setHidden:NO];
        }
        

    }else{
        [self.companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.00001);
        }];
        
        [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.00001);
        }];
        
        
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.00001);
        }];
        
        [self.loadMoreButton setHidden:YES];

    }
  //    self.textView.attributedText = [info stringWithParagraphlineSpeace:10 textColor:self.textView.textColor textFont:self.textView.font];
    
//    _textViewHeightConstaint.constant = [self.textView.text getSpaceLabelHeightwithSpeace:10 withFont:self.textView.font withWidth:kwidth - 30];
    
   
}
- (IBAction)loadMoreClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender exchangeImageAndTitle];
    if (sender.selected) {
        _textViewHeightConstaint.priority = 249;
    }else{
        _textViewHeightConstaint.priority = 900;
    }
    
}
- (IBAction)callClicked:(UIButton *)sender {
    
    [PhoneCallWebView showWithTel:self.viewModel.model.service_phone];
    
}
- (IBAction)askForPriceClicked:(UIButton *)sender {
    [ClueIdObject setClueId:xunjia_19];
    AskForPriceViewController*vc = [[AskForPriceViewController alloc]init];
    vc.delearId  = self.dealerId;
    
    [self.rt_navigationController pushViewController:vc animated:YES];
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
