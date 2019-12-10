//
//  AppDelegate.m
//  HYWork
//
//  Created by information on 16/2/24.
//  Copyright © 2016年 hongyan. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageManager.h"

#import "GzjhViewController.h"

#import "NoticePushViewController.h"
#import "WKMeetingNoticeViewController.h"
#import "NavigationController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

// 腾讯开始平台(对应QQ和QQ空间) SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

// 微信SDK头文件
#import "WXApi.h"

// 新浪微博SDK头文件
#import "WeiboSDK.h"
// 新浪微博SDK需要在项目Build Setting中的Other Linker Flag添加"-ObjC"

#import "ATAppUpdater.h"

// 阿里Push
#import <CloudPushSDK/CloudPushSDK.h>
// iOS 10 notification
#import <UserNotifications/UserNotifications.h>

static NSString *const aliyunPushAppKey = @"24706589";
static NSString *const aliyunPushAppSecret = @"e885b335ad26fd25483e8f7e378f0576";

@interface AppDelegate () <UITabBarControllerDelegate,UNUserNotificationCenterDelegate>
{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}
@end

@implementation AppDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //这里我判断的是当前点击的tabBarItem的标题
    LoadViewController *loadController = [LoadViewController shareInstance];
    if ([viewController.tabBarItem.title isEqualToString:@"通讯录"]) {
        if (loadController.isLoaded) {
            return YES;
        }else{
            loadController.hidesBottomBarWhenPushed = YES;
            [((UINavigationController *)tabBarController.selectedViewController) pushViewController:loadController animated:YES];
            return NO;
        }
    }else{
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  app进入后台的时候调用
 *
 *  一般在这里保存应用的数据(游戏数据,比如暂停游戏)
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/**
 *  清除不需要再使用的内存
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    // 停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    // 清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  app启动完毕就会调用
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[ATAppUpdater sharedUpdater] showUpdateWithConfirmation];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _tabBarViewController = [[TabBarController alloc] init];
    _tabBarViewController.delegate = self;
    self.window.rootViewController = _tabBarViewController;
    [self.window makeKeyAndVisible];
    
    
//    NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"]);
//    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]);
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"14208624a6e82" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"3002122402" appSecret:@"9f9359d8ebf438a14bf11f1901f24a1e"
                    redirectUri:@"https://api.weibo.com/oauth2/default.html"
                        authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx56856a3367e14212" appSecret:@"24fcde9de9caaa524ada50fd58b97ca9"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1105487120" appKey:@"xG9WnFHlsJL7ZFSB" authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
    
    // aliyun push
    // 向苹果APNs注册获取deviceToken并上报到阿里云推送服务器
    [self registerAPNs:application];
    
    // SDK初始化
    [self initCloudPush];

    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    
    // 监听推送消息到达
    [self registerMessageReceive];
    
    //点击通知将App从关闭状态启动时,将通知打开回执上报
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    // 初始化用户的登录状态
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefault objectForKey:@"emp"];
    if (userData) {
        Emp *emp = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if (emp.mm == nil)
            return YES;
        [LoginManager postJSONWithUrl:HYURL gh:emp.ygbm mm:emp.mm success:^(id json) {
            NSDictionary *header = [json objectForKey:@"header"];
            if ([[header objectForKey:@"succflag"] intValue] == 1) {
                LoadViewController *loadViewController = [LoadViewController shareInstance];
                loadViewController.emp = emp;
                loadViewController.loading = YES;
                NSString *temp = loadViewController.emp.ecologyid;
                NSString *ecologyid = [NSString stringWithFormat:@"%@",temp];
                [CloudPushSDK bindAccount:ecologyid withCallback:^(CloudPushCallbackResult *res) {
                    if (res.success) {
                        NSLog(@"帐号%@绑定成功...",ecologyid);
                    }else{
                        NSLog(@"帐号 绑定 error = %@",res.error);
                    }
                }];
            }
        } fail:^{
            
        }];
        /*LoadViewController *loadViewController = [LoadViewController shareInstance];
        loadViewController.emp = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        loadViewController.loading = YES;
        NSString *temp = loadViewController.emp.ecologyid;
        NSString *ecologyid = [NSString stringWithFormat:@"%@",temp];
        [CloudPushSDK bindAccount:ecologyid withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"帐号%@绑定成功...",ecologyid);
            }else{
                NSLog(@"帐号 绑定 error = %@",res.error);
            }
        }];*/
    }
    
    return YES;
}

