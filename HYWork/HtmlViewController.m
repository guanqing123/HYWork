//
//  HtmlViewController.m
//  HYWork
//
//  Created by information on 16/6/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "HtmlViewController.h"
#import "Html.h"

@interface HtmlViewController ()<UIWebViewDelegate>

@end

@implementation HtmlViewController

- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置标题
    self.title = self.html.title;
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    
    // 创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.html.html withExtension:nil];
    
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 发送请求加载网页
    [webView loadRequest:request];
    
    // 设置左上角的关闭按钮
//    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:6.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  网页加载完毕的时候调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 调到id对应的网页标签
    
    // 1.拼接Javascript代码
    NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@';", self.html.ID];
    // 2.执行JavaScript代码
    [webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark -屏幕横竖屏设置
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
