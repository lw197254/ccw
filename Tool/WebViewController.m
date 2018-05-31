//
//  WebViewControlllerViewController.m
//  Qumaipiao
//
//  Created by 刘伟 on 16/1/12.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewProgressView.h"
#import "WebViewProgress.h"
@interface WebViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>
@property(nonatomic,strong)WebViewProgressView*progressView;
@property(nonatomic,strong)WebViewProgress*progress;
@end


@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:self.titleString];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]init];
    _progress = [[WebViewProgress alloc]init];
    _webView.delegate = _progress;
    _progress.webViewProxyDelegate = self;
    _progress.progressDelegate = self;
    [self.view addSubview:_webView];
    _progressView = [[WebViewProgressView alloc]init];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(2*1);
    }];
   
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    _webView.backgroundColor = [UIColor whiteColor];
    
    [self reloadWebView];
    [self showbackButtonwithTitle:@"back.png"];
//    @weakify(self);
//    [[RACObserve(self.webView, goBack)
//     filter:^BOOL(id value) {
//         return self.webView.goBack;
//     }]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         [self leftButtonTouch];
//     }];
  
}
-(void)leftButtonTouch{
    if (_webView.canGoBack == YES) {
        [_webView goBack];
    }else{
        [self.rt_navigationController popViewControllerAnimated:YES complete:^(BOOL finished) {
             [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        }];
    }
   
}
-(void)reloadWebView{
    
    if (_urlString!=nil) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];

    }

}
-(void)webViewProgress:(id)webViewProgress updateProgress:(float)progress{
    if (progress==1) {
        [self webViewDidFinishLoad:self.webView];
    }
    [_progressView setProgress:progress animated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
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