#pragma mark - SDK Init
- (void)initCloudPush {
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];
    // SDK初始化
    [CloudPushSDK asyncInit:aliyunPushAppKey appSecret:aliyunPushAppSecret callback:^(CloudPushCallbackResult *res) {
        if(res.success){
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        }else{
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

#pragma mark - APNs Register
/**
 向APNs注册,获取deviceToken用于推送
 
 @param application 当前应用
 */
- (void)registerAPNs:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(systemVersionNum >= 10.0){
        // IOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        // 创建 category,并注册到通知中心
        [self createCustomNotificationCategory];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册,获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            }else{
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    }else if (systemVersionNum >= 8.0){
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }else{
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

/**
 创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

/**
 APNs注册成功回调,将返回到deviceToken上传到CloudPush服务器

 @param application 当前应用
 @param deviceToken 成功后的deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    NSLog(@"Upload deviceToken to CloudPush server.");
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success = %@, deviceId : %@",[CloudPushSDK getApnsDeviceToken],[CloudPushSDK getDeviceId]);
        }else{
            NSLog(@"Register deviceToken failed, error: %@",res.error);
        }
    }];
}

/**
 APNs注册失败回调

 @param application 当前应用
 @param error 错误信息
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@",error);
}



/**
 App处于前台时收到通知(iOS 10+)

 @param center 通知中心
 @param notification 通知
 @param completionHandler 回调
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    //处理 iOS 10通知,并上报通知打开回执
    //[self handleiOS10Notification:notification];
    //通知不弹出来
//    completionHandler(UNNotificationPresentationOptionNone);
    
    //通知弹出,且带有声音、内容和角标
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}


/**
 处理iOS 10通知(iOS 10+)

 @param notification 通知
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *url = [userInfo valueForKey:@"url"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, url: %@.", noticeDate, title, subtitle, body, badge, url);
    
    if (url) {
        NSString *newUrl = nil;
        NSRange range = [url rangeOfString:@"meeting/meetingDetail.html?hyid="];
        NSRange srange = [url rangeOfString:@"&ygbm"];
        NSRange workplan = [url rangeOfString:@"workplan"];
        if (range.location != NSNotFound && srange.location == NSNotFound) {
            LoadViewController *loadVc = [LoadViewController shareInstance];
            newUrl = [url stringByAppendingString:[NSString stringWithFormat:@"&ygbm=%@",loadVc.emp.ygbm]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WKMeetingNoticeViewController *noticePush = [[WKMeetingNoticeViewController alloc] initWithUrlPath:newUrl];
                NavigationController *pushNav = [[NavigationController alloc] initWithRootViewController:noticePush];
                [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
            });
        }else if(workplan.location != NSNotFound){
            GzjhViewController *workPlanVc = [[GzjhViewController alloc] init];
            [workPlanVc setPop:YES];
            NavigationController *pushNav = [[NavigationController alloc] initWithRootViewController:workPlanVc];
            [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
        }else{
            newUrl = url;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NoticePushViewController *noticePush = [[NoticePushViewController alloc] initWithUrlPath:newUrl];
                NavigationController *pushNav = [[NavigationController alloc] initWithRootViewController:noticePush];
                [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
            });
        }
    }
}


/**
 触发通知动作时回调,比如点击、删除通知和点击自定义action(iOS 10+)

 @param center 通知中心
 @param response 反馈
 @param completionHandler 回调
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
        [MBProgressHUD showError:@"User dismissed the notification."];
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
        [MBProgressHUD showError:@"User custom action1."];
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
        [MBProgressHUD showError:@"User custom action2."];
    }
    completionHandler();
}

#pragma mark - Notification Open

/**
 App处于启动状态时，通知打开回调

 @param application 当前应用
 @param userInfo 信息
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *url = [userInfo valueForKey:@"url"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], url = [%@]", content, (long)badge, sound, url);
    if (url) {
        NSString *newUrl = nil;
        NSRange range = [url rangeOfString:@"meeting/meetingDetail.html?hyid="];
        NSRange srange = [url rangeOfString:@"&ygbm"];
        NSRange workplan = [url rangeOfString:@"workplan"];
        if (range.location != NSNotFound && srange.location == NSNotFound) {
            LoadViewController *loadVc = [LoadViewController shareInstance];
            newUrl = [url stringByAppendingString:[NSString stringWithFormat:@"&ygbm=%@",loadVc.emp.ygbm]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WKMeetingNoticeViewController *noticePush = [[WKMeetingNoticeViewController alloc] initWithUrlPath:newUrl];
                NavigationController *pushNav = [[NavigationController alloc] initWithRootViewController:noticePush];
                [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
            });
        }else if(workplan.location != NSNotFound){
            GzjhViewController *workPlanVc = [[GzjhViewController alloc] init];
            NavigationController *pushNav = [[NavigationController alloc] initWithRootViewController:workPlanVc];
            [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
        }else{
            newUrl = url;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NoticePushViewController *noticePush = [[NoticePushViewController alloc] initWithUrlPath:newUrl];
                NavigationController *pushNav = [[NavigationController alloc] initWithRootViewController:noticePush];
                [self.window.rootViewController presentViewController:pushNav animated:YES completion:nil];
            });
        }
    }
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 同步通知角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}

#pragma mark - Channel Opened
/**
 注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChannelOpened:) name:@"CCPDidChannelConnectedSuccess" object:nil];
}

/**
 推送通道打开回调

 @param notification 通知
 */
- (void)onChannelOpened:(NSNotification *)notification{
    NSLog(@"推送通道打开回调...");
}

#pragma mark - Receive Message
/**
 注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"CCPDidReceiveMessageNotification" object:nil];
}

/**
 处理到来推送消息

 @param notification 通知本事
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSString *content = [NSString stringWithFormat:@"Receive message title: %@, content: %@.", title, body];
    NSLog(@"Receive message title: %@,body: %@. content: %@.", title, body, content);
}

@end
