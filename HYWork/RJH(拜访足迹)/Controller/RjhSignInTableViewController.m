//
//  RjhSignInTableViewController.m
//  HYWork
//
//  Created by information on 2017/5/26.
//  Copyright © 2017年 hongyan. All rights reserved.
//

#import "RjhSignInTableViewController.h"
#import "TestViewController.h"
#import "APIKey.h"
#import "RjhSignInTableCell.h"
#import "NSObject+Extension.h"
#import "RjhSignIn.h"
#import "MBProgressHUD+MJ.h"
#import "LoadViewController.h"
#import "RjhManager.h"
#import "Utils.h"
#import "MJExtension.h"

@interface RjhSignInTableViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,RjhSignInTableCellDelegate>

@property (nonatomic, strong) MAMapView  *mapView;
@property (nonatomic, strong)  AMapLocationManager *locationManager;
@property (nonatomic, strong)  RjhSignIn *signIn;
@end

@implementation RjhSignInTableViewController

#pragma mark - loadView
- (void)loadView {
    [super loadView];
    //1.初始化APIKey
    [self configureAPIKey];
    //2.初始化 mapView
    [self initMapView];
}

#pragma mark 初始化APIKey
- (void)configureAPIKey {
//    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
//    [AMapLocationServices sharedServices].apiKey = (NSString *)APIKey;
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

#pragma mark 初始化mapView
- (void)initMapView {
    self.mapView.delegate = self;
}

#pragma mark mapView 懒加载
- (MAMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] init];
    }
    return _mapView;
}

#pragma mark - initWithPlan
- (instancetype)initWithPlan:(RjhPlan *)plan {
    if (self = [super init]) {
        _plan = plan;
        _logid = [plan.logid intValue];
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化参数
    [self configLocationManager];
    // 显示用户位置
    self.mapView.showsUserLocation = YES;
    // 设置导航栏的内容
    [self setupNavBar];
    // 初始化数据
    [self setupData];
    // 获取打卡总数
    [self getSignInCount];
}

#pragma mark 初始化configLocationManager
- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
}

#pragma mark 设置导航栏的内容
- (void)setupNavBar {
    // title
    self.navigationItem.title = @"快速签到";
    // 左边按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"30"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    // tableView
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark leftBarButtonItem返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 初始化数据
- (void)setupData {
    NSArray *dateAndTime = [RjhSignInTableViewController getCurrentWeekDateAndTime];
    self.signIn.date = [dateAndTime objectAtIndex:0];
    self.signIn.time = [dateAndTime objectAtIndex:1];
    self.signIn.signin = @"正在定位...";
    self.signIn.imageName = @"shuaxindinweiH";
    self.signIn.canClick = NO;
    self.signIn.ygxm = [LoadViewController shareInstance].emp.ygxm;
}

#pragma mark 懒加载signIn对象
- (RjhSignIn *)signIn {
    if (_signIn == nil) {
        _signIn = [[RjhSignIn alloc] init];
    }
    return _signIn;
}

#pragma mark 
- (void)getSignInCount {
    NSString *userid = [LoadViewController shareInstance].emp.ygbm;
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[userid,_plan.logdate] forKeys:@[@"userid",@"logdate"]];
    [RjhManager postJosnWithUserId:params success:^(id json) {
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            NSDictionary *dict = [json objectForKey:@"data"];
            if (![dict isKindOfClass:[NSNull class]]) {
                self.signIn.count = [[dict objectForKey:@"count"] intValue];
                // 局部刷新
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    } fail:^{
        [MBProgressHUD showError:@"获取今日签到总次数出错"];
    }];
}

#pragma mark - 注册当app从后台进入前台的时候出发的事件
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark app从后台进入前台触发的事件
- (void)appWillEnterForegroundNotification {
    [self setupData];
    [self.tableView reloadData];
    [self getCurrentLocation];
}

#pragma mark - 当view消失的时候,注销通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getCurrentLocation];
}

#pragma mark getCurrentLocation 
- (void)getCurrentLocation {
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [weakSelf didRefreshLocationWithLocation:location ReGeocode:regeocode Error:error];
    }];
}

