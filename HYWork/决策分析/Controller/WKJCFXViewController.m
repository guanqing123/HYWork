//
//  WKJCFXViewController.m
//  HYWork
//
//  Created by information on 2019/11/1.
//  Copyright © 2019 hongyan. All rights reserved.
//

#import "WKJCFXViewController.h"
#import "WKJCFXTool.h"

// controller
#import "LoadViewController.h"

@interface WKJCFXViewController ()

@property (nonatomic, weak) UIWebView  *webView;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end

@implementation WKJCFXViewController

- (instancetype)initWithUserName:(NSString *)username password:(NSString *)password {
    if (self = [super init]) {
        _username = username;
        _password = password;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"决策分析";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView = webView;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:@"http://218.75.78.166:9081/webroot/decision/url/mobile"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    LoadViewController *loadVc = [LoadViewController shareInstance];
    Emp *emp = loadVc.emp;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:@[emp.ygbm,emp.oamm] forKeys:@[@"fine_username",@"fine_password"]];
    [MBProgressHUD showMessage:@"loading..." toView:self.view];
    [WKJCFXTool jcfxsso:param success:^(id  _Nonnull json) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.webView loadRequest:request];
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"加载失败,请退出重试" toView:self.view];
    }];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.webView.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
