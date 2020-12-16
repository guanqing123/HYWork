//
//  WKCPKJViewController.m
//  HYWork
//
//  Created by information on 2019/3/22.
//  Copyright © 2019年 hongyan. All rights reserved.
//

#import "WKCPKJViewController.h"
#import "WebViewJavascriptBridge.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "SSZipArchive.h"
#import "LoadViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define WKVersionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"version.plist"]
#define WKCPKJPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@interface WKCPKJViewController () <SSZipArchiveDelegate,UIWebViewDelegate>
@property (nonatomic, weak) UIWebView  *webView;
@property (nonatomic, strong)  WebViewJavascriptBridge *bridge;
@property (nonatomic, weak) UIBarButtonItem  *selectItem;
@property (nonatomic, copy) NSString *shareUrl;
@end

@implementation WKCPKJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 0.初始化页面
    [self setupNav];
    // 1.初始化webView
    [self setupWebView];
    // 2.加载html
    [self downloadZipArchive];
    
}


#pragma mark - setupNav
- (void)setupNav {
    // 回退
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 标题
    self.title = @"产品空间";
    
    // 设置右侧导航栏
    [self setupRightNav];
}

- (void)setupRightNav {
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(select)];
    _selectItem = selectItem;
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItems = @[shareItem,selectItem];
}

- (void)share{
    WEAKSELF
    [self.bridge callHandler:@"sharePanel" data:nil responseCallback:^(id responseData) {
        NSString *code = responseData[@"code"];
        if ([code isEqualToString:@"500"]) {
            NSString *message = responseData[@"message"];
            [MBProgressHUD showError:message];
        }else{
            NSArray *shareArray = responseData[@"data"];
            NSString *imageUrl;
            NSString *titleStr;
            NSMutableString *idStr = [NSMutableString string];
            NSMutableString *textStr = [NSMutableString string];
            for (int i = 0; i < shareArray.count; i++) {
                NSDictionary *dict = shareArray[i];
                if (i == 0) {
                    imageUrl = dict[@"img"];
                    titleStr = dict[@"name"];
                }
                if (i == shareArray.count - 1) {
                    [idStr appendString:dict[@"id"]];
                    [textStr appendString:dict[@"name"]];
                }else{
                    [idStr appendString:dict[@"id"]];
                    [idStr appendString:@","];
                    [textStr appendString:dict[@"name"]];
                    [textStr appendString:@","];
                }
            }
            [weakSelf societyShare:titleStr idStr:idStr imageUrl:imageUrl text:textStr];
        }
    }];
}

- (void)societyShare:(NSString *)title idStr:(NSString *)idStr imageUrl:(NSString *)imageUrl text:(NSString *)text {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *account = [LoadViewController shareInstance].emp.ygbm;
    //WEAKSELF
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",self.shareUrl,idStr,account];
    [shareParams SSDKSetupShareParamsByText:text images:imageUrl url:[NSURL URLWithString:urlStr] title:title type:SSDKContentTypeAuto];
        
        /*[ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                     switch (state) {
                                         case SSDKResponseStateSuccess:
                                         {
                                             [weakSelf select];
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                             [alertView show];
                                             break;
                                         }
                                         case SSDKResponseStateFail:
                                         {
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                             [alert show];
                                             break;
                                         }
                                         default:
                                             break;
                                     }
                                 }];*/
    [ShareSDK showShareActionSheet:nil //(第一个参数要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，在ipad中要想弹出我们的分享菜单，这个参数必须要传值，可以传自己分享按钮的对象，或者可以创建一个小的view对象去传，传值与否不影响iphone显示)
                       customItems:nil
                       shareParams:shareParams
                sheetConfiguration:nil
                    onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];

}

- (void)select{
    WEAKSELF
    if ([self.selectItem.title isEqualToString:@"选择"]) {
        [self.bridge callHandler:@"openCheckPanel" data:@{@"select" : @true} responseCallback:^(id responseData) {
            [weakSelf.selectItem setTitle:@"取消"];
        }];
    }else{
        [self.bridge callHandler:@"openCheckPanel" data:@{@"select" : @false} responseCallback:^(id responseData) {
            [weakSelf.selectItem setTitle:@"选择"];
        }];
    }
}