#pragma mark 更新定位信息
- (void)didRefreshLocationWithLocation:(CLLocation *)location ReGeocode:(AMapLocationReGeocode *)regeocode Error:(NSError *)error{
    if (error) {
        self.signIn.signin = @"网络连接异常...";
        self.signIn.signin_latitude = 0;
        self.signIn.signin_longitude = 0;
    }else{
        self.signIn.signin = regeocode.formattedAddress;
        self.signIn.signin_latitude = location.coordinate.latitude;
        self.signIn.signin_longitude = location.coordinate.longitude;
        MACircle *visiable = [MACircle circleWithCenterCoordinate:location.coordinate radius:200];
        [self.mapView setVisibleMapRect:visiable.boundingMapRect animated:YES];
    }
    self.signIn.imageName = @"shuaxindinweiN";
    self.signIn.canClick = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark
/**
 *  连续定位回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    NSLog(@"连续定位回调函数.......");
}

/**
@brief 位置或者设备方向更新后调用此接口
@param mapView 地图View
@param userLocation 用户定位信息(包括位置与设备方向等数据)
@param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
*/
#pragma mark - MAMapViewDelegate 如何用户地址更新,超出当前页面就刷新
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        CGSize size = self.mapView.frame.size;
        CGPoint point = [self.mapView convertCoordinate:userLocation.coordinate toPointToView:self.mapView];
        if ((point.x <= 0 || point.y <= 0 || point.x >= size.width || point.y >= size.height) && self.signIn.canClick) {
            MACircle *visiable = [MACircle circleWithCenterCoordinate:userLocation.coordinate radius:200];
            [self.mapView setVisibleMapRect:visiable.boundingMapRect animated:YES];
        }
    }
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取cell
    RjhSignInTableCell *cell = [RjhSignInTableCell cellWithTableView:tableView indexPath:indexPath];
    if (indexPath.row == 2) {
        cell.mapView = self.mapView;
        [cell.contentView addSubview:self.mapView];
    }
    NSLog(@"map = %@",NSStringFromCGRect(self.mapView.frame));
    // 给cell赋值
    cell.signIn = self.signIn;
    cell.delegate = self;
    
    return cell;
}


#pragma mark - table cell delegate
- (void)signInTableCellRefreshLocation:(RjhSignInTableCell *)signInCell {
    [self setupData];
    [self.tableView reloadData];
    [self getCurrentLocation];
}

/** 点击签到按钮 */
- (void)signInTableCell:(RjhSignInTableCell *)signInCell {
    [MBProgressHUD showMessage:@"正在签到中..." toView:self.view];
    __weak typeof(self) weakSelf = self;
    [self.mapView takeSnapshotInRect:self.tableView.bounds withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        [weakSelf signIn:resultImage];
    }];
}

- (void)signIn:(UIImage *)image {
    // 封装参数
    NSString *ygbm = [LoadViewController shareInstance].emp.ygbm;
    self.signIn.userid = ygbm;
    self.signIn.action = @"1";
    self.signIn.logid =  self.logid;
    self.signIn.type = _plan.type==0 ? 4 : _plan.type;
    NSDictionary *planDict = [_plan mj_keyValues];
    NSDictionary *signDict = [self.signIn mj_keyValues];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:planDict];
    [params addEntriesFromDictionary:signDict];
    [RjhManager postJsonWithParameters:params signInImage:image success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *header = [json objectForKey:@"header"];
        if ([[header objectForKey:@"succflag"] intValue] > 1) {
            [MBProgressHUD showError:[[Utils getDict] objectForKey:[header objectForKey:@"errorcode"]]];
        }else{
            [MBProgressHUD showSuccess:@"签到成功"];
//            if([self.delegate respondsToSelector:@selector(signInTableViewDidClickSignInBtn:)]){
//                [self.delegate signInTableViewDidClickSignInBtn:self];
//            }
//            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:signInSuccess object:nil userInfo:nil];
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[NSClassFromString(@"RjhTableViewController") class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }

        }
    } fail:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
}


#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80.0f;
    }else if (indexPath.row == 1) {
        return 60.0f;
    }else if (indexPath.row == 2) {
        return 230.0f;
    }else{
        return self.view.frame.size.height - 370.0f - 64.0f;
    }
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
