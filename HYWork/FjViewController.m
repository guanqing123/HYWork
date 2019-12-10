//
//  FjViewController.m
//  HYWork
//
//  Created by information on 16/8/4.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "FjViewController.h"

@interface FjViewController ()
@property (nonatomic, strong)  WKWebView *webView;
@property (nonatomic, strong)  NSURLRequest *request;
@property (nonatomic, strong)  WKWebViewConfiguration *configure;
@end

@implementation FjViewController

- (instancetype)initWithRequest:(NSURLRequest *)request Configuration:(WKWebViewConfiguration *)configuration {
    if (self = [super init]) {
        _request = request;
        _configure = configuration;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem  *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = left;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:_configure];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [_webView loadRequest:_request];
    [self.view addSubview:_webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
