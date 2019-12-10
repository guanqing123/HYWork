//
//  WKFromMonthController.m
//  HYWork
//
//  Created by information on 2019/8/27.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKFromMonthController.h"
#import "LoadViewController.h"
#import <WebKit/WebKit.h>

@interface WKFromMonthController ()
@property (nonatomic, weak) WKWebView  *webView;
@property (nonatomic, copy) NSString *xh;
@property (nonatomic, copy) NSString *ygbm;
@property (nonatomic, copy) NSString *ygxm;
@end

@implementation WKFromMonthController

- (NSString *)ygbm {
    if (_ygbm == nil) {
        _ygbm = [LoadViewController shareInstance].emp.ygbm;
    }
    return _ygbm;
}

- (NSString *)ygxm {
    if (_ygxm == nil) {
        _ygxm = [LoadViewController shareInstance].emp.ygxm;
    }
    return _ygxm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = self.view.bounds;
    _webView = webView;
    [self.view addSubview:webView];
    self.title = @"月计划";
    
    NSString *urlStr = [NSString stringWithFormat:@"http://dev.sge.cn/hyamd/message/monthlist.html?ygbm=%@&ygxm=%@",self.ygbm,self.ygxm];
    NSString *encode = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encode]]];
    
    // 1.返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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

