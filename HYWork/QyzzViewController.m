//
//  QyzzViewController.m
//  HYWork
//
//  Created by information on 16/7/7.
//  Copyright © 2016年 hongyan. All rights reserved.
//  企业组织

#import "QyzzViewController.h"
#import "GyhyManager.h"
#import <WebKit/WebKit.h>

@interface QyzzViewController () <WKNavigationDelegate>
{
    float changeY;
}
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, strong)  UIButton *refreshBtn;
@end

@implementation QyzzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"企业组织";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self getQyzz];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.frame = CGRectMake(0, HWTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH);
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)getQyzz {
    NSString *url = @"http://218.75.78.166:9101/app/api";
    [GyhyManager getQyzzWithUrl:url success:^(id json) {
        NSDictionary *data = [json objectForKey:@"data"];
        if (data) {
            NSDictionary *list = [data objectForKey:@"list"];
            NSURL *url = [NSURL URLWithString:@"http://218.75.78.166:9101"];
            [self.webView loadHTMLString:[list objectForKey:@"content"] baseURL:url];
        }
    } fail:^{
        [self refresh];
    }];
}

#pragma mark - refresh 刷新
- (void)refresh {
    if (_refreshBtn == nil)
    {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _refreshBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 50.0f, self.view.frame.size.height / 2 - 20.0f, 100.0f, 40.0f);
        
        [_refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _refreshBtn.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:157.0f/255.0f blue:133.0f/255.0f alpha:1];
        [_refreshBtn addTarget:self action:@selector(getQyzz) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_refreshBtn];
    }
}

#pragma mark - navigation delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark 横竖屏切换
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            changeY = HWTopNavH;
        }
        else
        {
            changeY = 32.0f;
        }
        
        _webView.frame = CGRectMake(0.0f, changeY, self.view.frame.size.width , self.view.frame.size.height - changeY);
        
    }
    else
    {
        _webView.frame = CGRectMake(0.0f, changeY, self.view.frame.size.width , self.view.frame.size.height - changeY);
    }
}

#pragma mark -屏幕横竖屏设置
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
