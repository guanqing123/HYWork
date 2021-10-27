//
//  MyViewController.m
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "MyViewController.h"
#import "SettingItem.h"
#import "SettingArrowItem.h"
#import "SettingSwitchItem.h"
#import "SettingGroup.h"
#import "LoadViewController.h"
#import "LYConstans.h"

// 任务点检
#import "WKRenwuViewController.h"
// 决策分析
#import "WKJCFXViewController.h"
// 通讯录
#import "WKAddressListViewController.h"

//扫一扫
#import "BeforeScanSingleton.h"
#import "WKBaseWebViewController.h"

#import "HelpViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LoadViewController.h"
#import "AboutViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

// 阿里Push
#import <CloudPushSDK/CloudPushSDK.h>

@interface MyViewController () <LoadViewControllerDelegate,UIAlertViewDelegate,SubLBXScanViewControllerDelegate>
/**
 * 显示登录信息
 */
@property (nonatomic, strong)  UILabel *label;

/**
 *  未登录/用户名
 */
@property (nonatomic, copy) NSString *loginMsg;

/**
 *  登录控制器
 */
@property (nonatomic, strong)  LoadViewController *loadController;

/**
 *  按钮标题
 */
@property (nonatomic, copy) NSString *btnTitle;

/**
 *  按钮颜色
 */
@property (nonatomic, strong)  UIColor *btnColor;

/**
 *  用户对象
 */
@property (nonatomic, strong)  Emp *emp;

@property (nonatomic, copy) NSString *url;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.添加数据
    [self initData];
    
    // IOS 11
    if(@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    // 2.扫一扫
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStyleDone target:self action:@selector(scan)];
    self.navigationItem.leftBarButtonItem = left;
}

//扫一扫
- (void)scan {
    LoadViewController *loadVc = [LoadViewController shareInstance];
    if (!loadVc.isLoaded) {
        loadVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loadVc animated:YES];
        return;
    }
    [[BeforeScanSingleton shareScan] ShowSelectedType:QQStyle WithViewController:self];
}

#pragma mark -扫一扫代理
- (void)subLBXScanViewController:(SubLBXScanViewController *)subLBXScanViewController resultStr:(NSString *)result {
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if ([result hasPrefix:@"http"] || [result hasPrefix:@"https"]) {
            WKBaseWebViewController *webVc = [[WKBaseWebViewController alloc] initWithDesUrl:result];
            webVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVc animated:YES];
        } else {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"扫码结果" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
            [alertVc addAction:okAction];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 1.判断有没有登录
    [self judgeLogin];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
        [imageView setImage:[UIImage imageNamed:@"bg.jpg"]];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120.0f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20 weight:2];
        label.text = _loginMsg;
        _label = label;
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 50, self.view.frame.size.width - 40, 40);
        [btn setTitle:_btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = _btnColor;
        [btn addTarget:self action:@selector(loginOrExit) forControlEvents:UIControlEventTouchUpInside];
        
        [btn.layer masksToBounds];
        [btn.layer setCornerRadius:5.0f];
        
        [footerView addSubview:btn];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 100.0f;
    }
    return 0.0f;
}

- (void)loginOrExit {
    if (_loadController == nil) {
        _loadController = [LoadViewController shareInstance];
    }
    if (_loadController.isLoaded) {
        _loginMsg = @"未登录";
        
        _btnTitle = @"登 录";
        _btnColor = GQColor(0.0f, 157.0f, 133.0f);
        [self.tableView reloadData];
        
        _loadController.loading = NO;
        _loadController.emp = nil;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"emp"];
        [userDefaults synchronize];
        
        [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"解绑成功");
            }else{
                NSLog(@"解绑失败 error : %@",res.error);
            }
        }];
        
       [[NSNotificationCenter defaultCenter] postNotificationName:loginOutNotification object:nil userInfo:nil];
        
    }else{
        _loadController.title = @"登录";
        _loadController.hidesBottomBarWhenPushed = YES;
        _loadController.delegate = self;
        [self.navigationController pushViewController:_loadController animated:YES];
    }
}

// 登录完成之后,刷新原界面数据
- (void)loadViewControllerFinishLogin:(LoadViewController *)loadViewController {
    _emp = loadViewController.emp;
    _loginMsg = _emp.ygxm;
    _btnTitle = @"退出登录";
    _btnColor = [UIColor redColor];
    [self.tableView reloadData];
}