- (void)back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - setupWebView
- (void)setupWebView {
    
//    NSString *html = @"<p><iframe webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" frameborder="0" height="498" width="510" src="//player.youku.com/embed/XNDE1MzY5MDk2MA" class="note-video-clip"></iframe></p><p>1234444</p>";
    
    //NSString *html = @"<p><iframe webkitallowfullscreen='' mozallowfullscreen='' allowfullscreen='' frameborder='0' height='498' width='510' src='//player.youku.com/embed/XNDE1MzY5MDk2MA' class='note-video-clip'></iframe></p><p>1234444</p>";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - HWStatusBarH)];
    
//    [webView loadHTMLString:html baseURL:nil];
    //[webView loadData:[html dataUsingEncoding:NSUTF8StringEncoding] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"http://www.player.youku.com"]];
    
    webView.delegate = self;
    _webView = webView;
    [self.view addSubview:webView];
     NSString *account = [LoadViewController shareInstance].emp.ygbm;
    //开启调试信息
//    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    //设置代理
    [self.bridge setWebViewDelegate:self];
    WEAKSELF
    [self.bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        [MBProgressHUD showMessage:@"正在加载中..." toView:weakSelf.view];
        responseCallback(@{@"uid" : account});
    }];
    [self.bridge registerHandler:@"hideLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        responseCallback(@{});
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView canGoBack]) {
        if (self.navigationItem.rightBarButtonItems) {
            self.navigationItem.rightBarButtonItems = nil;
        }
    }else{
        if (!self.navigationItem.rightBarButtonItems) {
            [self setupRightNav];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([webView canGoBack]) {
        if (self.navigationItem.rightBarButtonItems) {
            self.navigationItem.rightBarButtonItems = nil;
        }
    }else{
        if (!self.navigationItem.rightBarButtonItems) {
            [self setupRightNav];
        }
    }
}

#pragma mark - downloadZipArchive
- (void)downloadZipArchive {
    NSURL *jsUrl = [NSURL URLWithString:@"https://honyar.oss-cn-hangzhou.aliyuncs.com/cpkj.js"];
    NSData *jsData = [NSData dataWithContentsOfURL:jsUrl];
    NSDictionary *jsDict = [NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *version = [jsDict objectForKey:@"version"];
    self.shareUrl = [jsDict objectForKey:@"shareUrl"];
    NSString *root = [jsDict objectForKey:@"root"];
    NSDictionary *localDict = [NSDictionary dictionaryWithContentsOfFile:WKVersionFile];
    if (localDict != nil && (
                             [[localDict objectForKey:@"cpkj"] compare:version] == NSOrderedSame ||
                             [[localDict objectForKey:@"cpkj"] compare:version] == NSOrderedDescending
                             )) {
        NSString *index = [jsDict objectForKey:@"index"];
        NSString *htmlStr = [WKCPKJPATH stringByAppendingPathComponent:index];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlStr isDirectory:NO]]];
    }else{
        [MBProgressHUD showMessage:@"loading..." toView:self.view];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isExists = [fileManager fileExistsAtPath:[WKCPKJPATH stringByAppendingPathComponent:root]];
        if (isExists) {
            [fileManager removeItemAtPath:[WKCPKJPATH stringByAppendingPathComponent:root] error:nil];
        }
        
        //远程地址
        NSString *urlStr = [jsDict objectForKey:@"url"];
        NSURL *URL = [NSURL URLWithString:urlStr];
        
        //默认配置
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        WEAKSELF
        
        //请求
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            // - block的返回值,要求返回一个URL,返回的这个URL就是文件的位置的路径
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
            [MBProgressHUD hideHUDForView:weakSelf.view];
            // 将NSURL转成NSString
            NSString *urlStr = [filePath path];
            //解压
            [SSZipArchive unzipFileAtPath:urlStr toDestination:WKCPKJPATH delegate:weakSelf];
            //删除zip
            [[NSFileManager defaultManager] removeItemAtPath:urlStr error:nil];
            
            if (localDict != nil) {
                [localDict setValue:version forKey:@"cpkj"];
                [localDict writeToFile:WKVersionFile atomically:YES];
            }else{
                NSDictionary *dict = [NSDictionary dictionaryWithObject:version forKey:@"cpkj"];
                [dict writeToFile:WKVersionFile atomically:YES];
            }
            [self downloadZipArchive];
        }];
        [download resume];
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
    return UIInterfaceOrientationMaskPortrait;
}

@end
