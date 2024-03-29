//
//  WKZlkhViewController.m
//  HYWork
//
//  Created by information on 2018/11/20.
//  Copyright © 2018年 hongyan. All rights reserved.
//

#import "WKZlkhViewController.h"
#import <WebKit/WebKit.h>

@interface WKZlkhViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, weak) WKWebView  *webView;
@property (nonatomic, copy) NSString *xh;
@property (nonatomic, copy) NSString *ywy;

@end

@implementation WKZlkhViewController

- (instancetype)initWithXh:(NSString *)xh ywy:(NSString *)ywy{
    if (self = [super init]) {
        _xh = xh;
        _ywy = ywy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 设置导航 */
    [self setupNav];
    
    /** 设置webView */
    [self setupWebView];
}

/** 设置导航 */
- (void)setupNav{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.title = @"战略客户开发";
    
    // 设置view不要延伸
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)back {
    if (self.webView.loading) {[self.webView stopLoading];}
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 设置 webView */
- (void)setupWebView {
    NSString *url = [NSString stringWithFormat:@"http://sge.cn:9106/app/web/crmShowKhxxZlkh?xh=%@&ywy=%@",_xh,_ywy];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HWTopNavH)];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    _webView = webView;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

- (void)dealloc {
    self.webView.navigationDelegate = nil;
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