//- (void)test {
//    SettingItem *update = [SettingArrowItem itemWithIcon:@"MoreUpdate" title:@"检查新版本"];
//    update.option = ^{
//        // 弹框提示
//        [MBProgressHUD showMessage:@"正在拼命检查中....."];
//        
//#warning 发送网络请求
//        // 几秒后消失
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 移除HUD
//            [MBProgressHUD hideHUD];
//            
//            // 提醒有没有新版本
//            [MBProgressHUD showError:@"没有新版本"];
//        });
//    };
//    SettingItem *help = [SettingArrowItem itemWithIcon:@"MoreHelp" title:@"帮助" destVcClass:[LoadViewController class]];
//    SettingItem *share = [SettingArrowItem itemWithIcon:@"MoreShare" title:@"分享" destVcClass:[LoadViewController class]];
//    SettingItem *viewMsg = [SettingArrowItem itemWithIcon:@"MoreMessage" title:@"查看消息" destVcClass:nil];
//    
//    __weak typeof(self) selfVc = self;
//    viewMsg.option = ^{
//        NSLog(@"%@", selfVc.tableView.subviews);
//    };
//    
//    SettingItem *product = [SettingArrowItem itemWithIcon:@"MoreNetease" title:@"产品推荐" destVcClass:[LoadViewController class]];
//    SettingItem *about = [SettingArrowItem itemWithIcon:@"MoreAbout" title:@"关于" destVcClass:[LoadViewController class]];
//    
//    SettingGroup *group = [[SettingGroup alloc] init];
//    group.items = @[update, help, share, viewMsg, product, about, update, help, share, viewMsg, product, about];
//    [self.data addObject:group];
//}

/**
 *  判断有没有登录
 */
- (void)judgeLogin {
    LoadViewController *loadController = [LoadViewController shareInstance];
    _loadController = loadController;
    if (loadController.isLoaded) {
        _loginMsg = loadController.emp.ygxm;
        _btnTitle = @"退出登录";
        _btnColor = [UIColor redColor];
        [self.tableView reloadData];
    }else{
        _loginMsg = @"未登录";
        _btnTitle = @"登录";
        _btnColor = GQColor(0.0f, 157.0f, 133.0f);
        [self.tableView reloadData];
    }
}

/**
 *  初始化数据
 */
- (void)initData {
    // tableView
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 目标任务点检
    SettingItem *renwu = [SettingArrowItem itemWithIcon:@"renwu" title:@"目标任务点检" destVcClass:[WKRenwuViewController class] loaded:YES];
    // 园区生活
    SettingItem *park = [SettingArrowItem itemWithIcon:@"myjcfx" title:@"决策分析" destVcClass:[WKJCFXViewController class] loaded:YES];
    // 通讯录
    SettingItem *concats = [SettingArrowItem itemWithIcon:@"concats" title:@"通讯录" destVcClass:[WKAddressListViewController class] loaded:YES];
    
    SettingGroup *group0 = [[SettingGroup alloc] init];
    group0.items = @[renwu, park, concats];
    [self.data addObject:group0];
    
    
    //帮助
    SettingItem *help = [SettingArrowItem itemWithIcon:@"help" title:@"帮助" destVcClass:[HelpViewController class] loaded:NO];
    
    //自动登陆
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"自动登录"];
    [defaults synchronize];
    
    SettingItem *autoLogin = [SettingSwitchItem itemWithIcon:@"zidongdenglu" title:@"自动登录"];
    
    //分享
    SettingItem *share = [SettingArrowItem itemWithIcon:@"fenxiang" title:@"分享" destVcClass:nil loaded:NO];
    share.option = ^{
        // 1.创建分享参数
        NSArray *imageArray = @[[UIImage imageNamed:@"shareImg"]];
        if (imageArray) {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"鸿雁云商是一款针对于鸿雁内部服务的客户端,欢迎下载:http://sge.cn:9106/appdownload" images:imageArray url:[NSURL URLWithString:@"http://sge.cn:9106/appdownload"] title:@"鸿雁云商APP下载" type:SSDKContentTypeAuto];
        // 2.分享(可以弹出我们的分享菜单和编辑界面)
            /*[ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                     items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                         switch (state) {
                                             case SSDKResponseStateSuccess:
                                             {
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
    };
    
    //检查新版本
    SettingItem *detection = [SettingArrowItem itemWithIcon:@"detection" title:@"检查新版本" destVcClass:nil loaded:NO];
    __weak typeof(self) selfVc = self;
    detection.option = ^{
        [selfVc detection];
    };
    
    //pifu
    SettingItem *pifu = [SettingSwitchItem itemWithIcon:@"pifu" title:PS];
    
    //关于
    SettingItem *about = [SettingArrowItem itemWithIcon:@"guanyu" title:@"关于" destVcClass:[AboutViewController class] loaded:NO];
    
    SettingGroup *group1 = [[SettingGroup alloc] init];
    group1.items = @[help,autoLogin, share, pifu, about];
    [self.data addObject:group1];
}

#pragma mark - 检查新版本
- (void)detection {
    [MBProgressHUD showMessage:@"正在检测中..." toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    params[@"version"] = [dict objectForKey:@"CFBundleShortVersionString"];
    [LoginManager checkVersionWithUrl:HYURL params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *data = [json objectForKey:@"data"];
        if (![data isEqual:[NSNull null]] && [[data objectForKey:@"needUpdate"] intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"存在新版本,是否更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            alert.delegate = self;
            self.url = [data objectForKey:@"path"];
            [alert show];
        }else{
            [MBProgressHUD showSuccess:@"无新版本"];
        }
    } fail:^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
//        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/hong-yan-yun-shang/id1126254541?mt=8"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
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
