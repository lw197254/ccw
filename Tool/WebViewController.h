//
//  WebViewControlllerViewController.h
//  Qumaipiao
//
//  Created by 刘伟 on 16/1/12.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface WebViewController : ParentViewController
@property(nonatomic,strong)UIWebView*webView;
@property(nonatomic,copy)NSString*urlString;
@property(nonatomic,copy)NSString*titleString;
-(void)webViewDidFinishLoad:(UIWebView *)webView;


-(void)reloadWebView;
@end
